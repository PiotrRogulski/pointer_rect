import 'package:flutter/material.dart';
import 'package:pointer_rect/home.dart';
import 'package:pointer_rect/pointer_rect/manager.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: PointerRectManager(child: Home()));
  }
}
