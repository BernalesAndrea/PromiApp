import 'package:flutter/material.dart';
import 'package:promi/home.dart';

class Summary extends StatefulWidget {
  final String? reservedAppointment;
  final String reason;
  final String balance;
  final String amountToPay;
  final String timesApplied;
  final bool isPaidOnTime;
  final String studentNumber;

  const Summary({
    super.key,
    this.reservedAppointment,
    required this.reason,
    required this.balance,
    required this.amountToPay,
    required this.timesApplied,
    required this.isPaidOnTime,
    required this.studentNumber,
    required String fullName,
  });

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  void _confirmCancelAppointment() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cancel Appointment"),
          content: const Text("Are you sure you want to cancel your appointment?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) => const Home()),
                );
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

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
            const SizedBox(height: 20),
            if (widget.reservedAppointment != null && widget.reservedAppointment!.isNotEmpty)
              Text('Reserved Appointment Details: \n${widget.reservedAppointment}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _confirmCancelAppointment,
              child: const Text('Cancel Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
