import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../../theme.dart';

class ComplianceScatterChart extends StatelessWidget {
  const ComplianceScatterChart({super.key});

  @override
  Widget build(BuildContext context) {
    final Random random = Random();

    final List<ScatterSpot> spots = [];
    final List<int> approvedIndices = [];
    final List<int> rejectedIndices = [];

    // Generate 'Approved' spots and track their indices
    for (int i = 0; i < 20; i++) {
      spots.add(ScatterSpot(
        60 + random.nextDouble() * 35,
        1 + (random.nextDouble() - 0.5) * 0.4,
      ));
      approvedIndices.add(spots.length - 1);
    }
    
    // Generate 'Rejected' spots and track their indices
    for (int i = 0; i < 15; i++) {
      spots.add(ScatterSpot(
        20 + random.nextDouble() * 50,
        0 + (random.nextDouble() - 0.5) * 0.4,
      ));
      rejectedIndices.add(spots.length - 1);
    }

    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Compliance Score vs Final Outcome',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ScatterChart(
                ScatterChartData(
                  scatterSpots: spots,
                  minX: 0,
                  maxX: 100,
                  minY: -0.5,
                  maxY: 1.5,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  
                  // --- THE FIX IS HERE ---
                  // In this version, we provide different tooltips for different groups.
                  // This is a workaround to assign colors.
                  showingTooltipIndicators: [
                    ShowingTooltipIndicators(approvedIndices, [
                      ScatterTooltipItem(
                        'Approved',
                        backgroundColor: AppTheme.success,
                        textStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
                      ),
                    ]),
                    ShowingTooltipIndicators(rejectedIndices, [
                      ScatterTooltipItem(
                        'Rejected',
                        backgroundColor: AppTheme.error,
                        textStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
                      ),
                    ]),
                  ],
                  // --- END OF FIX ---
                  
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 80,
                        getTitlesWidget: (value, meta) {
                          String text = '';
                          if (value.round() == 0) text = 'Rejected';
                          if (value.round() == 1) text = 'Approved';
                          return SideTitleWidget(axisSide: meta.axisSide, space: 8, child: Text(text, style: Theme.of(context).textTheme.bodySmall));
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() % 50 == 0) {
                            return SideTitleWidget(axisSide: meta.axisSide, child: Text(value.toInt().toString(), style: Theme.of(context).textTheme.bodySmall));
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  
                  // This simplified touch data will now work
                  scatterTouchData: ScatterTouchData(
                    enabled: true,
                    handleBuiltInTouches: true,
                    touchTooltipData: ScatterTouchTooltipData(
                      getTooltipItems: (ScatterSpot touchedSpot) {
                        return ScatterTooltipItem(
                          'Score: ${touchedSpot.x.toStringAsFixed(1)}',
                          textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}