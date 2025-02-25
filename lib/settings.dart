import 'package:flutter/material.dart';
import 'package:promi/home.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Use the available width and height from constraints
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          return Container(
            width: width,
            height: height,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(239, 179, 49, 1),
            ),
            child: Stack(
              children: [
                // LOGO positioned relative to the screen size
                Positioned(
                  top: height * 0.29375, // originally 188/640
                  left: 0,
                  right: 0,
                  child: const Center(
                    child: Text(
                      'LOGO',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Inter',
                        fontSize: 40,
                        fontWeight: FontWeight.normal,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                // Name
                Positioned(
                  top: height * 0.3797, // originally 243/640
                  left: 0,
                  right: 0,
                  child: const Center(
                    child: Text(
                      'Name',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        height: 2,
                      ),
                    ),
                  ),
                ),
                // Student Number
                Positioned(
                  top: height * 0.4531, // originally 290/640
                  left: 0,
                  right: 0,
                  child: const Center(
                    child: Text(
                      'Student Number',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        height: 2,
                      ),
                    ),
                  ),
                ),
                // Logout Button
                Positioned(
                  top: height * 0.5266, // originally 337/640
                  left: width * 0.3056,
                  child: Container(
                    width: width * 0.3889, // originally 140/360
                    height: height * 0.0594, // originally 38/640
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromRGBO(2, 46, 6, 1),
                    ),
                    child: const Center(
                      child: Text(
                        'Logout',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Patrick Hand',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                // Bottom Container (if needed for styling or additional elements)
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Settings page is selected by default
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
            );
          }
        },
      ),
    );
  }
}
