import 'package:flutter/material.dart';
import 'package:flutter_desktop_app/gen/l10n/app_localizations.dart';
import '../theme.dart';

class FlaggedIssuesCard extends StatelessWidget {
  const FlaggedIssuesCard({super.key});

  // Helper function to map severity string to a color from our theme
  Color _getColorForSeverity(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
  return AppTheme.error.withAlpha((0.7 * 255).round());
      case 'medium':
  return AppTheme.warning.withAlpha((0.7 * 255).round());
      case 'low':
  return AppTheme.success.withAlpha((0.7 * 255).round());
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the localization object
    final l10n = AppLocalizations.of(context);

    // Mock data now uses the localization keys
    final List<Map<String, dynamic>> flaggedIssues = [
      {'issue': l10n.issueMissingCost, 'severity': 'High', 'count': 8},
      {'issue': l10n.issueInconsistentTimelines, 'severity': 'Medium', 'count': 15},
      {'issue': l10n.issueBudgetMismatch, 'severity': 'High', 'count': 5},
      {'issue': l10n.issueEnvironmentalImpact, 'severity': 'Low', 'count': 22},
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
              l10n.flaggedIssues, // Using the localized title
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            LayoutBuilder(builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 700;
              return Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: isNarrow ? WrapAlignment.center : WrapAlignment.start,
                children: flaggedIssues.map((issueData) {
                  return _IssueChip(
                    text: issueData['issue'],
                    color: _getColorForSeverity(issueData['severity']),
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// Private StatefulWidget for the chip to handle its own hover state
class _IssueChip extends StatefulWidget {
  final String text;
  final Color color;

  const _IssueChip({required this.text, required this.color});

  @override
  State<_IssueChip> createState() => _IssueChipState();
}

class _IssueChipState extends State<_IssueChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Make the text color theme-aware
    final textColor = Theme.of(context).brightness == Brightness.dark 
      ? Colors.white
      : Colors.black87;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 220),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: _isHovered 
              ? Color.alphaBlend(Colors.white.withAlpha((0.2 * 255).round()), widget.color)
              : widget.color,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SizedBox(
          width: 200,
          child: Text(
            widget.text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            softWrap: true,
          ),
        ),
      ),
    );
  }
}