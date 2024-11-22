import 'package:flutter/material.dart';

class PatientCard extends StatelessWidget {
  final String patientName;
  final String patientId;
  final bool foodServed;
  final bool foodEaten;
  final int timeLeft; // Time left in minutes

  const PatientCard({
    required this.patientName,
    required this.patientId,
    required this.foodServed,
    required this.foodEaten,
    required this.timeLeft,
  });

  @override
  Widget build(BuildContext context) {
    Color getClockColor(int time) {
      if (time < 10) return Colors.red;
      if (time < 15) return Colors.orange;
      if (time <= 20) return Colors.green;
      return Colors.grey; // Default color for times > 20 minutes
    }

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Section: Patient Name and ID
            Row(
              children: [
                Expanded(
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
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Text(
                        patientId,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            // Bottom Section: Served, Eaten, and Clock
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 8,
                          backgroundColor:
                              foodServed ? Colors.green : Colors.red,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Served',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 8,
                          backgroundColor:
                              foodEaten ? Colors.green : Colors.red,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Eaten',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                // Clock Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time,
                      color: getClockColor(timeLeft),
                      size: 30,
                    ),
                    SizedBox(height: 5),
                    Text(
                      '$timeLeft min',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
