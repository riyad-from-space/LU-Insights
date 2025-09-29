import 'package:flutter/material.dart';

class ExamMaterialsScreen extends StatelessWidget {
  const ExamMaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Exam Materials'),
          backgroundColor: Colors.deepPurple),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('Exam materials will be shown here.',
              style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
