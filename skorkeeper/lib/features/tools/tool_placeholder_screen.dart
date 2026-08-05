import 'package:flutter/material.dart';

class ToolPlaceholderScreen extends StatelessWidget {
  const ToolPlaceholderScreen({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(title + ' will be implemented in a later phase.'),
      ),
    );
  }
}
