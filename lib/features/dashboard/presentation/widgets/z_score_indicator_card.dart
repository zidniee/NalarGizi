import 'package:flutter/material.dart';

class ZScoreIndicatorCard extends StatelessWidget {
  const ZScoreIndicatorCard({super.key});

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Bulan ke-14",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
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
                left: MediaQuery.of(context).size.width * 0.45,
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
                const TextSpan(text: "Rayyan berada pada rentang "),
                TextSpan(
                  text: "Normal",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[600],
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
