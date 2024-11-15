import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  final Color primaryColor = const Color(0xFF608BC1);
  final Color cardColor = const Color(0xFFE1D7B7);
  final Color accentColor = const Color(0xFF133E87);

  String _month = DateFormat('MMMM').format(DateTime.now());

  // Sample data for demonstration purposes
  final List<Map<String, dynamic>> sampleData = [
    {
      'date': DateTime(2024, DateTime.now().month, 5),
      'checkIn': '09:00 AM',
      'checkOut': '05:00 PM',
    },
    {
      'date': DateTime(2024, DateTime.now().month, 12),
      'checkIn': '09:15 AM',
      'checkOut': '05:10 PM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Attendance"),
          backgroundColor: const Color(0xFF608BC1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Attendance",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth / 18,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            _buildMonthPicker(),
            const SizedBox(height: 20),
            _buildAttendanceList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthPicker() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _month,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth / 18,
              color: primaryColor,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () async {
              final month = await showMonthYearPicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2022),
                lastDate: DateTime(2099),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: primaryColor,
                        secondary: accentColor,
                        onSecondary: Colors.white,
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (month != null) {
                setState(() {
                  _month = DateFormat('MMMM').format(month);
                });
              }
            },
            child: Text(
              "Pick a Month",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth / 18,
                color: primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceList() {
    final filteredData = sampleData
        .where((record) =>
    DateFormat('MMMM').format(record['date']) == _month)
        .toList();

    return SizedBox(
      height: screenHeight / 1.45,
      child: ListView.builder(
        itemCount: filteredData.length,
        itemBuilder: (context, index) {
          return _buildAttendanceCard(filteredData[index], index);
        },
      ),
    );
  }

  Widget _buildAttendanceCard(Map<String, dynamic> data, int index) {
    return Container(
      margin: EdgeInsets.only(top: index > 0 ? 12 : 0, left: 6, right: 6),
      height: 150,
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(2, 2),
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildDateColumn(data['date']),
          _buildInfoColumn("Check In", data['checkIn']),
          _buildInfoColumn("Check Out", data['checkOut']),
        ],
      ),
    );
  }

  Widget _buildDateColumn(DateTime date) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Text(
            DateFormat('EE\ndd').format(date),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth / 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: screenWidth / 20,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth / 18,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
