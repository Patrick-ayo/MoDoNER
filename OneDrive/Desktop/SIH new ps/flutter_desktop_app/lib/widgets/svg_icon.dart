import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  final String assetName;
  final double size;
  final Color? color;

  const SvgIcon(this.assetName, {super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: size,
      height: size,
      colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      // Provide a graceful fallback when an asset is missing (prevents DDC 404 spam)
      placeholderBuilder: (context) => SizedBox(width: size, height: size, child: Center(child: Icon(Icons.image_not_supported, size: size * 0.8))),
      // For web builds if asset fails to load, render an Icon instead of throwing.
      fit: BoxFit.contain,
    );
  }
}
