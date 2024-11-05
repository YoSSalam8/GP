import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'attendance_data.dart'; // Import the AttendanceData class
import 'model/user.dart'; // Import for user data with latitude and longitude

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  String checkIn = "--/--";
  String checkOut = "--/--";
  String location = " ";

  @override
  void initState() {
    super.initState();
    _scheduleMidnightReset();
  }

  void _getLocation() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(User.lat, User.long);
      setState(() {
        location = "${placemarks[0].street}, ${placemarks[0].administrativeArea}, ${placemarks[0].postalCode}, ${placemarks[0].country}";
      });
    } catch (e) {
      setState(() {
        location = "Unable to determine location.";
      });
    }
  }

  void _scheduleMidnightReset() {
    DateTime now = DateTime.now();
    DateTime nextMidnight = DateTime(now.year, now.month, now.day + 1, 0, 0, 0); // 12:00 AM

    Duration timeUntilMidnight = nextMidnight.difference(now);

    Timer(timeUntilMidnight, _resetCheckInCheckOut); // Schedule reset at midnight
  }

  void _resetCheckInCheckOut() {
    setState(() {
      checkIn = "--/--";
      checkOut = "--/--";
      location = " ";
    });

    // Schedule the next reset for the following midnight
    _scheduleMidnightReset();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                "Welcome",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Employee",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                "Today's Status",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 32),
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: const Offset(2, 2),
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Check In",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          checkIn,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth / 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Check Out",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          checkOut,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth / 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat('hh:mm:ss a').format(DateTime.now()),
                    style: TextStyle(
                      fontSize: screenWidth / 20,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormat('dd MMMM yyyy').format(DateTime.now()),
                style: TextStyle(
                  fontSize: screenWidth / 20,
                  color: Colors.black,
                ),
              ),
            ),
            checkOut == "--/--"
                ? Container(
              margin: const EdgeInsets.only(top: 24, bottom: 12),
              child: Builder(
                builder: (context) {
                  final GlobalKey<SlideActionState> key = GlobalKey<SlideActionState>();
                  return SlideAction(
                    text: checkIn == "--/--" ? "Slide To Check In" : "Slide To Check Out",
                    textStyle: TextStyle(
                      color: Colors.black45,
                      fontSize: screenWidth / 20,
                    ),
                    outerColor: Colors.white,
                    innerColor: Colors.purple.shade500,
                    key: key,
                    onSubmit: () {
                      setState(() {
                        if (checkIn == '--/--' && checkOut == '--/--') {
                          checkIn = DateFormat('hh:mm').format(DateTime.now());
                          _getLocation(); // Get location on check-in
                        } else if (checkIn != '--/--' && checkOut == '--/--') {
                          checkOut = DateFormat('hh:mm').format(DateTime.now());

                          // Add check-in and check-out time with the date to AttendanceData
                          AttendanceData().addRecord(
                            DateFormat('dd MMMM yyyy').format(DateTime.now()),
                            checkIn,
                            checkOut,
                          );
                        }
                      });
                      key.currentState!.reset();
                    },
                  );
                },
              ),
            )
                : Container(
              margin: const EdgeInsets.only(top: 32, bottom: 32),
              child: Text(
                "You have completed this day!",
                style: TextStyle(
                  fontSize: screenWidth / 20,
                  color: Colors.black87,
                ),
              ),
            ),
            location != " "
                ? Text(
              "Location: $location",
              style: TextStyle(
                color: Colors.black54,
                fontSize: screenWidth / 22,
              ),
            )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
