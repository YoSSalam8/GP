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

class _TodayScreenState extends State<TodayScreen> with SingleTickerProviderStateMixin {
  double screenHeight = 0;
  double screenWidth = 0;

  String checkIn = "--/--";
  String checkOut = "--/--";
  String location = " ";
  String greeting = "";

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _scheduleMidnightReset();
    _setGreeting();

    // Initialize animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  void _setGreeting() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      greeting = "Good Morning";
    } else if (hour < 18) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Evening";
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

  String _calculateTotalHours() {
    if (checkIn == "--/--" || checkOut == "--/--") return "--:--";
    try {
      DateTime inTime = DateFormat('hh:mm').parse(checkIn);
      DateTime outTime = DateFormat('hh:mm').parse(checkOut);
      Duration diff = outTime.difference(inTime);
      return "${diff.inHours}:${diff.inMinutes.remainder(60).toString().padLeft(2, '0')}";
    } catch (e) {
      return "--:--";
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    bool isWeb = screenWidth > 600;

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          height: screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey.shade300, Colors.grey.shade100],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWeb ? screenWidth * 0.2 : 20, // Adjust for web and mobile
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800), // Limit width for larger screens
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildGreeting(),
                    const SizedBox(height: 20),
                    _buildStatusCard(isWeb),
                    const SizedBox(height: 20),
                    _buildSummary(isWeb),
                    const SizedBox(height: 20),
                    _buildCurrentTimeAndDate(isWeb),
                    const SizedBox(height: 30),
                    _buildSlideAction(isWeb),
                    if (location != " ") ...[
                      const SizedBox(height: 30),
                      _buildLocation(isWeb),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          greeting,
          style: TextStyle(
            color: Colors.grey.shade900,
            fontSize: screenWidth > 600 ? 36 : 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "Welcome Back",
          style: TextStyle(
            color: Colors.black38,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(bool isWeb) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade400, Colors.grey.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatusColumn("Check In", checkIn, isWeb),
          Container(width: 1, height: 60, color: Colors.grey),
          _buildStatusColumn("Check Out", checkOut, isWeb),
        ],
      ),
    );
  }

  Widget _buildStatusColumn(String label, String time, bool isWeb) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: isWeb ? 20 : 16,
          ),
        ),
        Text(
          time,
          style: TextStyle(
            color: Colors.grey.shade900,
            fontSize: isWeb ? 28 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSummary(bool isWeb) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Summary",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.timer, color: Colors.blue),
              const SizedBox(width: 8),
              Text("Total Hours: ${_calculateTotalHours()}",
                  style: const TextStyle(color: Colors.black)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.red),
              const SizedBox(width: 8),
              Text("Location Verified: ${location != " " ? "Yes" : "No"}",
                  style: const TextStyle(color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTimeAndDate(bool isWeb) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder(
          stream: Stream.periodic(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            return Text(
              DateFormat('hh:mm:ss a').format(DateTime.now()),
              style: TextStyle(
                fontSize: isWeb ? 24 : 18,
                color: Colors.grey.shade900,
              ),
            );
          },
        ),
        Text(
          DateFormat('dd MMMM yyyy').format(DateTime.now()),
          style: TextStyle(
            fontSize: isWeb ? 24 : 18,
            color: Colors.grey.shade800,
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
            fontSize: isWeb ? 24 : 18,
            color: Colors.grey.shade900,
          ),
        ),
      );
    }

    return checkIn == "--/--"
        ? SlideAction(
      text: "Slide To Check In",
      textStyle: TextStyle(
        color: Colors.black87,
        fontSize: isWeb ? 22 : 16,
      ),
      outerColor: Colors.grey.shade300,
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
        color: Colors.black87,
        fontSize: isWeb ? 22 : 16,
      ),
      outerColor: Colors.grey.shade300,
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
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.grey.shade900,
        fontSize: isWeb ? 22 : 16,
      ),
    );
  }
}
