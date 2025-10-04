import 'package:flutter/material.dart';

// allow flexible leading widget (SVG or Image) or fallback to IconData

class MetricCard extends StatelessWidget {
  final IconData? icon;
  final Widget? leading;
  final String title;
  final String value;
  final Color borderColor;

  const MetricCard({super.key, this.icon, this.leading, required this.title, required this.value, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      // parent should control spacing
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: borderColor, width: 4)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              SizedBox(height:32, child: Center(child: leading)),
            ] else ...[
              Icon(icon, size: 32, color: borderColor),
            ],
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
