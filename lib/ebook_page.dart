import 'package:flutter/material.dart';

class EbookPage extends StatelessWidget {
  const EbookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('电子书'),
        backgroundColor: Color(0xFFF5DEB3),
        foregroundColor: Color(0xFFB8860B),
        elevation: 1,
      ),
      body: const Center(
        child: Text(
          '这里是电子书页面',
          style: TextStyle(fontSize: 24, color: Color(0xFFB8860B)),
        ),
      ),
    );
  }
}