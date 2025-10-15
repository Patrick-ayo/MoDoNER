import 'package:flutter/material.dart';

/// Simple placeholder for the compliance scatter chart.
/// Replaces fl_chart usage to avoid API mismatches with the locked dependency version.
class ComplianceScatterChart extends StatelessWidget {
  const ComplianceScatterChart({super.key});

  @override
  Widget build(BuildContext context) {
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
              'Compliance Score vs Final Outcome',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: Center(
                child: Text(
                  'Chart placeholder (fl_chart API mismatch)\nReplace with a compatible chart or upgrade fl_chart.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}