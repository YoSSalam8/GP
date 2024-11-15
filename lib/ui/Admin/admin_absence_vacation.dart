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
    String formattedDate = DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Employee Absence & Vacation"),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          // Date Display
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: accentColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              onChanged: filterSearchResults,
              decoration: InputDecoration(
                hintText: "Search by name...",
                hintStyle: TextStyle(color: accentColor),
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
          ),
          // Employee List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredEmployees.length,
              itemBuilder: (context, index) {
                return Card(
                  color: cardBackgroundColor,
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                          filteredEmployees[index]["status"] == "Present"
                              ? Colors.green
                              : Colors.redAccent,
                          radius: 25,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                filteredEmployees[index]["name"]!,
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Status: ${filteredEmployees[index]["status"]}",
                                style: TextStyle(
                                  color: filteredEmployees[index]["status"] ==
                                      "Present"
                                      ? Colors.green
                                      : Colors.redAccent,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
