import 'dart:math';
import 'package:flutter/material.dart';

class RiskGaugeChart extends StatelessWidget {
  final Color color;
  final String title;
  final double score; // e.g., 3.8
  final double maxScore; // e.g., 5.0
  final String percentage; // e.g., 3.8%

  const RiskGaugeChart({
    super.key,
    required this.color,
    required this.title,
    required this.score,
    required this.maxScore,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // The background track
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 10,
                backgroundColor: Theme.of(context).dividerColor.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              // The foreground progress
              CircularProgressIndicator(
                value: (score / maxScore).clamp(0.0, 1.0),
                strokeWidth: 10,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeCap: StrokeCap.round,
              ),
              // The text in the center
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      percentage,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color),
                    ),
                    Text(
                      '$score / $maxScore',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}