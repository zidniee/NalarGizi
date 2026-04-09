import 'package:flutter/material.dart';

class TipHarianCard extends StatelessWidget {
  const TipHarianCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        border: Border.all(color: Colors.amber[200]!),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ikon Bintang
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.amber[400],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.star, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          // Teks Tip
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TIP HARI INI",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Berikan ASI minimal 2 tahun untuk daya tahan optimal.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.amber[900],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          // Ikon Panah Kanan
          Icon(Icons.arrow_forward, color: Colors.amber[600], size: 20),
        ],
      ),
    );
  }
}
