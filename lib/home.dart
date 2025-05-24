import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:promi/promiform.dart';
import 'package:promi/summary.dart';
import 'package:promi/settings.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key, String? reservedAppointment});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _reservedAppointment;
  bool _isLoading = true;
  List<String> _adminAnnouncements = [];

  @override
  void initState() {
    super.initState();
    _checkExistingReservation();
    listenToReservationUpdates();
    fetchAdminAnnouncements();
    listenToAnnouncements();
  }

  Future<void> _checkExistingReservation() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    var querySnapshot = await FirebaseFirestore.instance
        .collection('promiform')
        .where('userId', isEqualTo: user.uid)
        .get();

    setState(() {
      if (querySnapshot.docs.isNotEmpty) {
        _reservedAppointment = querySnapshot.docs.first.id;
      }
      _isLoading = false;
    });
  }

  void fetchAdminAnnouncements() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('announcement')
        .orderBy('timestamp', descending: true) // Orders by latest first
        .limit(1) // Fetch only the latest announcement
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        _adminAnnouncements = [snapshot.docs.first['announcement'].toString()];
      });
    }
  }

  void listenToAnnouncements() {
    FirebaseFirestore.instance
        .collection('announcement')
        .orderBy('timestamp', descending: true) // Orders by latest first
        .limit(1) // Fetch only the latest announcement
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _adminAnnouncements = [
            snapshot.docs.first['announcement'].toString()
          ];
        });
      }
    });
  }

  void listenToReservationUpdates() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    FirebaseFirestore.instance
        .collection('promiform')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _reservedAppointment =
            snapshot.docs.isNotEmpty ? snapshot.docs.first.id : null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(2, 46, 6, 1),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                    const Text(
                      'Announcements',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Inter',
                        fontSize: 20,
                        height: 2,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _adminAnnouncements.isNotEmpty ? 1 : 0,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          color: Color.fromRGBO(239, 179, 49, 1),
                          child: ListTile(
                            title: Text(
                              _adminAnnouncements[index],
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold, // Make the text bold
                              ),
                            ),
                          ),
                        );
                      },
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
                      onPressed: (_reservedAppointment == null ||
                              _reservedAppointment!.isEmpty)
                          ? () async {
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Promiform(),
                                ),
                              );
                              if (result != null) {
                                setState(() {
                                  _reservedAppointment =
                                      result['reservedAppointment'];
                                });
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(239, 179, 49, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(double.infinity, 69),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.black),
                          SizedBox(width: 8),
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
                    if (_reservedAppointment == null ||
                        _reservedAppointment!.isEmpty)
                      Center(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(2, 46, 6, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "No Reserved Appointment",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Inter',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    else
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => Summary(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(239, 179, 49, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(double.infinity, 69),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.visibility, color: Colors.black),
                              SizedBox(width: 8),
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
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        backgroundColor: Colors.transparent,
        color: Color.fromRGBO(2, 46, 6, 1),
        buttonBackgroundColor: Color.fromRGBO(2, 46, 6, 1),
        height: 60,
        animationDuration: Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Color.fromRGBO(239, 179, 49, 1)),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          if (index == 0) {
            // already on home
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Setting()),
            );
          }
        },
      ),
    );
  }
}
