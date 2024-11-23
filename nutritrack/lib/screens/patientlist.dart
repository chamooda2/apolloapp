import 'package:flutter/material.dart';
import 'package:nutritrack/widgets/patientcard.dart';
import 'package:nutritrack/models/patient.dart';
import 'package:nutritrack/controllers/patientdatacontroller.dart';

class PatientList extends StatefulWidget {
  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  List<Patient> patients = [];
  final PatientDataController _controller = PatientDataController();

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  // Fetch patients from Firebase
  Future<void> _loadPatients() async {
    List<Patient> fetchedPatients = await _controller.fetchPatients();
    setState(() {
      patients = fetchedPatients;
    });
  }

  // Show modal to add new patient
  void _showAddPatientModal(BuildContext context) {
    String name = '';
    String id = '';
    String calorieIntake =
        ''; // Assuming this will be a string (you can parse it to an int if needed)
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
                  onChanged: (value) {
                    age = value;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Convert calorieIntake to boolean (true if not empty or valid, false if empty)
                    bool foodServed = calorieIntake.isNotEmpty;
                    bool foodEaten =
                        false; // Set default to false for foodEaten
                    int timeLeft =
                        0; // Assuming 0 for timeLeft as a placeholder

                    // Create a new Patient object
                    Patient newPatient = Patient(
                      id: id,
                      name: name,
                      foodServed: foodServed,
                      foodEaten: foodEaten,
                      timeLeft: timeLeft,
                    );

                    // Add the new patient to Firebase
                    _controller.addPatient(newPatient).then((_) {
                      // Reload the patients after adding
                      _loadPatients();
                      Navigator.of(context).pop();
                    });
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
      body: patients.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              itemCount: patients.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final patient = patients[index];
                return PatientCard(
                  patientName: patient.name,
                  patientId: patient.id,
                  foodServed: patient.foodServed,
                  foodEaten: patient.foodEaten,
                  timeLeft: patient.timeLeft,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPatientModal(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
