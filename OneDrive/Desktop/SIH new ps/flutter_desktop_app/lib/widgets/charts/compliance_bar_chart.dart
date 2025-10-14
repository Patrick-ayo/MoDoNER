import 'package:flutter/material.dart';
import '../../theme.dart';

class ComplianceBarChart extends StatelessWidget {
  const ComplianceBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data representing score ranges and their approval/rejection counts
    final List<Map<String, dynamic>> scoreData = [
      {'range': '81-100', 'approved': 90, 'rejected': 10},
      {'range': '61-80', 'approved': 60, 'rejected': 40},
      {'range': '41-60', 'approved': 30, 'rejected': 70},
      {'range': '21-40', 'approved': 10, 'rejected': 90},
      {'range': '0-20', 'approved': 5, 'rejected': 95},
    ];

    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Compliance vs. Outcome',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            // Use a Column to build the chart rows manually
            Column(
              children: scoreData.map((data) {
                return _buildChartRow(
                  context: context,
                  label: data['range'],
                  approvedCount: data['approved'],
                  rejectedCount: data['rejected'],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // A custom helper to build one stacked bar row
  Widget _buildChartRow({
    required BuildContext context,
    required String label,
    required int approvedCount,
    required int rejectedCount,
  }) {
    final int total = approvedCount + rejectedCount;
    final double approvedFraction = total > 0 ? approvedCount / total : 0;
    final double rejectedFraction = total > 0 ? rejectedCount / total : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Label on the left
          SizedBox(
            width: 60, // Fixed width for score range labels
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 12),
          // Stacked bar on the right
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Row(
                children: [
                  Expanded(
                    flex: (approvedFraction * 100).toInt(),
                    child: Container(
                      height: 12,
                      color: AppTheme.success,
                    ),
                  ),
                  Expanded(
                    flex: (rejectedFraction * 100).toInt(),
                    child: Container(
                      height: 12,
                      color: AppTheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}