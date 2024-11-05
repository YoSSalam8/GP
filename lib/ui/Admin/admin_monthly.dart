import 'package:flutter/material.dart';

class AdminMonthlyAttendancePage extends StatefulWidget {
  const AdminMonthlyAttendancePage({super.key});

  @override
  State<AdminMonthlyAttendancePage> createState() => _AdminMonthlyAttendancePageState();
}

class _AdminMonthlyAttendancePageState extends State<AdminMonthlyAttendancePage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> attendanceRecords = [
    {'name': 'John Doe', 'date': '01 Oct 2024', 'checkIn': '09:00 AM', 'checkOut': '05:00 PM'},
    {'name': 'John Doe', 'date': '02 Oct 2024', 'checkIn': '09:15 AM', 'checkOut': '05:10 PM'},
  ];
  List<Map<String, dynamic>> filteredRecords = [];

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
      appBar: AppBar(
        title: const Text('Monthly Attendance Search'),
        backgroundColor: Colors.purple.shade500,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search employee...',
                prefixIcon: Icon(Icons.search, color: Colors.purple.shade500),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.purple.shade500),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.purple.shade500),
                ),
              ),
              onChanged: filterRecords,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredRecords.length,
                itemBuilder: (context, index) {
                  final record = filteredRecords[index];
                  return Card(
                    margin: const EdgeInsets.only(top: 8),
                    child: ListTile(
                      title: Text(record['name']),
                      subtitle: Text(
                          'Date: ${record['date']}\nCheck In: ${record['checkIn']} | Check Out: ${record['checkOut']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
