import 'package:flutter/material.dart';
import 'package:pointer_rect/pointer_rect/pointer_target.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const PointerTarget(
          key: GlobalObjectKey('appbar title'),
          child: Text('Home'),
        ),
        actions: [
          PointerTarget(
            key: const GlobalObjectKey('add icon'),
            child: IconButton(icon: const Icon(Icons.add), onPressed: () {}),
          ),
        ],
      ),
      body: GridView.builder(
        itemCount: 100,
        padding: const EdgeInsets.all(32),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisSpacing: 32,
          crossAxisSpacing: 32,
        ),
        itemBuilder:
            (context, index) => PointerTarget(
              key: GlobalObjectKey('item $index'),
              rectBuilder:
                  (rect) => RRect.fromRectAndRadius(
                    rect.inflate(8),
                    const Radius.circular(20),
                  ),
              child: Card.filled(
                margin: EdgeInsets.zero,
                child: Center(child: Text('Item $index')),
              ),
            ),
      ),
    );
  }
}
