import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desktop_app/gen/l10n/app_localizations.dart';
import '../theme.dart';

class EvaluationsChart extends StatefulWidget {
  const EvaluationsChart({super.key});

  @override
  State<EvaluationsChart> createState() => _EvaluationsChartState();
}

class _EvaluationsChartState extends State<EvaluationsChart> {
  // Use a non-translatable key for state management
  String _selectedIntervalKey = 'Monthly'; 

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Mock Data...
    final List<String> monthlyCategories = ["May", "Jun", "Jul", "Aug", "Sep", "Oct"];
    final List<double> monthlyCompleted = [15, 40, 35, 43, 57, 29];
    final List<double> monthlyIncomplete = [2, 6, 9, 15, 10, 1];
    final List<String> yearlyCategories = ["2023", "2024", "2025"];
    final List<double> yearlyCompleted = [120, 250, 180];
    final List<double> yearlyIncomplete = [30, 50, 40];

    final bool isMonthly = _selectedIntervalKey == 'Monthly';
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
              children: [
                // Make the title take available space and truncate if needed to
                // avoid RenderFlex overflow on narrow screens.
                Expanded(
                  child: Text(
                    l10n.evaluationsOverTime,
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                // Constrain the dropdown so it doesn't force the row wider than
                // the available space on small devices.
                SizedBox(
                  width: 130,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _buildIntervalDropdown(),
                  ),
                ),
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
                      return FlLine(color: Theme.of(context).dividerColor.withAlpha((0.1 * 255).round()), strokeWidth: 1);
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
                              child: Text(categories[index], style: Theme.of(context).textTheme.bodySmall),
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
                          return Text('${value.toInt()}', style: Theme.of(context).textTheme.bodySmall);
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
                _buildLegendItem(AppTheme.success, l10n.completed),
                const SizedBox(width: 24),
                _buildLegendItem(AppTheme.error, l10n.incomplete),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIntervalDropdown() {
    final l10n = AppLocalizations.of(context);
    // Map non-translatable keys to their translated display values
    final Map<String, String> intervalOptions = {
      'Monthly': l10n.monthly,
      'Yearly': l10n.yearly,
    };

    return DropdownButton<String>(
      value: _selectedIntervalKey,
      isDense: true,
      underline: const SizedBox(),
      icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).textTheme.bodySmall?.color),
      dropdownColor: Theme.of(context).cardColor,
      style: Theme.of(context).textTheme.bodyMedium,
      alignment: AlignmentDirectional.centerEnd,
      onChanged: (String? newKey) {
        if (newKey != null) {
          setState(() {
            _selectedIntervalKey = newKey;
          });
        }
      },
      items: intervalOptions.entries.map<DropdownMenuItem<String>>((entry) {
        return DropdownMenuItem<String>(
          value: entry.key, // The internal value is the key (e.g., 'Monthly')
          child: Text(entry.value), // The displayed text is the translation (e.g., 'मासिक')
        );
      }).toList(),
    );
  }

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
        Text(text, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  LineChartBarData _buildLineChartBarData(List<double> data, Color color) {
    return LineChartBarData(
      spots: data.asMap().entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value)).toList(),
      isCurved: true,
      color: color,
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }
}