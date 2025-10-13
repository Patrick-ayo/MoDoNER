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
    this.isPrimary = false, // Defaults to the secondary (outlined) style
  });

  @override
  Widget build(BuildContext context) {
    // We use Flutter's built-in buttons which handle hover effects automatically!
    if (isPrimary) {
      // Return a solid, elevated button for the primary action
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
      // Return a more subtle, outlined button for secondary actions
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          foregroundColor: Colors.white70,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: const BorderSide(
            color: Colors.white24, // A faint border
          ),
        ),
        child: Text(text),
      );
    }
  }
}