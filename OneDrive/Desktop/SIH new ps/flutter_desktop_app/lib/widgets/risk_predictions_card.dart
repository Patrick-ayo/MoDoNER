import 'package:flutter/material.dart';
import 'package:flutter_desktop_app/gen/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);

    // Mock data now uses the localization keys
    final List<Map<String, dynamic>> riskData = [
      {'riskType': l10n.riskCostOverrun, 'averageScore': 70},
      {'riskType': l10n.riskTimeline, 'averageScore': 80},
      {'riskType': l10n.riskEnvironmental, 'averageScore': 45},
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
              l10n.aiRiskPredictions, // Using the localized title
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Column(
              children: riskData.map((risk) {
                final score = risk['averageScore'] as num;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: LayoutBuilder(builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 360;
                    return Row(
                      children: [
                        Expanded(
                          flex: isNarrow ? 4 : 3,
                          child: Text(
                            risk['riskType'],
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: isNarrow ? 6 : 5,
                          child: LinearProgressIndicator(
                            value: score / 100.0,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                            backgroundColor: Theme.of(context).dividerColor.withAlpha((0.1 * 255).round()),
                            color: _getColorForScore(score.toDouble()),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(width: isNarrow ? 40 : 44, child: Text('${score.toInt()}%', style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.right)),
                      ],
                    );
                  }),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}