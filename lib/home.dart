import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:promi/promiform.dart';
import 'package:promi/summary.dart';

class Home extends StatefulWidget {
  final String?
      reservedAppointment; // New variable to store appointment details

  const Home({super.key, this.reservedAppointment});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _reservedAppointment; // Local state to store appointment details

  // Additional variables to store details from the form
  String reason = '';
  String balance = '';
  String amountToPay = '';
  String timesApplied = '';
  bool isPaidOnTime = true;

  @override
  void initState() {
    super.initState();
    _reservedAppointment = widget.reservedAppointment;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Calendar
              DatePicker(
                DateTime.now(),
                height: 100,
                width: 80,
                initialSelectedDate: DateTime.now(),
                selectionColor: Color.fromRGBO(2, 46, 6, 1),
                selectedTextColor: Colors.white,
                dayTextStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(2, 46, 6, 1),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Promissory Appointment',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Inter',
                  fontSize: 20,
                  height: 2,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Navigate to form and wait for result
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Promiform(),
                    ),
                  );

                  // If result is returned, update the status box and store the details
                  if (result != null) {
                    setState(() {
                      _reservedAppointment = result[
                          'reservedAppointment']; // Update reserved appointment
                      reason = result[
                          'reason']; // Assuming these fields are returned from the form
                      balance = result['balance'];
                      amountToPay = result['amountToPay'];
                      timesApplied = result['timesApplied'];
                      isPaidOnTime = result['isPaidOnTime'];
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(239, 179, 49, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize:
                      Size(double.infinity, 69), // Full width & fixed height
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.black), // Plus sign
                    SizedBox(width: 8), // Space between icon and text
                    Text(
                      "Reserve Appointment",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Reserved Appointment',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Inter',
                  fontSize: 20,
                  height: 2,
                ),
              ),
              const SizedBox(height: 10),

              // If no appointment is reserved, show the message. Otherwise, show the button.
              if (_reservedAppointment == null || _reservedAppointment!.isEmpty)
                Center(
                  child: Container(
                    width: double.infinity, // Makes the box take full width
                    padding: EdgeInsets.symmetric(
                        vertical: 15), // Vertical padding only

                    decoration: BoxDecoration(
                      color: Color.fromRGBO(2, 46, 6, 1), // Background color
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                    alignment: Alignment.center, // Centers the text
                    child: Text(
                      "No Reserved Appointment",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              else
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Navigate to the Summary page with all the relevant details
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => Summary(
                            reservedAppointment: _reservedAppointment,
                            reason: reason,
                            balance: balance,
                            amountToPay: amountToPay,
                            timesApplied: timesApplied,
                            isPaidOnTime: isPaidOnTime, firstName: '', lastName: '', studentNumber: '',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(239, 179, 49, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(
                          double.infinity, 69), // Full width & fixed height
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.visibility, color: Colors.black), // Eye icon
                        SizedBox(width: 8), // Space between icon and text
                        Text(
                          "View Reserved Appointment",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
