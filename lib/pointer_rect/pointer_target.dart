import 'package:flutter/material.dart';
import 'package:pointer_rect/pointer_rect/manager.dart';

class PointerTarget extends StatefulWidget {
  const PointerTarget({required GlobalKey super.key, required this.child});

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

  Rect get _rect {
    final renderBox = key.currentContext!.findRenderObject()! as RenderBox;
    return renderBox.localToGlobal(Offset.zero) & renderBox.size;
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
