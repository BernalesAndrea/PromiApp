import 'package:flutter/material.dart';
import 'package:promi/home.dart';
import 'package:promi/summary.dart';

class Promiform extends StatefulWidget {
  const Promiform({super.key});

  @override
  State<Promiform> createState() => _PromiformState();
}

class _PromiformState extends State<Promiform> {
  TextEditingController _dateController = TextEditingController();
  String? _selectedTimeSlot;
  bool? _isPaidOnTime;

  // Separate controllers for each text field
  TextEditingController _courseYear = TextEditingController();
  TextEditingController _fullName = TextEditingController();
  TextEditingController _reasonController = TextEditingController();
  TextEditingController _balanceController = TextEditingController();
  TextEditingController _amountToPayController = TextEditingController();
  TextEditingController _timesAppliedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) => Home()));
          },
        ),
        title: const Text('Promissory Schedule'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Date', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'DATE',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () {
                  _selectedDate();
                },
              ),
              const SizedBox(height: 10),
              if (_dateController.text.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select Time', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        _buildTimeSlotButton('8:00 AM - 11:30 PM'),
                        const SizedBox(height: 10),
                        _buildTimeSlotButton('1:00 PM - 5:00 PM'),
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              const Text(
                'Promissory Form',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildTextField('Course & Year', _courseYear, 'BSIT 3'),
              _buildTextField('Full Name', _fullName, 'Dela Cruz, Juan'),
              _buildTextField('Reason of Promissory', _reasonController,
                  'Brief explanation'),
              _buildTextField('Balance', _balanceController, 'Tuition balance'),
              _buildTextField(
                  'Amount to Pay', _amountToPayController, 'Enter amount'),
              _buildTextField(
                  'How many times have you applied for a promissory?',
                  _timesAppliedController,
                  'Enter number'),

              const SizedBox(height: 10),

              const Text('Did you pay the promissory on time?',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 5),
              Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: _isPaidOnTime,
                    onChanged: (value) {
                      setState(() {
                        _isPaidOnTime = value as bool?;
                      });
                    },
                  ),
                  const Text('Yes'),
                  Radio(
                    value: false,
                    groupValue: _isPaidOnTime,
                    onChanged: (value) {
                      setState(() {
                        _isPaidOnTime = value as bool?;
                      });
                    },
                  ),
                  const Text('No'),
                ],
              ),
              const SizedBox(height: 20), // Spacing before submit button

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_dateController.text.isNotEmpty &&
                        _selectedTimeSlot != null &&
                        _courseYear.text.isNotEmpty &&
                        _fullName.text.isNotEmpty &&
                        _reasonController.text.isNotEmpty &&
                        _balanceController.text.isNotEmpty &&
                        _amountToPayController.text.isNotEmpty &&
                        _timesAppliedController.text.isNotEmpty &&
                        _isPaidOnTime != null) {
                      //it will show on status box and if removed, matanggal man sa summary
                      String appointmentDetails =
                          //'Student Number: ${_firstName}'
                          'Date: \n ${_dateController.text}\n\n'
                          'Time: \n $_selectedTimeSlot\n\n'
                          'Course and Year: \n ${_courseYear.text}\n\n'
                          'Full Name: \n ${_fullName.text}\n\n'
                          'Reason: \n ${_reasonController.text}\n\n'
                          'Balance: \n ${_balanceController.text}\n\n'
                          'Amount to Pay: \n ${_amountToPayController.text}\n\n'
                          'Times Applied: \n ${_timesAppliedController.text}\n\n'
                          'Paid On Time: \n ${_isPaidOnTime! ? "Yes" : "No"}'; // Fix concatenation

                      // Navigate to Home and pass the appointment details
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => Home(
                                reservedAppointment: appointmentDetails,
                              )));
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build text fields dynamically
  Widget _buildTextField(
      String label, TextEditingController controller, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildTimeSlotButton(String timeSlot) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedTimeSlot = timeSlot;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedTimeSlot == timeSlot
            ? Colors.orange
            : Colors.grey.shade300,
        foregroundColor: Colors.black,
      ),
      child: Text(timeSlot),
    );
  }

  Future<void> _selectedDate() async { // Date picker
  DateTime now = DateTime.now();
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: now,
    firstDate: DateTime(now.year, now.month, now.day), // Prevent past dates
    lastDate: DateTime(2100),
  );

  if (picked != null) {
    setState(() {
      _dateController.text = picked.toString().split(" ")[0];
    });
  }
}

}
