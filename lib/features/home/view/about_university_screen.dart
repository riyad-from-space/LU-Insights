import 'package:flutter/material.dart';

class AboutUniversityScreen extends StatelessWidget {
  const AboutUniversityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('About University'),
          backgroundColor: Colors.deepPurple),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('Information about the University will be shown here.',
              style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
