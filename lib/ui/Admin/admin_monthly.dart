import 'package:flutter/material.dart';

class AdminMonthlyAttendancePage extends StatefulWidget {
  const AdminMonthlyAttendancePage({super.key});

  @override
  State<AdminMonthlyAttendancePage> createState() =>
      _AdminMonthlyAttendancePageState();
}

class _AdminMonthlyAttendancePageState
    extends State<AdminMonthlyAttendancePage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> attendanceRecords = [
    {
      'name': 'Yousef AbdulSalam',
      'date': '01 Oct 2024',
      'checkIn': '09:00 AM',
      'checkOut': '05:00 PM'
    },
    {
      'name': 'Mohammad Aker',
      'date': '02 Oct 2024',
      'checkIn': '09:15 AM',
      'checkOut': '05:10 PM'
    },
  ];
  List<Map<String, dynamic>> filteredRecords = [];

  final Color primaryColor = const Color(0xFF133E87);
  final Color accentColor = const Color(0xFF608BC1);
  final Color cardBackgroundColor = const Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();
    filteredRecords = attendanceRecords;
  }

  void filterRecords(String query) {
    setState(() {
      filteredRecords = attendanceRecords
          .where((record) =>
          record['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Monthly Attendance Search'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search employee...',
                hintStyle: TextStyle(color: accentColor),
                prefixIcon: Icon(Icons.search, color: accentColor),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: accentColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor),
                ),
              ),
              onChanged: filterRecords,
            ),
            const SizedBox(height: 16),
            // Attendance records
            Expanded(
              child: filteredRecords.isNotEmpty
                  ? ListView.builder(
                itemCount: filteredRecords.length,
                itemBuilder: (context, index) {
                  final record = filteredRecords[index];
                  return Card(
                    color: cardBackgroundColor,
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record['name'],
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Date: ${record['date']}',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Check In: ${record['checkIn']} | Check Out: ${record['checkOut']}',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
                  : Center(
                child: Text(
                  "No records found.",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
