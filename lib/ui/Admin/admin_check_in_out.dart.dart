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

    return Scaffold(
      backgroundColor: Colors.white, // Match the theme

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreeting(),
            const SizedBox(height: 32),
            _buildStatusCard(),
            const SizedBox(height: 20),
            _buildCurrentTimeAndDate(),
            const SizedBox(height: 24),
            _buildSlideAction(),
            const SizedBox(height: 32),
            if (location != " ") _buildLocation(),
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
          "Welcome, Admin",
          style: TextStyle(
            color: Colors.black87,
            fontSize: screenWidth / 18,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
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
          _buildStatusColumn("Check In", checkIn),
          _buildStatusColumn("Check Out", checkOut),
        ],
      ),
    );
  }

  Widget _buildStatusColumn(String label, String time) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black),
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth / 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTimeAndDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder(
          stream: Stream.periodic(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            return Text(
              DateFormat('hh:mm:ss a').format(DateTime.now()),
              style: TextStyle(
                fontSize: screenWidth / 20,
                color: Colors.black,
              ),
            );
          },
        ),
        Text(
          DateFormat('dd MMMM yyyy').format(DateTime.now()),
          style: TextStyle(
            fontSize: screenWidth / 20,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildSlideAction() {
    final GlobalKey<SlideActionState> checkInKey = GlobalKey<SlideActionState>();
    final GlobalKey<SlideActionState> checkOutKey = GlobalKey<SlideActionState>();

    if (checkOut != "--/--") {
      return Center(
        child: Text(
          "You have completed your day!",
          style: TextStyle(
            fontSize: screenWidth / 20,
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
        fontSize: screenWidth / 20,
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
        fontSize: screenWidth / 20,
      ),
      outerColor: Colors.white,
      innerColor: Colors.red,
      key: checkOutKey,
      onSubmit: () {
        setState(() {
          checkOut = DateFormat('hh:mm').format(DateTime.now());
          // Log the check-in and check-out data as needed
        });
        checkOutKey.currentState!.reset();
      },
    );
  }

  Widget _buildLocation() {
    return Text(
      "Location: $location",
      style: TextStyle(
        color: Colors.black54,
        fontSize: screenWidth / 22,
      ),
    );
  }
}
