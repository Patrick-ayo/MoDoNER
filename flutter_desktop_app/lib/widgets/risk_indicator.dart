import 'package:flutter/material.dart';

class RiskIndicator extends StatelessWidget {
  final String level;
  const RiskIndicator({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    switch (level.toLowerCase()) {
      case 'low':
        color = Colors.green;
        icon = Icons.circle;
        break;
      case 'medium':
        color = Colors.orange;
        icon = Icons.circle;
        break;
      case 'high':
        color = Colors.red;
        icon = Icons.circle;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
        break;
    }
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text('$level Risk', style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
