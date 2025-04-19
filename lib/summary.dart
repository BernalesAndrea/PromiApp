import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:promi/home.dart';

class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  String? reservedAppointment;

  @override
  void initState() {
    super.initState();
    _fetchReservedAppointment();
  }

  Future<void> _fetchReservedAppointment() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    var snapshot = await FirebaseFirestore.instance
        .collection('promiform')
        .where('userId', isEqualTo: user.uid)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var data = snapshot.docs.first.data();
      setState(() {
        reservedAppointment = 
            'Status: \n${data['status'] ?? 'Pending'}\n\n'
            'Date: \n${(data['date'] as Timestamp).toDate().toLocal().toString().split(' ')[0]}\n\n'
            'Time: \n${data['selectedTime']}\n\n'
            'Course and Year: \n${data['courseYear']}\n\n'
            'Full Name: \n${data['fullName']}\n\n'
            'Reason: \n${data['reason']}\n\n'
            'Balance: \n${data['balance']}\n\n'
            'Amount to Pay: \n${data['amountToPay']}\n\n'
            'Times Applied: \n${data['timesApplied']}\n\n'
            'Paid On Time: \n${data['isPaidOnTime'] ? "Yes" : "No"}';
      });
    }
  }

  Future<void> _cancelAppointment() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    var snapshot = await FirebaseFirestore.instance
        .collection('promiform')
        .where('userId', isEqualTo: user.uid)
        .get();

    for (var doc in snapshot.docs) {
      await FirebaseFirestore.instance.collection('promiform').doc(doc.id).delete();
    }
  }

  void _confirmCancelAppointment() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cancel Appointment"),
          content: const Text("Are you sure you want to cancel your appointment?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                await _cancelAppointment();
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
      appBar: AppBar(title: const Text('Appointment Summary')),
      backgroundColor: const Color.fromRGBO(239, 179, 49, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (reservedAppointment != null)
                Text(
                  'Reserved Appointment Details: \n\n$reservedAppointment',
                  style: const TextStyle(fontSize: 18),
                )
              else
                const Text('No reserved appointment found.', style: TextStyle(fontSize: 18)),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _confirmCancelAppointment,
                child: const Center(child: Text('Cancel Appointment')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
