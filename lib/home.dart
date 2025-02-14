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
      body: ListView.separated(
        itemCount: 100,
        padding: const EdgeInsets.all(16),
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder:
            (context, index) => PointerTarget(
              key: GlobalObjectKey('item $index'),
              child: Card(
                child: ListTile(
                  title: Text('Item $index'),
                  subtitle: const Text('Subtitle'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
      ),
    );
  }
}
