

## Getting started

To use `motion_blur` add it as a dependency in your pubspec file:
```
dependencies:
    motion_blur:
```

Then add the motion blur shader asset under the `flutter` section:
```
flutter:
    shaders:
        - packages/motion_blur/shaders/motion_blur.glsl
```

## Usage

To use, simply wrap the moving widget in a `MotionBlur` widget:


```dart
MotionBlur(
    child: MovingWidget()
)
```

Make sure to provide enough padding in the moving widget such that the motion blur does not get cut off as the shader is not able to paint beyond the size of its child.

You can also control the intensity of the motion blur by providing a double value where 1.0 is exact interpolation between a frame and the previous frame:

```dart
MotionBlur(
    intensity:1.5,
    child: MovingWidget()
)
```

## Additional information

Unfortunately due to an issue in CanvasKit the performance on web is currently quite suboptimal. Performance can be improved by only using motion blur with small widgets and adding ` --dart-define=BROWSER_IMAGE_DECODING_ENABLED=false` to your build command.
