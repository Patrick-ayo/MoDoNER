import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme.dart';

class TopNav extends StatelessWidget implements PreferredSizeWidget {
  const TopNav({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final bg = AppTheme.accentCyan;
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: bg,
      elevation: 2,
      title: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color.fromARGB(25, 20, 160, 160), borderRadius: BorderRadius.circular(8)),
            child: Builder(builder: (ctx) {
              // Try SVG first (more crisp), fall back to PNG image and finally to an Icon
              try {
                return SvgPicture.asset('assets/icons/admin.svg', colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn));
              } catch (_) {
                return Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.account_balance, size: 28, color: Colors.white),
                );
              }
            }),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('DPR Assessment System', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Ministry of Development of North Eastern Region', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const Spacer(),
          // Intentionally no interactive theme control here — theme is controlled from the AppBar toggle
          const Icon(Icons.brightness_2),
        ],
      ),
    );
  }
}

