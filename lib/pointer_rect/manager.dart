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
  (GlobalKey key, RRect rect)? currentTarget;

  Offset? _pointerPosition;

  RRect? get _rectToDisplay => currentTarget?.$2 ?? _pointerRect;

  RRect? get _pointerRect => switch (_pointerPosition) {
    final position? => RRect.fromRectAndRadius(
      Rect.fromCenter(center: position, width: 16, height: 16),
      const Radius.circular(8),
    ),
    _ => null,
  };

  void addTarget(GlobalKey key, RRect rect) {
    setState(() => currentTarget = (key, rect));
  }

  void removeTarget(Key key) {
    if (currentTarget?.$1 == key) {
      setState(() => currentTarget = null);
    }
  }

  void updateTarget(GlobalKey key, RRect rect) {
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
              rect: rect.outerRect,
              duration: Durations.short4,
              curve: Curves.easeInOutCubicEmphasized,
              child: IgnorePointer(
                child: AnimatedContainer(
                  duration: Durations.short4,
                  curve: Curves.easeInOutCubicEmphasized,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.only(
                      topLeft: rect.tlRadius,
                      topRight: rect.trRadius,
                      bottomLeft: rect.blRadius,
                      bottomRight: rect.brRadius,
                    ),
                  ),
                ),
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

  final void Function(GlobalKey key, RRect rect) addTarget;
  final void Function(Key key) removeTarget;
  final void Function(GlobalKey key, RRect rect) updateTarget;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      oldWidget is InheritedPointerRectManager &&
      (addTarget != oldWidget.addTarget ||
          removeTarget != oldWidget.removeTarget ||
          updateTarget != oldWidget.updateTarget);
}
