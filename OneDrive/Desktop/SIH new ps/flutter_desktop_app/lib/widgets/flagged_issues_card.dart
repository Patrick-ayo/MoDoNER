import 'package:flutter/material.dart';
import '../theme.dart';

class FlaggedIssuesCard extends StatelessWidget {
  const FlaggedIssuesCard({super.key});

  // Helper function to map severity string to a color from our theme
  Color _getColorForSeverity(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return AppTheme.error.withOpacity(0.7);
      case 'medium':
        return AppTheme.warning.withOpacity(0.7);
      case 'low':
        return AppTheme.success.withOpacity(0.7);
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mock data based on your backend description and the UI image
    final List<Map<String, dynamic>> flaggedIssues = [
      {'issue': 'Missing Cost Estimates', 'severity': 'High', 'count': 8},
      {'issue': 'Inconsistent Timelines', 'severity': 'Medium', 'count': 15},
      {'issue': 'Budget mismatch', 'severity': 'High', 'count': 5},
      {'issue': 'Environmental Impact not addressed', 'severity': 'Low', 'count': 22},
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
              'Flagged Issues',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            // Using Wrap so the chips flow to the next line if space is tight
            Wrap(
              spacing: 8.0, // Horizontal space between chips
              runSpacing: 8.0, // Vertical space between lines of chips
              children: flaggedIssues.map((issueData) {
                // Now we create an instance of our new, stateful _IssueChip widget
                return _IssueChip(
                  text: issueData['issue'],
                  color: _getColorForSeverity(issueData['severity']),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}


// Step 1: Create a new private StatefulWidget for the chip
class _IssueChip extends StatefulWidget {
  final String text;
  final Color color;

  const _IssueChip({required this.text, required this.color});

  @override
  State<_IssueChip> createState() => _IssueChipState();
}

class _IssueChipState extends State<_IssueChip> {
  // Step 2: Each chip now manages its own hover state
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Step 3: Wrap in a MouseRegion to detect hover events
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          // Step 4: Dynamically change the color based on the hover state
          // We blend the original color with a semi-transparent white to brighten it
          color: _isHovered 
              ? Color.alphaBlend(Colors.white.withOpacity(0.2), widget.color)
              : widget.color,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          widget.text,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}