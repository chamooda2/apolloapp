import 'package:flutter/material.dart';
import '../models/patient.dart';

class PatientDataController extends ChangeNotifier {
  // List to store patient data
  List<Patient> _patients = [];

  List<Patient> get patients => _patients;

  // Method to add a new patient
  void addPatient(Patient patient) {
    _patients.add(patient);
    notifyListeners(); // Notify listeners (widgets) to rebuild
  }

  // Method to remove a patient by their id
  void removePatient(String patientId) {
    _patients.removeWhere((patient) => patient.id == patientId);
    notifyListeners();
  }

  // Method to update patient data (if needed)
  void updatePatient(Patient updatedPatient) {
    int index =
        _patients.indexWhere((patient) => patient.id == updatedPatient.id);
    if (index != -1) {
      _patients[index] = updatedPatient;
      notifyListeners();
    }
  }

  // Initialize with some dummy data (can be replaced with Firebase calls)
  void initialize() {
    _patients = [
      Patient(
          id: '101',
          name: 'Patient 1',
          foodServed: true,
          foodEaten: true,
          timeLeft: 20),
      Patient(
          id: '102',
          name: 'Patient 2',
          foodServed: false,
          foodEaten: false,
          timeLeft: 15),
      Patient(
          id: '103',
          name: 'Patient 3',
          foodServed: true,
          foodEaten: false,
          timeLeft: 10),
    ];
    notifyListeners();
  }
}
