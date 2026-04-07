import 'package:flutter/material.dart';
import 'package:nalargizi/app/layout/main_layout.dart';

// Pastikan nama import di bawah ini SAMA PERSIS dengan nama file di foldermu
import 'package:nalargizi/features/growth/presentation/widgets/pilihan_tipe_kurva.dart';
import 'package:nalargizi/features/growth/presentation/widgets/kartu_pengukuran_terakhir.dart';
import 'package:nalargizi/features/growth/presentation/widgets/kartu_grafik_kurva.dart';
import 'package:nalargizi/features/growth/presentation/widgets/bagian_riwayat_pertumbuhan.dart';

class GrowthPage extends StatefulWidget {
  const GrowthPage({super.key});

  @override
  State<GrowthPage> createState() => _GrowthPageState();
}

class _GrowthPageState extends State<GrowthPage> {
  // State interaktif: True = Berat Badan, False = Tinggi Badan
  bool isBeratBadan = true;

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      initialIndex: 1, // Mengaktifkan tab Kurva di Bottom Navigation
      child: ColoredBox(
        color: const Color(0xFFF8F9FA), // Latar abu-abu terang yang bersih
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- HEADER ---
                  const Center(
                    child: Column(
                      children: [
                        Text('Kurva Tumbuh Kembang', 
                             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        SizedBox(height: 4),
                        Text('Berdasarkan standar WHO', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- WIDGET 1: SWITCH BB / TB ---
                  PilihanTipeKurva( // Pastikan nama Class-nya cocok dengan isi file pilihan_tipe_kurva.dart
                    isBeratBadan: isBeratBadan,
                    onChanged: (value) {
                      setState(() {
                        isBeratBadan = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // --- WIDGET 2: KARTU PENGUKURAN ---
                  KartuPengukuranTerakhir(isBeratBadan: isBeratBadan),
                  const SizedBox(height: 24),

                  // --- WIDGET 3: GRAFIK KURVA ---
                  KartuGrafikKurva(isBeratBadan: isBeratBadan),
                  const SizedBox(height: 32),

                  // --- WIDGET 4: RIWAYAT & TOMBOL ---
                  BagianRiwayatPertumbuhan(isBeratBadan: isBeratBadan),
                  
                  // --- RUANG NAPAS BAWAH BIAR GAK KETUTUP NAVBAR ---
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}