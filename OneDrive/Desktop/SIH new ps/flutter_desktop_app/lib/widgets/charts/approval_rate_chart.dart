import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';

class ApprovalRateChart extends StatefulWidget {
  const ApprovalRateChart({super.key});

  @override
  State<ApprovalRateChart> createState() => _ApprovalRateChartState();
}

class _ApprovalRateChartState extends State<ApprovalRateChart> {
  // State to track which section is being hovered over
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
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
              'Approval Rate', // Hardcoded text
              style: Theme.of(context).textTheme.titleLarge,
            ),
            // const SizedBox(height: 24),
            
            // --- CHANGE STARTS HERE ---
            // Changed from Row to Column to stack chart and legend vertically
            Expanded(
              child: Column(
                children: [
                  // The Donut Chart (now takes more vertical space)
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 60, // Increased center space radius for a slightly larger hole, making the donut itself larger
                        sections: _buildChartSections(),
                      ),
                    ),
                  ),
                //   const SizedBox(height: 24), // Add vertical space between chart and legend
                  // The Legend (now below the chart)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegendItem(AppTheme.success, 'Approved'),
                      const SizedBox(height: 8),
                      _buildLegendItem(AppTheme.error, 'Rejected'),
                      const SizedBox(height: 8),
                      _buildLegendItem(AppTheme.warning, 'Pending'),
                    ],
                  ),
                ],
              ),
            ),
            // --- CHANGE ENDS HERE ---
          ],
        ),
      ),
    );
  }

  // Builds the list of sections for the pie chart
  List<PieChartSectionData> _buildChartSections() {
    // Mock data
    final data = [
      {'status': 'Approved', 'value': 55.0, 'color': AppTheme.success},
      {'status': 'Rejected', 'value': 30.0, 'color': AppTheme.error},
      {'status': 'Pending', 'value': 15.0, 'color': AppTheme.warning},
    ];

    return List.generate(data.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 65.0 : 60.0; // Adjusted radius for larger donut
      final color = data[i]['color'] as Color;
      final value = data[i]['value'] as double;

      return PieChartSectionData(
        color: color,
        value: value,
        title: '${value.toInt()}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  // Helper to build a single legend item
  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 12),
        const SizedBox(width: 8),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}