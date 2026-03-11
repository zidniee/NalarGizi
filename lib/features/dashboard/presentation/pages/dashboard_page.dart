import 'package:flutter/material.dart';
import 'package:nalargizi/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:nalargizi/features/dashboard/presentation/widgets/dashboard_status_row.dart';
import 'package:nalargizi/features/dashboard/presentation/widgets/edukasi_gizi_section.dart';
import 'package:nalargizi/features/dashboard/presentation/widgets/info_posyandu_banner.dart';
import 'package:nalargizi/features/dashboard/presentation/widgets/jadwal_terdekat_card.dart';
import 'package:nalargizi/features/dashboard/presentation/widgets/tip_harian_card.dart';
import 'package:nalargizi/features/dashboard/presentation/widgets/z_score_indicator_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Latar Belakang Pink
            Container(
              padding: const EdgeInsets.only(
                top: 60,
                left: 24,
                right: 24,
                bottom: 32,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: const Column(
                children: [
                  DashboardHeader(),
                  SizedBox(height: 24),
                  DashboardStatusRow(),
                ],
              ),
            ),

            // 2. Konten Bawah (Disusun Sesuai Figma)
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                children: [
                  TipHarianCard(),
                  SizedBox(height: 20),
                  ZScoreIndicatorCard(), // <-- Widget Baru
                  SizedBox(height: 20),
                  JadwalTerdekatCard(),
                  SizedBox(height: 24),
                  EdukasiGiziSection(), // <-- Widget Baru
                  SizedBox(height: 24),
                  InfoPosyanduBanner(), // <-- Widget Baru
                  SizedBox(
                    height: 40,
                  ), // Ruang kosong agar tidak tertutup Bottom Navigation
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
