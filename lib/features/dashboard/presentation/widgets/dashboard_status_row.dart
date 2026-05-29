import 'package:flutter/material.dart';

class DashboardStatusRow extends StatelessWidget {
  final double? weightKg;
  final int? ageMonths;
  final String? zScoreStatus;

  const DashboardStatusRow({
    super.key,
    this.weightKg,
    this.ageMonths,
    this.zScoreStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatCard("Usia Saat Ini", ageMonths?.toString() ?? "14", "Bulan"),
        const SizedBox(width: 12),
        _buildStatCard("Berat Badan", weightKg != null ? weightKg!.toStringAsFixed(1) : "9.8", "kg"),
        const SizedBox(width: 12),
        _buildStatusCard(zScoreStatus ?? "Normal"),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String unit) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Color(0xFFFFE4E6), fontSize: 10),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String status) {
    final isNormal = status.toLowerCase() == 'normal';
    final statusColor = isNormal ? Colors.green : Colors.orange;
    final statusIcon = isNormal ? Icons.check_circle : Icons.warning;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 12),
                const SizedBox(width: 4),
                Text(
                  "STATUS",
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
