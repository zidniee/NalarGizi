import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class KartuGrafikKurva extends StatelessWidget {
  final bool isBeratBadan;

  const KartuGrafikKurva({super.key, required this.isBeratBadan});

  @override
  Widget build(BuildContext context) {
    // Menyiapkan data agar kodenya lebih rapi
    final List<ChartData> dataTubuh = isBeratBadan
        ? [ChartData(9, 8.1), ChartData(10, 8.55), ChartData(11, 8.9), ChartData(12, 9.2), ChartData(13, 9.45), ChartData(14, 9.8)]
        : [ChartData(9, 71), ChartData(10, 72), ChartData(11, 73), ChartData(12, 74.5), ChartData(13, 75), ChartData(14, 76.5)];

    final List<ChartData> dataWho = isBeratBadan
        ? [ChartData(9, 9.45), ChartData(14, 9.45)]
        : [ChartData(9, 74), ChartData(14, 74)];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Grafik ${isBeratBadan ? 'Berat' : 'Tinggi'} Badan',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 2),
                  const Text('6 bulan terakhir', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  _buildLegend(const Color(0xFFF43F5E), 'Data'),
                  const SizedBox(width: 12),
                  _buildLegend(const Color(0xFF10B981), 'WHO'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Chips Status
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatusChip('Buruk', const Color(0xFFFEE2E2), const Color(0xFFEF4444)),
                const SizedBox(width: 8),
                _buildStatusChip('Kurang', const Color(0xFFFEF3C7), const Color(0xFFF59E0B)),
                const SizedBox(width: 8),
                _buildStatusChip('Normal ✓', const Color(0xFFD1FAE5), const Color(0xFF10B981)),
                const SizedBox(width: 8),
                _buildStatusChip('Normal ✓', const Color(0xFFD1FAE5), const Color(0xFF10B981)),
                const SizedBox(width: 8),
                _buildStatusChip('Lebih', const Color(0xFFFFEDD5), const Color(0xFFF97316)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // CHART AREA SYNCFUSION
          SizedBox(
            height: 200,
            child: SfCartesianChart(
              margin: EdgeInsets.zero,
              plotAreaBorderWidth: 0,
              primaryXAxis: NumericAxis(
                minimum: 9,
                maximum: 14,
                interval: 1,
                labelFormat: 'Bln {value}',
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                majorGridLines: MajorGridLines(width: 1, color: Colors.grey.shade100),
                labelStyle: TextStyle(color: Colors.grey.shade400, fontSize: 10),
              ),
              primaryYAxis: NumericAxis(
                minimum: isBeratBadan ? 8.0 : 70.0,
                maximum: isBeratBadan ? 10.0 : 78.0,
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                majorGridLines: MajorGridLines(width: 1, color: Colors.grey.shade50),
                labelStyle: TextStyle(color: Colors.grey.shade400, fontSize: 10),
              ),
              trackballBehavior: TrackballBehavior(
                enable: true,
                activationMode: ActivationMode.singleTap,
                hideDelay: 1500, // Penyelamat Navbar
                lineType: TrackballLineType.vertical,
                lineColor: Colors.grey.shade300,
                lineWidth: 2,
                tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
                // ─── ANIMASI SMOOTH: builder dibungkus AnimatedSwitcher ───
                builder: (BuildContext context, TrackballDetails trackballDetails) {
                  if (trackballDetails.seriesIndex == 0) return const SizedBox.shrink();

                  final data = trackballDetails.point!;

                  final num xValue = data.x ?? 0;
                  final num yValue = data.y ?? 0;

                  final nilai = isBeratBadan ? yValue.toString() : yValue.toInt().toString();
                  final satuan = isBeratBadan ? "kg" : "cm";

                  // Key unik per titik agar AnimatedSwitcher tahu kapan harus animasi
                  final tooltipKey = ValueKey('${xValue}_$yValue');

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          // Geser sedikit dari bawah ke posisi normal saat muncul
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.15),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      key: tooltipKey,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Bulan ${xValue.toInt()}\n',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: '$nilai $satuan',
                              style: const TextStyle(
                                color: Color(0xFFFCA5A5),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              series: <CartesianSeries>[
                LineSeries<ChartData, double>(
                  dataSource: dataWho,
                  xValueMapper: (ChartData data, _) => data.bulan,
                  yValueMapper: (ChartData data, _) => data.nilai,
                  color: const Color(0xFF10B981),
                  width: 2,
                  dashArray: const <double>[5, 5],
                  enableTooltip: false,
                ),
                SplineAreaSeries<ChartData, double>(
                  dataSource: dataTubuh,
                  xValueMapper: (ChartData data, _) => data.bulan,
                  yValueMapper: (ChartData data, _) => data.nilai,
                  splineType: SplineType.monotonic,
                  borderWidth: 3,
                  borderColor: const Color(0xFFF43F5E),
                  gradient: LinearGradient(
                    colors: [const Color(0xFFF43F5E).withOpacity(0.2), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    color: Color(0xFFF43F5E),
                    borderColor: Colors.white,
                    borderWidth: 2,
                    height: 10,
                    width: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(width: 12, height: 3, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildStatusChip(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}

class ChartData {
  final double bulan;
  final double nilai;
  ChartData(this.bulan, this.nilai);
}