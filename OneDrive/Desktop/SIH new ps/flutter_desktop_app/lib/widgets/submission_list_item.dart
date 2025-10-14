import 'package:flutter/material.dart';
import 'package:flutter_desktop_app/gen/l10n/app_localizations.dart';
import '../theme.dart';

class SubmissionListItem extends StatelessWidget {
  final int index;
  final String name;
  final int riskScore;

  const SubmissionListItem({
    super.key,
    required this.index,
    required this.name,
    required this.riskScore,
  });

  // Helper to get a color based on the risk score
  Color _getRiskColor(int score) {
    if (score > 75) {
      return AppTheme.error; // High risk
    } else if (score > 50) {
      return AppTheme.warning; // Medium risk
    } else {
      return AppTheme.success; // Low risk
    }
  }

  // Helper to get a localized text label based on the risk score
  String _getRiskLabel(int score, AppLocalizations l10n) {
    if (score > 75) {
      return l10n.highRisk;
    } else if (score > 50) {
      return l10n.mediumRisk;
    } else {
      return l10n.lowRisk;
    }
  }

  // Helper to build the visual risk indicator
  Widget _buildRiskIndicator(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: _getRiskColor(riskScore),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          _getRiskLabel(riskScore, l10n), // Use the localized risk label
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _getRiskColor(riskScore),
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Theme.of(context).dividerColor, width: 1),
      ),
      elevation: 0,
      child: InkWell(
        onTap: () {
          // TODO: Handle navigation to the project details screen
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.primary,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    _buildRiskIndicator(context),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.bookmark_border, color: Theme.of(context).textTheme.bodySmall?.color),
            ],
          ),
        ),
      ),
    );
  }
}