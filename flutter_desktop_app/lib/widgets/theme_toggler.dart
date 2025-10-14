import 'package:flutter/material.dart';

class ThemeToggler extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggle;
  final Duration animationDuration;
  final Size size;

  const ThemeToggler({
    Key? key,
    required this.isDarkMode,
    required this.onToggle,
    this.animationDuration = const Duration(milliseconds: 300),
    this.size = const Size(60, 30),
  }) : super(key: key);

  @override
  _ThemeTogglerState createState() => _ThemeTogglerState();
}

class _ThemeTogglerState extends State<ThemeToggler>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _iconController;
  late Animation<double> _switchAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _switchAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _iconRotation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    ));

    if (widget.isDarkMode) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(ThemeToggler oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      if (widget.isDarkMode) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  void _handleTap() {
    _iconController.forward().then((_) {
      _iconController.reverse();
    });
    
    widget.onToggle(!widget.isDarkMode);
  }

  @override
  void dispose() {
    _controller.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_controller, _iconController]),
        builder: (context, child) {
          return Container(
            width: widget.size.width,
            height: widget.size.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.size.height / 2),
              gradient: LinearGradient(
                colors: [
                  Color.lerp(
                    const Color(0xFFE3F2FD), // Light blue
                    const Color(0xFF1A1A2E), // Dark navy
                    _backgroundAnimation.value,
                  )!,
                  Color.lerp(
                    const Color(0xFF90CAF9), // Lighter blue
                    const Color(0xFF16213E), // Darker navy
                    _backgroundAnimation.value,
                  )!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.isDarkMode
                      ? Colors.black.withAlpha((0.3 * 255).round())
                      : Colors.grey.withAlpha((0.2 * 255).round()),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Stars animation for dark mode
                if (_backgroundAnimation.value > 0.3)
                  ...List.generate(3, (index) {
                    return Positioned(
                      left: 8 + (index * 8.0),
                      top: widget.size.height / 2 - 2 + (index % 2 * 4),
                      child: Opacity(
                        opacity: _backgroundAnimation.value,
                        child: Icon(
                          Icons.star,
                          size: 3,
                          color: Colors.white.withAlpha((0.8 * 255).round()),
                        ),
                      ),
                    );
                  }),
                
                // Clouds animation for light mode
                if (_backgroundAnimation.value < 0.7)
                  ...List.generate(2, (index) {
                    return Positioned(
                      right: 8 + (index * 10.0),
                      top: widget.size.height / 2 - 3 + (index * 2),
                      child: Opacity(
                        opacity: 1 - _backgroundAnimation.value,
                        child: Container(
                          width: 6,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha((0.8 * 255).round()),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    );
                  }),
                
                // Moving toggle circle
                AnimatedPositioned(
                  duration: widget.animationDuration,
                  curve: Curves.easeInOut,
                  left: _switchAnimation.value * (widget.size.width - widget.size.height + 4) + 2,
                  top: 2,
                  child: Transform.rotate(
                    angle: _iconRotation.value * 6.28, // Full rotation
                    child: Container(
                      width: widget.size.height - 4,
                      height: widget.size.height - 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: widget.isDarkMode
                              ? [
                                  const Color(0xFFFFF9C4), // Light yellow
                                  const Color(0xFFFFEB3B), // Yellow
                                ]
                              : [
                                  const Color(0xFFFFFDE7), // Very light yellow
                                  const Color(0xFFFFD54F), // Golden yellow
                                ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.isDarkMode
                                ? Colors.yellow.withAlpha((0.4 * 255).round())
                                : Colors.orange.withAlpha((0.3 * 255).round()),
                            offset: const Offset(0, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                        size: widget.size.height * 0.5,
                        color: widget.isDarkMode
                            ? const Color(0xFFF57C00)
                            : const Color(0xFFFF8F00),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
