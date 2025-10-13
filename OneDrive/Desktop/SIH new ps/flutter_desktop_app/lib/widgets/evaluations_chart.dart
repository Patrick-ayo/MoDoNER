import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../theme.dart';

class EvaluationsChart extends StatefulWidget {
  const EvaluationsChart({super.key});

  @override
  State<EvaluationsChart> createState() => _EvaluationsChartState();
}

class _EvaluationsChartState extends State<EvaluationsChart> {
  String _selectedInterval = 'Monthly';

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final List<String> monthlyCategories = ["May", "Jun", "Jul", "Aug", "Sep", "Oct"];
    final List<double> monthlyCompleted = [15, 40, 35, 43, 57, 29];
    final List<double> monthlyIncomplete = [2, 6, 9, 15, 10, 1];
    final List<String> yearlyCategories = ["2023", "2024", "2025"];
    final List<double> yearlyCompleted = [120, 250, 180];
    final List<double> yearlyIncomplete = [30, 50, 40];

    final bool isMonthly = _selectedInterval == 'Monthly';
    final List<String> categories = isMonthly ? monthlyCategories : yearlyCategories;
    final List<double> completedData = isMonthly ? monthlyCompleted : yearlyCompleted;
    final List<double> incompleteData = isMonthly ? monthlyIncomplete : yearlyIncomplete;

    final allData = [...completedData, ...incompleteData];
    final maxValue = allData.isEmpty ? 60 : allData.reduce(max);
    final interval = isMonthly ? 20.0 : 50.0;
    final maxY = ((maxValue + interval) / interval).ceil() * interval;

    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Evaluations Over Time',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                _buildIntervalDropdown(),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  clipData: const FlClipData.all(),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return const FlLine(color: Colors.white10, strokeWidth: 1);
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < categories.length) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(categories[index], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: interval,
                        reservedSize: 42,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}', style: const TextStyle(color: Colors.white70, fontSize: 12));
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: 0,
                  maxY: maxY.toDouble(),
                  lineBarsData: [
                    _buildLineChartBarData(completedData, AppTheme.success),
                    _buildLineChartBarData(incompleteData, AppTheme.error),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(AppTheme.success, 'Completed'),
                const SizedBox(width: 24),
                _buildLegendItem(AppTheme.error, 'Incomplete'),
              ],
            )
          ],
        ),
      ),
    );
  }

  // --- UPDATED DROPDOWN WIDGET ---
  Widget _buildIntervalDropdown() {
    return DropdownButton<String>(
      value: _selectedInterval,
      // Style properties to make it look clean and integrated
      isDense: true, // Makes the button more compact
      underline: const SizedBox(), // Hides the default underline
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
      dropdownColor: const Color(0xFF1E293B), // A dark color for the menu
      // Use the theme's text style for consistency
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
      alignment: AlignmentDirectional.centerEnd, // Aligns the menu nicely

      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedInterval = newValue;
          });
        }
      },
      items: <String>['Monthly', 'Yearly']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
  // --- END OF UPDATE ---

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  LineChartBarData _buildLineChartBarData(List<double> data, Color color) {
    return LineChartBarData(
      spots: data.asMap().entries.map((entry) {
        return FlSpot(entry.key.toDouble(), entry.value);
      }).toList(),
      isCurved: true,
      color: color,
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }
}