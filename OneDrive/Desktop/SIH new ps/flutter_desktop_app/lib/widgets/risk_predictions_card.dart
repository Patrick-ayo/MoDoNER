import 'package:flutter/material.dart';
import '../theme.dart';

class RiskPredictionsCard extends StatelessWidget {
  const RiskPredictionsCard({super.key});

  // Helper function to determine progress bar color based on the score
  Color _getColorForScore(double score) {
    if (score > 75) {
      return AppTheme.error; // High risk
    } else if (score > 50) {
      return AppTheme.warning; // Medium risk
    } else {
      return AppTheme.success; // Low risk
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mock data based on your backend response
    final List<Map<String, dynamic>> riskData = [
      {'riskType': 'Cost Overrun Risk', 'averageScore': 70},
      {'riskType': 'Timeline Risk', 'averageScore': 80},
      {'riskType': 'Environmental Risk', 'averageScore': 50},
    ];

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
              'AI Risk Predictions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            // Use a Column to list the risk items vertically
            Column(
              children: riskData.map((risk) {
                final score = risk['averageScore'] as num;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        risk['riskType'],
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: score / 100.0, // Progress bars need a value between 0.0 and 1.0
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                        backgroundColor: Colors.grey.shade800,
                        color: _getColorForScore(score.toDouble()),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}