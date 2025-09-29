import 'package:flutter/material.dart';

class BusSchedulesScreen extends StatelessWidget {
  const BusSchedulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Bus Schedules'),
          backgroundColor: Colors.deepPurple),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('Bus schedules will be shown here.',
              style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
