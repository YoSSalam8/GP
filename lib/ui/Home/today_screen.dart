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
        location =
        "${placemarks[0].street}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}";
      });
    } catch (e) {
      setState(() {
        location = "Unable to determine location.";
      });
    }
  }

  void _scheduleMidnightReset() {
    DateTime now = DateTime.now();
    DateTime nextMidnight = DateTime(now.year, now.month, now.day + 1, 0, 0, 0);

    Duration timeUntilMidnight = nextMidnight.difference(now);

    Timer(timeUntilMidnight, _resetCheckInCheckOut);
  }

  void _resetCheckInCheckOut() {
    setState(() {
      checkIn = "--/--";
      checkOut = "--/--";
      location = " ";
    });

    _scheduleMidnightReset();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    bool isWeb = screenWidth > 600;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: isWeb ? screenWidth * 0.2 : 20, // Add margins for web
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreeting(),
            const SizedBox(height: 32),
            _buildStatusCard(isWeb),
            const SizedBox(height: 20),
            _buildCurrentTimeAndDate(isWeb),
            const SizedBox(height: 24),
            _buildSlideAction(isWeb),
            const SizedBox(height: 32),
            if (location != " ") _buildLocation(isWeb),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome",
          style: TextStyle(
            color: Colors.black87,
            fontSize: screenWidth > 600 ? 32 : 24, // Larger font for web
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Employee",
          style: TextStyle(
            color: Colors.black,
            fontSize: screenWidth > 600 ? 32 : 24, // Larger font for web
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(bool isWeb) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: isWeb ? 700 : double.infinity, // Limit card width for web
      ),
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
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
          _buildStatusColumn("Check In", checkIn, isWeb),
          Container(
            width: 1,
            height: 60,
            color: Colors.grey,
          ), // Divider between columns
          _buildStatusColumn("Check Out", checkOut, isWeb),
        ],
      ),
    );
  }

  Widget _buildStatusColumn(String label, String time, bool isWeb) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: isWeb ? 20 : 16, // Adjust font size for web
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.black,
              fontSize: isWeb ? 28 : 20, // Adjust font size for web
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTimeAndDate(bool isWeb) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder(
          stream: Stream.periodic(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            return Text(
              DateFormat('hh:mm:ss a').format(DateTime.now()),
              style: TextStyle(
                fontSize: isWeb ? 24 : 18, // Adjust font size for web
                color: Colors.black,
              ),
            );
          },
        ),
        Text(
          DateFormat('dd MMMM yyyy').format(DateTime.now()),
          style: TextStyle(
            fontSize: isWeb ? 24 : 18, // Adjust font size for web
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildSlideAction(bool isWeb) {
    final GlobalKey<SlideActionState> checkInKey = GlobalKey<SlideActionState>();
    final GlobalKey<SlideActionState> checkOutKey = GlobalKey<SlideActionState>();

    if (checkOut != "--/--") {
      return Center(
        child: Text(
          "You have completed this day!",
          style: TextStyle(
            fontSize: isWeb ? 24 : 18, // Adjust font size for web
            color: Colors.black87,
          ),
        ),
      );
    }

    return checkIn == "--/--"
        ? SlideAction(
      text: "Slide To Check In",
      textStyle: TextStyle(
        color: Colors.black45,
        fontSize: isWeb ? 22 : 16, // Adjust font size for web
      ),
      outerColor: Colors.white,
      innerColor: Colors.green,
      key: checkInKey,
      onSubmit: () {
        setState(() {
          checkIn = DateFormat('hh:mm').format(DateTime.now());
          _getLocation();
        });
        checkInKey.currentState!.reset();
      },
    )
        : SlideAction(
      text: "Slide To Check Out",
      textStyle: TextStyle(
        color: Colors.black45,
        fontSize: isWeb ? 22 : 16, // Adjust font size for web
      ),
      outerColor: Colors.white,
      innerColor: Colors.red,
      key: checkOutKey,
      onSubmit: () {
        setState(() {
          checkOut = DateFormat('hh:mm').format(DateTime.now());
          AttendanceData().addRecord(
            DateFormat('dd MMMM yyyy').format(DateTime.now()),
            checkIn,
            checkOut,
          );
        });
        checkOutKey.currentState!.reset();
      },
    );
  }

  Widget _buildLocation(bool isWeb) {
    return Text(
      "Location: $location",
      style: TextStyle(
        color: Colors.black54,
        fontSize: isWeb ? 22 : 16, // Adjust font size for web
      ),
    );
  }
}
