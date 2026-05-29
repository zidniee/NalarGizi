
/// Represents a single queued synchronization operation that was
/// performed while the device was offline.
///
/// Each [SyncJobModel] is stored in the `sync_queue_box` Hive box
/// and processed sequentially by the [SyncManager] when connectivity
/// is restored.
class SyncJobModel {
  SyncJobModel({
    required this.jobId,
    required this.entityType,
    required this.entityLocalId,
    required this.operationType,
    required this.payload,
    required this.createdAt,
    this.retryCount = 0,
    this.lastTriedAt,
  });

  /// Unique identifier for this sync job (UUID).
  final String jobId;

  /// The entity type this operation targets.
  /// Must match backend expectations: `growth`, `nutrition_journal`,
  /// `meal`, `hydration`, `posyandu_schedule`, `immunization`.
  final String entityType;

  /// The client-side UUID of the record being operated on.
  final String entityLocalId;

  /// The type of operation: `create`, `update`, or `delete`.
  final String operationType;

  /// The full JSON payload to send to the server.
  /// For `delete` operations this may be an empty map.
  final Map<String, dynamic> payload;

  /// When this job was originally created.
  final DateTime createdAt;

  /// Number of failed retry attempts.
  int retryCount;

  /// Timestamp of the last failed attempt.
  DateTime? lastTriedAt;

  /// Maximum number of retries before the job is marked as permanently failed.
  static const int maxRetries = 5;

  /// Whether this job has exceeded the maximum retry threshold.
  bool get hasExceededRetries => retryCount >= maxRetries;

  /// Converts this model to a JSON-compatible map for Hive storage.
  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'entityType': entityType,
      'entityLocalId': entityLocalId,
      'operationType': operationType,
      'payload': payload,
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
      'lastTriedAt': lastTriedAt?.toIso8601String(),
    };
  }

  /// Creates a [SyncJobModel] from a Hive-stored map.
  factory SyncJobModel.fromMap(Map<dynamic, dynamic> map) {
    return SyncJobModel(
      jobId: map['jobId'] as String,
      entityType: map['entityType'] as String,
      entityLocalId: map['entityLocalId'] as String,
      operationType: map['operationType'] as String,
      payload: Map<String, dynamic>.from(map['payload'] as Map),
      createdAt: DateTime.parse(map['createdAt'] as String),
      retryCount: map['retryCount'] as int? ?? 0,
      lastTriedAt: map['lastTriedAt'] != null
          ? DateTime.parse(map['lastTriedAt'] as String)
          : null,
    );
  }

  /// Converts this job into the format expected by the backend
  /// `POST /api/v1/sync` endpoint's `operations` array element.
  Map<String, dynamic> toSyncPayload() {
    return {
      'action': operationType,
      'type': entityType,
      'clientUniqueId': entityLocalId,
      'data': payload,
    };
  }
}
