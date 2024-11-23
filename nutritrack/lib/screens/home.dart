import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutritrack/models/patient.dart';
import 'package:nutritrack/widgets/patientcard.dart';
import 'package:nutritrack/controllers/patientdatacontroller.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PatientDataController _dataController = PatientDataController();
  List<Patient> _patients = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  void _loadPatients() async {
    List<Patient> patients = await _dataController.fetchPatients();
    setState(() {
      _patients = patients;
    });
  }

  void _showAddPatientModal(BuildContext context) {
    String name = '';
    String id = '';
    String calorieIntake = '';
    String age = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16.0,
          ),
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
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    age = value;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    Patient newPatient = Patient(
                      name: name,
                      id: id,
                      foodServed: false,
                      foodEaten: false,
                      timeLeft: 20, // Default time
                    );
                    await _dataController.addPatient(newPatient);
                    _loadPatients(); // Refresh patient list
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

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
              patientName: patient.name,
              patientId: patient.id,
              foodServed: patient.foodServed,
              foodEaten: patient.foodEaten,
              timeLeft: patient.timeLeft,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPatientModal(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
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
