import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/language_provider.dart';

/// A compact popover-style language selector inspired by Radix Popover visuals.
class LanguageSelector extends StatelessWidget implements PreferredSizeWidget {
  const LanguageSelector({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().languageCode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: _LanguageButton(current: lang),
    );
  }
}

class _LanguageButton extends StatefulWidget {
  final String current;
  const _LanguageButton({required this.current});

  @override
  State<_LanguageButton> createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<_LanguageButton> {
  OverlayEntry? _entry;

  void _showMenu() {
    if (_entry != null) return;
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _entry = OverlayEntry(builder: (context) {
      return Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 8,
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 180,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).cardColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildItem('English', 'en'),
                _buildItem('Hindi', 'hi'),
                _buildItem('Bengali', 'bn'),
                _buildItem('Tamil', 'ta'),
              ],
            ),
          ),
        ),
      );
    });

    overlay.insert(_entry!);
  }

  void _hideMenu() {
    _entry?.remove();
    _entry = null;
  }

  Widget _buildItem(String label, String code) {
    final current = context.read<LanguageProvider>().languageCode;
    final selected = current == code;
    return InkWell(
      onTap: () {
        context.read<LanguageProvider>().setLanguage(code);
        _hideMenu();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        width: double.infinity,
        child: Row(
          children: [
            Expanded(child: Text(label)),
            if (selected) const Icon(Icons.check, size: 18)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final code = context.watch<LanguageProvider>().languageCode;
    final label = _labelFor(code);

    return GestureDetector(
      onTap: () {
        if (_entry == null)
          _showMenu();
        else
          _hideMenu();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).dividerColor.withAlpha((0.08 * 255).round())),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, size: 18),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_drop_down, size: 18),
          ],
        ),
      ),
    );
  }

  String _labelFor(String code) {
    switch (code) {
      case 'hi':
        return 'Hindi';
      case 'bn':
        return 'Bengali';
      case 'ta':
        return 'Tamil';
      default:
        return 'English';
    }
  }
}