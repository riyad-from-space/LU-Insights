import 'package:flutter/material.dart';

class StudentLiveTrackScreen extends StatelessWidget {
  const StudentLiveTrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Student Live Track'),
          backgroundColor: Colors.deepPurple),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('Student live tracking will be shown here.',
              style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
