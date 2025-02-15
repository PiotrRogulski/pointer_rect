import 'package:flutter/material.dart';
import 'package:pointer_rect/pointer_rect/manager.dart';

class PointerTarget extends StatefulWidget {
  const PointerTarget({
    required GlobalKey super.key,
    this.rectBuilder,
    required this.child,
  });

  final RRect Function(Rect rect)? rectBuilder;
  final Widget child;

  @override
  State<PointerTarget> createState() => _PointerTargetState();
}

class _PointerTargetState extends State<PointerTarget> {
  GlobalKey get key => widget.key! as GlobalKey;

  ScrollableState? _scrollable;
  late InheritedPointerRectManager manager;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollable?.position.removeListener(_updateTarget);

    _scrollable = Scrollable.maybeOf(context);
    manager = PointerRectManager.of(context);

    _scrollable?.position.addListener(_updateTarget);
  }

  @override
  void dispose() {
    _scrollable?.position.removeListener(_updateTarget);
    super.dispose();
  }

  void _updateTarget() {
    manager.updateTarget(key, _rect);
  }

  RRect get _rect {
    final renderBox = context.findRenderObject()! as RenderBox;
    final rect = renderBox.localToGlobal(Offset.zero) & renderBox.size;
    return widget.rectBuilder?.call(rect) ??
        RRect.fromRectAndRadius(rect, Radius.zero);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => manager.addTarget(key, _rect),
      onExit: (_) => manager.removeTarget(key),
      onHover: (_) => manager.updateTarget(key, _rect),
      child: widget.child,
    );
  }
}
