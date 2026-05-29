import 'package:flutter/material.dart';
import 'package:nalargizi/app/router/app_router.dart';
import '../../domain/entities/dashboard_entity.dart';

class InfoPosyanduBanner extends StatelessWidget {
  final PosyanduCenterEntity? center;

  const InfoPosyanduBanner({
    super.key,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, AppRouter.posyandu);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFF97316),
                    Color(0xFFEF4444),
                  ], // Orange ke Merah
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          center != null
                              ? "📣 INFO POSYANDU: ${center!.name.toUpperCase()}"
                              : "📣 INFO POSYANDU",
                          style: const TextStyle(
                            color: Color(0xFFFFEDD5),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          center != null
                              ? "Kunjungi ${center!.name} di ${center!.address} (Bidan: ${center!.leaderName})."
                              : "Bawa Buku KIA setiap kunjungan Posyandu!",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.trending_up, color: Colors.white, size: 28),
                ],
              ),
            ),

            Positioned(
              right: -16,
              bottom: -16,
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
