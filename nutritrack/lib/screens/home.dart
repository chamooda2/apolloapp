// home.dart

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:nutritrack/models/patient.dart';
// import 'package:nutritrack/controllers/patientdatacontroller.dart';
import 'package:nutritrack/screens/calendar.dart';
import 'package:nutritrack/screens/camera.dart';
import 'package:nutritrack/screens/settings.dart';
import 'patientlist.dart'; // Import PatientList widget
// import 'calendar_screen.dart';
// import 'camera_screen.dart';
// import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NutriTrack'),
        backgroundColor: Colors.orange,
        // foregroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: IndexedStack(
          index: _currentIndex,
          children: [
            // Patient List screen
            PatientList(),
            // CalendarScreen
            CalendarScreen(),
            // CameraScreen
            CameraScreen(),
            // SettingsScreen
            SettingsScreen(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _showAddPatientModal(context),
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.orange,
      // ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
