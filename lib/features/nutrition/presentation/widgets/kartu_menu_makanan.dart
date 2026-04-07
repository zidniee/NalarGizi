import 'package:flutter/material.dart';

class KartuMenuMakanan extends StatelessWidget {
  final String title;
  final String subtitle;
  final String calories;
  final String statusLabel;
  final Color statusColor;
  final bool isAddMode; // True untuk kotak Tambah Menu Malam

  const KartuMenuMakanan({
    super.key,
    this.title = '',
    this.subtitle = '',
    this.calories = '',
    this.statusLabel = '',
    this.statusColor = Colors.green,
    this.isAddMode = false,
  });

  @override
  Widget build(BuildContext context) {
    // Tampilan jika kotak "Belum ada catatan / Tambah Menu"
    if (isAddMode) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange.shade200, width: 1.5),
        ),
        child: Column(
          children: [
            const Text('Belum ada catatan makan malam', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add, color: Color(0xFFFF7A00), size: 18),
                  SizedBox(width: 4),
                  Text('Tambah Menu Malam', style: TextStyle(color: Color(0xFFFF7A00), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Tampilan normal kartu makanan yang sudah diisi
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              shape: BoxShape.circle,
            ),
            child: const Center(child: Icon(Icons.ramen_dining, color: Colors.orange)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(calories, style: const TextStyle(color: Color(0xFFFF7A00), fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}