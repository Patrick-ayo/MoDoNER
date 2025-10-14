import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double percentage; // 0-100
  final Color color;

  const ProgressBar({super.key, required this.percentage, required this.color});

  @override
  Widget build(BuildContext context) {
    final pct = (percentage.clamp(0, 100)) / 100.0;
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          Container(height: 8, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4))),
          Container(height: 8, width: constraints.maxWidth * pct, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        ],
      );
    });
  }
}
