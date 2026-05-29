import 'package:flutter/material.dart';

class ZScoreIndicatorCard extends StatelessWidget {
  final String? zScoreStatus;
  final double? weightKg;
  final double? heightCm;

  const ZScoreIndicatorCard({
    super.key,
    this.zScoreStatus,
    this.weightKg,
    this.heightCm,
  });

  Color _getStatusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('buruk')) return Colors.red[600]!;
    if (s.contains('kurang') || s.contains('lebih')) return Colors.orange[600]!;
    return Colors.green[600]!;
  }

  Color _getStatusBgColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('buruk')) return Colors.red[50]!;
    if (s.contains('kurang') || s.contains('lebih')) return Colors.orange[50]!;
    return Colors.green[50]!;
  }

  double _getIndicatorPosition(String status) {
    final s = status.toLowerCase();
    if (s.contains('buruk')) return 0.12;
    if (s.contains('kurang')) return 0.35;
    if (s.contains('normal')) return 0.58;
    if (s.contains('lebih')) return 0.80;
    return 0.58;
  }

  @override
  Widget build(BuildContext context) {
    final status = zScoreStatus ?? "Normal";
    final statusColor = _getStatusColor(status);
    final statusBgColor = _getStatusBgColor(status);
    final dotPosition = _getIndicatorPosition(status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Kartu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Indikator Z-Score (BB/U)",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF334155),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Garis Warna-warni
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                _buildColorBand("Buruk", Colors.red[400]!, 1),
                _buildColorBand("Kurang", Colors.yellow[600]!, 1),
                _buildColorBand("Normal", Colors.green[400]!, 2),
                _buildColorBand("Lebih", Colors.yellow[600]!, 1),
              ],
            ),
          ),

          // Titik Indikator & Teks Bawah
          const SizedBox(height: 4),
          Stack(
            children: [
              const SizedBox(height: 12, width: double.infinity),
              Positioned(
                left: MediaQuery.of(context).size.width * dotPosition,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              children: [
                const TextSpan(text: "Status gizi anak berada pada rentang "),
                TextSpan(
                  text: status,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi pembuat kotak warna
  Widget _buildColorBand(String label, Color color, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 20,
        color: color,
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
