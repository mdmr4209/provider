import 'package:flutter/material.dart';

class TestHomeView extends StatelessWidget {
  const TestHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TestHomeView')),
      body: const Center(child: Text('TestHomeView is working!')),
    );
  }
}
