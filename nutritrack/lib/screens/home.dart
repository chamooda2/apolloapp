import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
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
          itemCount: 5, // Number of patients (can be dynamic)
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two cards per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.2, // Adjust the aspect ratio for card size
          ),
          itemBuilder: (context, index) {
            return PatientCard(
              patientName: 'Patient ${index + 1}',
              patientId: 'ID: ${index + 100}',
              patientStatus: index % 2 == 0 ? 'Stable' : 'Critical',
            );
          },
        ),
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  final String patientName;
  final String patientId;
  final String patientStatus;

  const PatientCard({
    required this.patientName,
    required this.patientId,
    required this.patientStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              patientName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 10),
            Text(
              patientId,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Status: $patientStatus',
              style: TextStyle(
                fontSize: 14,
                color: patientStatus == 'Stable' ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}
