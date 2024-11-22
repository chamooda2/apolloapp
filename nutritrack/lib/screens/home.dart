import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:nutritrack/screens/calender.dart';
import 'package:nutritrack/screens/camera.dart';
import 'package:nutritrack/screens/settings.dart';
import 'package:nutritrack/widgets/patientcard.dart'; // Import the PatientCard widget

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    PatientGridScreen(), // This will replace the current Home content.
    CalendarScreen(),
    CameraScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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

class PatientGridScreen extends StatefulWidget {
  @override
  _PatientGridScreenState createState() => _PatientGridScreenState();
}

class _PatientGridScreenState extends State<PatientGridScreen> {
  List<Map<String, dynamic>> _patients = [
    {
      'name': 'Patient 1',
      'id': 'ID: 101',
      'foodServed': true,
      'foodEaten': true,
      'timeLeft': 20,
    },
    {
      'name': 'Patient 2',
      'id': 'ID: 102',
      'foodServed': false,
      'foodEaten': false,
      'timeLeft': 15,
    },
    {
      'name': 'Patient 3',
      'id': 'ID: 103',
      'foodServed': true,
      'foodEaten': false,
      'timeLeft': 10,
    },
  ];

  void _showAddPatientModal(BuildContext context) {
    String name = '';
    String id = '';
    String calorieIntake = '';
    String age = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the modal to resize for the keyboard
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16.0,
          ), // Adjust padding for the keyboard
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add New Patient',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Patient ID',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    id = value;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Calorie Intake (Prescribed)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType:
                      TextInputType.number, // Restricts the keyboard to numbers
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly, // Allows only digits
                  ],
                  onChanged: (value) {
                    calorieIntake = value;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType:
                      TextInputType.number, // Restricts the keyboard to numbers
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly, // Allows only digits
                  ],
                  onChanged: (value) {
                    age = value;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _patients.add({
                        'name': name,
                        'id': id,
                        'foodServed': false,
                        'foodEaten': false,
                        'timeLeft': 20, // Default time
                      });
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Add Patient'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: _patients.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final patient = _patients[index];
            return PatientCard(
              patientName: patient['name'],
              patientId: patient['id'],
              foodServed: patient['foodServed'],
              foodEaten: patient['foodEaten'],
              timeLeft: patient['timeLeft'],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPatientModal(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
