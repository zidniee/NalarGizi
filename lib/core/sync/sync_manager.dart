import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '../network/api_endpoints.dart';
import '../storage/hive_boxes.dart';
import '../storage/sync_job_model.dart';

/// Manages the offline-first synchronization lifecycle.
///
/// [SyncManager] listens for connectivity changes and dispatches pending
/// sync jobs to the backend's bulk synchronization endpoint when the
/// device regains an internet connection.
///
/// Usage:
/// ```dart
/// final syncManager = SyncManager(dio: apiClient.dio);
/// syncManager.initialize(); // call once at app startup
/// ```
class SyncManager {
  SyncManager({required this.dio});

  final Dio dio;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isSyncing = false;

  /// Starts listening for connectivity changes and triggers an immediate
  /// sync attempt if the device is already online.
  void initialize() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen(_onConnectivityChanged);

    // Attempt sync immediately in case we already have a connection.
    _attemptSync();
  }

  /// Cleans up resources. Call this when the app is being disposed.
  void dispose() {
    _connectivitySubscription?.cancel();
  }

  /// Enqueues a new sync job into the Hive sync queue.
  ///
  /// This should be called by repositories whenever a local write
  /// (create, update, delete) is performed while offline (or always,
  /// if the repo follows the "write local first" pattern).
  Future<void> enqueue(SyncJobModel job) async {
    final box = await Hive.openBox(HiveBoxes.syncQueue);
    await box.put(job.jobId, job.toMap());

    // Try to sync right away if we have connectivity.
    _attemptSync();
  }

  /// Removes a specific job from the queue after successful sync or
  /// when it has permanently failed.
  Future<void> _removeJob(String jobId) async {
    final box = await Hive.openBox(HiveBoxes.syncQueue);
    await box.delete(jobId);
  }

  // ── Private helpers ──────────────────────────────────────────────

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final hasConnection = results.any(
      (r) => r != ConnectivityResult.none,
    );
    if (hasConnection) {
      _attemptSync();
    }
  }

  Future<void> _attemptSync() async {
    if (_isSyncing) return;

    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = connectivityResults.any(
      (r) => r != ConnectivityResult.none,
    );
    if (!isOnline) return;

    _isSyncing = true;

    try {
      final box = await Hive.openBox(HiveBoxes.syncQueue);
      if (box.isEmpty) {
        _isSyncing = false;
        return;
      }

      // Collect all pending jobs, ordered by creation time.
      final jobs = <SyncJobModel>[];
      for (final key in box.keys) {
        final raw = box.get(key);
        if (raw is Map) {
          jobs.add(SyncJobModel.fromMap(raw));
        }
      }
      jobs.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      // Build the bulk sync payload.
      final operations = jobs
          .where((j) => !j.hasExceededRetries)
          .map((j) => j.toSyncPayload())
          .toList();

      if (operations.isEmpty) {
        _isSyncing = false;
        return;
      }

      final response = await dio.post(
        ApiEndpoints.sync,
        data: {
          'lastSyncedAt': DateTime.now().toUtc().toIso8601String(),
          'operations': operations,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        final results = (data['data']?['results'] as List<dynamic>?) ?? [];

        for (final result in results) {
          final resultMap = result as Map<String, dynamic>;
          final clientId = resultMap['clientUniqueId'] as String?;
          final status = resultMap['status'] as String?;

          if (clientId != null &&
              (status == 'synced' || status == 'deleted')) {
            // Remove successfully synced job from queue
            final matchingJob = jobs.firstWhere(
              (j) => j.entityLocalId == clientId,
              orElse: () => jobs.first,
            );
            await _removeJob(matchingJob.jobId);
          }
        }
      }
    } on DioException catch (_) {
      // Network error during sync — increment retry counts.
      final box = await Hive.openBox(HiveBoxes.syncQueue);
      for (final key in box.keys.toList()) {
        final raw = box.get(key);
        if (raw is Map) {
          final job = SyncJobModel.fromMap(raw);
          job.retryCount++;
          job.lastTriedAt = DateTime.now();
          await box.put(key, job.toMap());
        }
      }
    } finally {
      _isSyncing = false;
    }
  }
}
