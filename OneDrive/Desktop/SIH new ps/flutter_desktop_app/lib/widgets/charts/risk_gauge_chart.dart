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
    return LayoutBuilder(builder: (context, constraints) {
      // Determine the available size and scale the gauge accordingly.
      final availWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : 140.0;
      final availHeight = constraints.maxHeight.isFinite ? constraints.maxHeight : 200.0;
      // Reserve some space for title and padding; gauge should fit within the remaining area.
      final gaugeMax = min(availWidth, availHeight - 48).clamp(48.0, 160.0);
      final stroke = (gaugeMax * 0.08).clamp(4.0, 12.0);
      final centerFont = (gaugeMax * 0.18).clamp(10.0, 24.0);
      final subFont = (gaugeMax * 0.10).clamp(8.0, 14.0);

      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: gaugeMax,
            height: gaugeMax,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background track
                CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: stroke,
                  backgroundColor: Theme.of(context).dividerColor.withAlpha((0.08 * 255).round()),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
                // Foreground progress
                CircularProgressIndicator(
                  value: (score / maxScore).clamp(0.0, 1.0),
                  strokeWidth: stroke,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeCap: StrokeCap.round,
                ),
                // Center text (scale down if needed)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          percentage,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color, fontSize: centerFont),
                        ),
                      ),
                      SizedBox(height: gaugeMax * 0.03),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '$score / $maxScore',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: subFont),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: gaugeMax,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    });
  }
}