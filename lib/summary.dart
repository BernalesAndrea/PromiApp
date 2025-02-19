import 'package:flutter/material.dart';
import 'package:promi/home.dart';

class Summary extends StatefulWidget {
  final String? reservedAppointment;
  final String reason;
  final String balance;
  final String amountToPay;
  final String timesApplied;
  final bool isPaidOnTime;
  final String firstName; // Added
  final String lastName; // Added
  final String studentNumber; // Added

  const Summary({
    super.key,
    this.reservedAppointment,
    required this.reason,
    required this.balance,
    required this.amountToPay,
    required this.timesApplied,
    required this.isPaidOnTime,
    required this.firstName, // Added
    required this.lastName, // Added
    required this.studentNumber, // Added
  });

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display user details at the top
            Text(
              'Student Number: ${widget.studentNumber}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Name: ${widget.firstName} ${widget.lastName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            if (widget.reservedAppointment != null && widget.reservedAppointment!.isNotEmpty)
              Text('Reserved Appointment Details: \n${widget.reservedAppointment}', style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) => const Home()),
                );
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
