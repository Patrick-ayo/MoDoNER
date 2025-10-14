import 'package:flutter/material.dart';
import '../theme.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      // The primary button style is fine for both themes
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: AppTheme.primaryLight,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(text),
      );
    } else {
      // The secondary button is now theme-aware
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          // FIX: Use the theme's text color instead of a hardcoded white
          foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          // FIX: Use the theme's divider color for a suitable border in both modes
          side: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
        child: Text(text),
      );
    }
  }
}