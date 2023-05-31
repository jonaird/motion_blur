import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'dart:ui' as ui;

class MotionBlur extends StatefulWidget {
  const MotionBlur({
    super.key,
    this.intensity = 1.0,
    this.enabled = true,
    required this.child,
  });
  final Widget child;

  ///The intensity of the motion blur
  final double intensity;

  ///Whether to enable the shader.
  final bool enabled;

  @override
  State<MotionBlur> createState() => _MotionBlurState();
}

class _MotionBlurState extends State<MotionBlur> {
  Size? prevSize;
  Offset? prevPosition;
  ui.Image? prevFrame;

  @override
  void didUpdateWidget(covariant MotionBlur oldWidget) {
    if (oldWidget.child != widget.child ||
        oldWidget.intensity != widget.intensity ||
        oldWidget.enabled != widget.enabled) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder((context, shader, child) {
      return AnimatedSampler(
        enabled: widget.enabled,
        (frame, size, canvas) {
          final position = (context.findRenderObject()! as RenderBox)
              .localToGlobal(Offset.zero);
          var deltaPosition = (prevPosition ?? position) - position;
          shader
            ..setFloat(0, size.width)
            ..setFloat(1, size.height)
            ..setFloat(2, (prevSize ?? size).width)
            ..setFloat(3, (prevSize ?? size).height)
            ..setFloat(4, deltaPosition.dx)
            ..setFloat(5, deltaPosition.dy)
            ..setFloat(6, widget.intensity)
            ..setImageSampler(0, frame);
          canvas.drawRect(
            Offset.zero & size,
            Paint()..shader = shader,
          );
          prevSize = size;
          prevFrame?.dispose();
          prevFrame = frame.clone();
          prevPosition = position;
        },
        child: widget.child,
      );
    }, assetKey: 'packages/motion_blur/shaders/motion_blur.glsl');
  }
}
