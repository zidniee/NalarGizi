import 'package:flutter/material.dart';

class BagianRiwayatPertumbuhan extends StatelessWidget {
  final bool isBeratBadan;

  const BagianRiwayatPertumbuhan({super.key, required this.isBeratBadan});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Riwayat Pengukuran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildHistoryItem('Bulan 14 (Okt)', isBeratBadan ? '+400 gram' : '+1.5 cm', 
                          isBeratBadan ? '9.8 kg' : '76.5 cm', true),
        const SizedBox(height: 12),
        _buildHistoryItem('Bulan 13 (Sep)', isBeratBadan ? '+300 gram' : '+1.0 cm', 
                          isBeratBadan ? '9.4 kg' : '75.0 cm', false),
        const SizedBox(height: 12),
        _buildHistoryItem('Bulan 12 (Ags)', isBeratBadan ? '+300 gram' : '+1.5 cm', 
                          isBeratBadan ? '9.2 kg' : '74.5 cm', false),
        const SizedBox(height: 12),
        _buildHistoryItem('Bulan 11 (Jul)', isBeratBadan ? '+300 gram' : '+1.0 cm', 
                          isBeratBadan ? '8.9 kg' : '73.0 cm', false),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF43F5E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 8),
                Text('Tambah Pengukuran Baru', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(String title, String increase, String total, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFF43F5E).withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isActive ? const Color(0xFFF43F5E).withOpacity(0.3) : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFF43F5E).withOpacity(0.1) : Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.monitor_weight_outlined, color: isActive ? const Color(0xFFF43F5E) : Colors.grey.shade400),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.trending_up, color: Color(0xFF10B981), size: 14),
                    const SizedBox(width: 4),
                    Text(increase, style: const TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(total, style: TextStyle(color: isActive ? const Color(0xFFF43F5E) : Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('Normal', style: TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}