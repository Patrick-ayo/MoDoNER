import 'package:flutter/material.dart';

// Converted to a StatefulWidget to manage the hover state
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
  // This variable tracks if the mouse is currently over the card
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final originalColor = Theme.of(context).colorScheme.surface;
    final hoverColor = Colors.white12; // A subtle color for the hover effect

    // MouseRegion detects when the mouse enters or leaves the widget's area
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click, // Changes the cursor to a hand
      child: Card(
        // The color and elevation now change based on the _isHovered state
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
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}