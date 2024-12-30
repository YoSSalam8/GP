import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

class AdminCheckInOutScreen extends StatefulWidget {
  const AdminCheckInOutScreen({super.key});

  @override
  State<AdminCheckInOutScreen> createState() => _AdminCheckInOutScreenState();
}

class _AdminCheckInOutScreenState extends State<AdminCheckInOutScreen> {
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
    bool isWeb = screenWidth > 600; // Check for web layout

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWeb ? 800 : double.infinity, // Constrain width for web
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWeb ? 40 : 20, // Extra padding for web
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGreeting(isWeb),
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(bool isWeb) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome, Admin",
          style: TextStyle(
            color: Colors.black87,
            fontSize: isWeb ? 28 : 20, // Larger font for web
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(bool isWeb) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatusColumn("Check In", checkIn, isWeb),
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
              color: Colors.black87,
              fontSize: isWeb ? 18 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.black,
              fontSize: isWeb ? 22 : 18,
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
                fontSize: isWeb ? 20 : 18,
                color: Colors.black87,
              ),
            );
          },
        ),
        Text(
          DateFormat('dd MMMM yyyy').format(DateTime.now()),
          style: TextStyle(
            fontSize: isWeb ? 20 : 18,
            color: Colors.black87,
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
          "You have completed your day!",
          style: TextStyle(
            fontSize: isWeb ? 20 : 18,
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
        fontSize: isWeb ? 18 : 16,
      ),
      outerColor: Colors.white,
      innerColor: Colors.green,
      key: checkInKey,
      onSubmit: () {
        setState(() {
          checkIn = DateFormat('hh:mm').format(DateTime.now());
          location = "Admin Location"; // Update as needed
        });
        checkInKey.currentState!.reset();
      },
    )
        : SlideAction(
      text: "Slide To Check Out",
      textStyle: TextStyle(
        color: Colors.black45,
        fontSize: isWeb ? 18 : 16,
      ),
      outerColor: Colors.white,
      innerColor: Colors.red,
      key: checkOutKey,
      onSubmit: () {
        setState(() {
          checkOut = DateFormat('hh:mm').format(DateTime.now());
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
        fontSize: isWeb ? 18 : 16,
      ),
    );
  }
}
