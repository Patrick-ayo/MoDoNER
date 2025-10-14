import 'package:flutter/material.dart';

class StatCard extends StatefulWidget {
  final String value;
  final String label;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final originalColor = Theme.of(context).colorScheme.surface;
    // Use a theme-aware hover color
    final hoverColor = Theme.of(context).hoverColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Card(
        color: _isHovered ? hoverColor : originalColor,
        elevation: _isHovered ? 8.0 : 2.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.value,
                textAlign: TextAlign.center,
                // Removed hardcoded color to use the theme's style
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                // Removed hardcoded color to use the theme's style
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}