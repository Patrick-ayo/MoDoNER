import 'package:flutter/material.dart';
import '../../theme.dart';
import 'risk_gauge_chart.dart'; // Import the gauge widget

class AverageRiskChart extends StatelessWidget {
  const AverageRiskChart({super.key});

  Color _getColorForScore(double score) {
    if (score > 3.75) return AppTheme.error; // High Risk (>75%)
    if (score > 2.5) return AppTheme.warning; // Medium Risk (>50%)
    return AppTheme.success; // Low Risk
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> riskData = [
      {'title': 'Cost Overrun', 'score': 4.2, 'maxScore': 5.0, 'percentage': '3.8%'},
      {'title': 'Delayed Timelines', 'score': 3.8, 'maxScore': 5.0, 'percentage': '3.8%'},
      {'title': 'Environmental', 'score': 1.5, 'maxScore': 5.0, 'percentage': '1.5%'},
      {'title': 'Technical', 'score': 2.5, 'maxScore': 5.0, 'percentage': '2.5%'},
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
              'Average Risk Predictions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            
            // --- FIX IS HERE ---
            // Increased the height for more top padding. You can adjust this value.
            const SizedBox(height: 24),
            
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: riskData.map((data) {
                  final double score = data['score'];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: RiskGaugeChart(
                      color: _getColorForScore(score),
                      title: data['title'],
                      score: score,
                      maxScore: data['maxScore'],
                      percentage: data['percentage'],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}