/// Represents the synchronization state of a locally-stored record.
///
/// Every transactional record (growth, nutrition, posyandu, etc.) carries
/// a [SyncStatus] so the UI can show badges and the sync engine knows
/// which records still need to be pushed to the server.
enum SyncStatus {
  /// The record is fully synchronized with the server.
  synced,

  /// The record has been created or modified locally and is waiting
  /// for the next sync cycle to push it to the server.
  pending,

  /// The last sync attempt for this record failed. It will be retried
  /// on the next sync cycle.
  failed,
}
