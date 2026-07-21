import 'package:flutter/material.dart';

class MicButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isListening;

  const MicButton({super.key, this.onTap, this.isListening = false});

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton> with TickerProviderStateMixin {
  late List<AnimationController> _ringControllers;
  static const int _maxRings = 3;
  static const Duration _ringDuration = Duration(milliseconds: 5000);
  static const Duration _ringDelay = Duration(milliseconds: 1500);

  @override
  void initState() {
    super.initState();
    _ringControllers = List.generate(_maxRings, (index) {
      final controller = AnimationController(
        duration: _ringDuration,
        vsync: this,
      );
      Future.delayed(_ringDelay * index, () {
        if (mounted) {
          controller.repeat();
        }
      });
      return controller;
    });
  }

  @override
  void dispose() {
    for (var controller in _ringControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 220,
        height: 220,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ..._ringControllers.asMap().entries.map((entry) {
              final controller = entry.value;
              return AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  final size = Tween<double>(begin: 64, end: 220).evaluate(
                    CurvedAnimation(parent: controller, curve: Curves.easeOut),
                  );
                  final opacity = Tween<double>(begin: 0.4, end: 0.0).evaluate(
                    CurvedAnimation(parent: controller, curve: Curves.easeOut),
                  );

                  final ringOpacity = widget.isListening
                      ? opacity + 0.3
                      : opacity;

                  return Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(
                          alpha: ringOpacity.clamp(0.0, 1.0),
                        ),
                        width: 1.5,
                      ),
                    ),
                  );
                },
              );
            }),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isListening
                    ? Colors.white.withValues(alpha: 0.25)
                    : Colors.white.withValues(alpha: 0.12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
              ),
              child: Icon(
                widget.isListening ? Icons.mic : Icons.mic_off,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
