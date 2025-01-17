import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminAbsenceVacationPage extends StatefulWidget {
  const AdminAbsenceVacationPage({super.key});

  @override
  _AdminAbsenceVacationPageState createState() =>
      _AdminAbsenceVacationPageState();
}

class _AdminAbsenceVacationPageState extends State<AdminAbsenceVacationPage> {
  final List<Map<String, String>> employeeStatus = [
    {"name": "Mohammad Aker", "status": "On Vacation"},
    {"name": "Yousef AbdulSalam", "status": "Absent"},
    {"name": "Khaled Yaish", "status": "Present"},
    {"name": "Yousef Hanbali", "status": "On Vacation"},
    {"name": "Amr Kurdi", "status": "Absent"},
  ];

  List<Map<String, String>> filteredEmployees = [];
  TextEditingController searchController = TextEditingController();

  final Color primaryColor = const Color(0xFF133E87);
  final Color accentColor = const Color(0xFF608BC1);
  final Color cardBackgroundColor = const Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();
    filteredEmployees = employeeStatus;
  }

  void filterSearchResults(String query) {
    List<Map<String, String>> results = [];
    if (query.isEmpty) {
      results = employeeStatus;
    } else {
      results = employeeStatus
          .where((employee) =>
          employee["name"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {
      filteredEmployees = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600; // Check if it's a web environment
    String formattedDate =
    DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.now());

    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade300, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 800 : double.infinity, // Constrain width for web
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Display
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: accentColor,
                      size: isWeb ? 24 : 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: isWeb ? 20 : 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Search Bar
                TextField(
                  controller: searchController,
                  onChanged: filterSearchResults,
                  decoration: InputDecoration(
                    hintText: "Search by name...",
                    hintStyle: TextStyle(
                      color: accentColor,
                      fontSize: isWeb ? 18 : 16,
                    ),
                    prefixIcon: Icon(Icons.search, color: accentColor),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: accentColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: accentColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: accentColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Employee List
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredEmployees.length,
                    itemBuilder: (context, index) {
                      return _buildEmployeeCard(
                        filteredEmployees[index],
                        isWeb,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(Map<String, String> employee, bool isWeb) {
    Color statusColor;
    String status = employee["status"]!;
    if (status == "Present") {
      statusColor = Colors.green;
    } else if (status == "On Vacation") {
      statusColor = Colors.blue;
    } else {
      statusColor = Colors.redAccent;
    }

    return Card(
      color: cardBackgroundColor,
      elevation: isWeb ? 6 : 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: statusColor,
              radius: isWeb ? 30 : 25,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: isWeb ? 36 : 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee["name"]!,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: isWeb ? 18 : 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Status: ${employee["status"]}",
                    style: TextStyle(
                      color: statusColor,
                      fontSize: isWeb ? 16 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
