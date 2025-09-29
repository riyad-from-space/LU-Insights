import 'package:flutter/material.dart';

class ClassroomsScreen extends StatelessWidget {
  const ClassroomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Classrooms'), backgroundColor: Colors.deepPurple),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('Classroom details will be shown here.',
              style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
