import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Since HomeScreen's AppBar is already present, we don't need to define it here.
    return Center(
      child: Text(
        'Timeline Placeholder (Add graph or timeline here)',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}
