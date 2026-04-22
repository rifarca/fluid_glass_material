import 'package:flutter/material.dart';
import 'smart_wrapper.dart';
import 'types.dart';
import 'render_mode.dart';

extension FluidGlassExtension on Widget {
  Widget fluidGlass({
    FluidGlassType type = FluidGlassType.regular,
    double intensity = 1.0,
    double noiseIntensity = 0.04,
    FluidGlassRenderMode mode = FluidGlassRenderMode.auto,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(20)),
    Duration duration = const Duration(milliseconds: 250),
    Curve curve = Curves.easeOutCubic,
  }) {
    return FluidGlassSmartWrapper(
      child: this,
      type: type,
      intensity: intensity,
      noiseIntensity: noiseIntensity,
      mode: mode,
      borderRadius: borderRadius,
      duration: duration,
      curve: curve,
    );
  }
}
