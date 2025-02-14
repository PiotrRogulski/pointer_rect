import 'package:flutter/material.dart';

class PointerRectManager extends StatefulWidget {
  const PointerRectManager({super.key, required this.child});

  static InheritedPointerRectManager of(BuildContext context) {
    final result =
        context
            .dependOnInheritedWidgetOfExactType<InheritedPointerRectManager>();
    assert(result != null, 'No InheritedPointerRectManager found in context');
    return result!;
  }

  final Widget child;

  @override
  State<PointerRectManager> createState() => _PointerRectManagerState();
}

class _PointerRectManagerState extends State<PointerRectManager> {
  (GlobalKey key, Rect rect)? currentTarget;

  Offset? _pointerPosition;

  Rect? get _rectToDisplay =>
      currentTarget?.$2 ??
      switch (_pointerPosition) {
        final position? => Rect.fromCenter(
          center: position,
          width: 16,
          height: 16,
        ),
        _ => null,
      };

  void addTarget(GlobalKey key, Rect rect) {
    setState(() => currentTarget = (key, rect));
  }

  void removeTarget(Key key) {
    if (currentTarget?.$1 == key) {
      setState(() => currentTarget = null);
    }
  }

  void updateTarget(GlobalKey key, Rect rect) {
    if (currentTarget?.$1 == key) {
      setState(() => currentTarget = (key, rect));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => _pointerPosition = event.position),
      onHover: (event) => setState(() => _pointerPosition = event.position),
      onExit: (_) => setState(() => _pointerPosition = null),
      child: Stack(
        children: [
          InheritedPointerRectManager(
            addTarget: addTarget,
            removeTarget: removeTarget,
            updateTarget: updateTarget,
            child: widget.child,
          ),
          if (_rectToDisplay case final rect?)
            AnimatedPositioned.fromRect(
              rect: rect,
              duration: Durations.short4,
              curve: Curves.easeInOutCubicEmphasized,
              child: IgnorePointer(
                child: ColoredBox(color: Colors.red.withValues(alpha: 0.25)),
              ),
            ),
        ],
      ),
    );
  }
}

class InheritedPointerRectManager extends InheritedWidget {
  const InheritedPointerRectManager({
    super.key,
    required this.addTarget,
    required this.removeTarget,
    required this.updateTarget,
    required super.child,
  });

  final void Function(GlobalKey key, Rect rect) addTarget;
  final void Function(Key key) removeTarget;
  final void Function(GlobalKey key, Rect rect) updateTarget;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      oldWidget is InheritedPointerRectManager &&
      (addTarget != oldWidget.addTarget ||
          removeTarget != oldWidget.removeTarget ||
          updateTarget != oldWidget.updateTarget);
}
