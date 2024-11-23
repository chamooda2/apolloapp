import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutritrack/models/patient.dart'; // Adjust the import path to your Patient model.

class PatientDataController {
  final CollectionReference _patientsCollection =
      FirebaseFirestore.instance.collection('patients');

  // Fetch all patients from Firestore
  Future<List<Patient>> fetchPatients() async {
    try {
      QuerySnapshot querySnapshot = await _patientsCollection.get();
      return querySnapshot.docs.map((doc) {
        return Patient.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching patients: $e');
      return [];
    }
  }

  // Add a new patient to Firestore
  Future<void> addPatient(Patient patient) async {
    try {
      await _patientsCollection.add(patient.toFirestore());
    } catch (e) {
      print('Error adding patient: $e');
    }
  }
}
