import 'dart:ui';
import 'package:flutter/material.dart';
import 'types.dart';
import 'render_mode.dart';

class FluidGlassSmartWrapper extends StatefulWidget {
  final Widget child;
  final FluidGlassType type;
  final double intensity;
  final double noiseIntensity;
  final FluidGlassRenderMode mode;
  final BorderRadius borderRadius;
  final Duration duration;
  final Curve curve;

  const FluidGlassSmartWrapper({
    super.key,
    required this.child,
    required this.type,
    required this.intensity,
    required this.noiseIntensity,
    required this.mode,
    required this.borderRadius,
    required this.duration,
    required this.curve,
  });

  @override
  State<FluidGlassSmartWrapper> createState() => _FluidGlassSmartWrapperState();
}

class _FluidGlassSmartWrapperState extends State<FluidGlassSmartWrapper> {
  double _blur = 0;
  double _opacity = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _compute();
  }

  void _compute() {
    final brightness = Theme.of(context).brightness;

    switch (widget.type) {
      case FluidGlassType.ultraThin:
        _blur = 20;
        _opacity = brightness == Brightness.dark ? 0.08 : 0.12;
        break;
      case FluidGlassType.thin:
        _blur = 30;
        _opacity = brightness == Brightness.dark ? 0.10 : 0.15;
        break;
      case FluidGlassType.regular:
        _blur = 40;
        _opacity = brightness == Brightness.dark ? 0.12 : 0.18;
        break;
      case FluidGlassType.thick:
        _blur = 55;
        _opacity = brightness == Brightness.dark ? 0.18 : 0.25;
        break;
      case FluidGlassType.transparent:
        _blur = 0;
        _opacity = 0;
        break;
    }
  }

  FluidGlassRenderMode _resolveMode() {
    if (widget.mode != FluidGlassRenderMode.auto) return widget.mode;

    final scrollable = Scrollable.maybeOf(context);
    final inScroll = scrollable != null;

    if (inScroll && _blur > 35) return FluidGlassRenderMode.optimized;
    if (inScroll) return FluidGlassRenderMode.hybrid;
    return FluidGlassRenderMode.full;
  }

  Widget _build(double t, FluidGlassRenderMode mode) {
    final blur = _blur * widget.intensity * t;
    final opacity = _opacity * widget.intensity * t;

    final useBlur =
        mode == FluidGlassRenderMode.full ||
        (mode == FluidGlassRenderMode.hybrid && blur > 10);

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: Stack(
          children: [
            widget.child,

            if (useBlur)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: const SizedBox.expand(),
              ),

            Container(
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                color: Colors.white.withOpacity(opacity),
              ),
            ),

            // highlight
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: widget.borderRadius,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.25 * t),
                        Colors.white.withOpacity(0.05 * t),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // noise (grain)
            if (widget.noiseIntensity > 0)
              Positioned.fill(
                child: IgnorePointer(
                  child: Opacity(
                    opacity: widget.noiseIntensity,
                    child: Image.asset(
                      'assets/noise.png',
                      fit: BoxFit.cover,
                      repeat: ImageRepeat.repeat,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mode = _resolveMode();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: widget.duration,
      curve: widget.curve,
      builder: (_, t, __) => _build(t, mode),
    );
  }
}
