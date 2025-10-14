import 'package:flutter/material.dart';
import '../../theme.dart';

class CommonIssuesChart extends StatelessWidget {
  const CommonIssuesChart({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> issuesData = [
      {'name': 'Financial Mismatch', 'value': 22.0},
      {'name': 'Unrealistic Timelines', 'value': 18.0},
      {'name': 'Scope Creep', 'value': 15.0},
      {'name': 'Resource Allocation', 'value': 12.0},
      {'name': 'Quality Concerns', 'value': 9.0},
    ];

    final List<Color> barColors = [
      AppTheme.primaryLight,
      AppTheme.accentCyan,
      AppTheme.success,
      AppTheme.warning,
      AppTheme.error,
    ];

    final double maxValue = issuesData.first['value'];

    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // This makes the Card shrink to fit its content
          children: [
            Text(
              'Top 5 Most Common Issues',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            
            // --- FIX STARTS HERE ---
            // We removed the Expanded and SizedBox wrappers.
            // The Column now sizes itself naturally.
            Column(
              children: List.generate(issuesData.length, (index) {
                // We add a Padding here to control the vertical space between bars
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0), 
                  child: _buildChartRow(
                    context: context,
                    label: issuesData[index]['name'],
                    value: issuesData[index]['value'],
                    maxValue: maxValue,
                    color: barColors[index % barColors.length],
                  ),
                );
              }),
            ),
            // --- FIX ENDS HERE ---
          ],
        ),
      ),
    );
  }

  Widget _buildChartRow({
    required BuildContext context,
    required String label,
    required double value,
    required double maxValue,
    required Color color,
  }) {
    final double barFraction = (value / maxValue).clamp(0.0, 1.0);

    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: barFraction,
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}