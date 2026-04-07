import 'package:flutter/material.dart';
import 'package:nalargizi/app/layout/main_layout.dart';

// Import sesuai dengan nama di IDE-mu
import 'package:nalargizi/features/nutrition/presentation/widgets/ringkasan_nutrisi_header.dart';
import 'package:nalargizi/features/nutrition/presentation/widgets/kartu_progres_nutrisi.dart';
import 'package:nalargizi/features/nutrition/presentation/widgets/kartu_menu_makanan.dart';

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      initialIndex: 3,
      child: ColoredBox(
        color: const Color(0xFFF8F9FA), // Latar belakang abu-abu terang
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Header Oren
              const RingkasanNutrisiHeader(),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 2. Kartu Progress Nutrisi
                    const KartuProgresNutrisi(),
                    const SizedBox(height: 32),

                    // 3. SEKSI SARAPAN
                    _buildSectionHeader(Icons.wb_sunny_outlined, 'Sarapan', '07:00', Colors.orange),
                    const SizedBox(height: 12),
                    const KartuMenuMakanan(
                      title: 'Bubur Hati Ayam + Bayam',
                      subtitle: 'Protein Hewani, Zat Besi',
                      calories: '150 kkal',
                      statusLabel: 'Habis',
                      statusColor: Colors.green, // Hijau persis Figma
                    ),
                    const SizedBox(height: 24),

                    // 4. SEKSI MAKAN SIANG
                    _buildSectionHeader(Icons.star_border, 'Makan Siang', '12:30', Colors.amber),
                    const SizedBox(height: 12),
                    const KartuMenuMakanan(
                      title: 'Nasi Tim Telur Puyuh',
                      subtitle: 'Karbohidrat, Protein',
                      calories: '180 kkal',
                      statusLabel: 'Sisa Sedikit',
                      statusColor: Colors.amber, // Kuning persis Figma
                    ),
                    const SizedBox(height: 24),

                    // 5. SEKSI MAKAN MALAM
                    _buildSectionHeader(Icons.nightlight_round_outlined, 'Makan Malam', '18:00', Colors.indigo.shade300),
                    const SizedBox(height: 12),
                    const KartuMenuMakanan(isAddMode: true), // Panggil mode "Tambah"
                    const SizedBox(height: 32),

                    // 6. KARTU HIDRASI (Ditulis langsung di sini agar tidak nambah file widget baru)
                    _buildHidrasiCard(),
                    const SizedBox(height: 200),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pembantu untuk judul seksi (Sarapan, dll)
  Widget _buildSectionHeader(IconData icon, String title, String time, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(width: 8),
        Text(time, style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
      ],
    );
  }

  // Widget pembantu untuk kartu Hidrasi biru di paling bawah
  Widget _buildHidrasiCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.water_drop_outlined, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              const Text('Hidrasi Hari Ini', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A), fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              return Expanded(
                child: Container(
                  height: 32,
                  margin: EdgeInsets.only(right: index < 5 ? 8 : 0),
                  decoration: BoxDecoration(
                    color: index < 4 ? Colors.blue.shade400 : Colors.blue.shade100, // 4 kotak biru tua, 2 kotak biru muda
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text('4 dari 6 gelas terpenuhi ✓', style: TextStyle(color: Colors.blue.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}