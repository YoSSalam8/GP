import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enhanced Calendar Screen',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  final Color primaryColor = const Color(0xFF008080);
  final Color cardColor = Colors.white;
  final Color accentColor = const Color(0xFF004D40);

  String _selectedDateRange = '';
  DateTime? _startDate;
  DateTime? _endDate;

  final List<Map<String, dynamic>> sampleData = [
    {
      'date': DateTime(2025, 1, 2),
      'checkIn': '08:45 AM',
      'checkOut': '04:30 PM',
    },
    {
      'date': DateTime(2025, DateTime.now().month, 5),
      'checkIn': '09:00 AM',
      'checkOut': '05:00 PM',
    },
    {
      'date': DateTime(2025, DateTime.now().month, 12),
      'checkIn': '09:15 AM',
      'checkOut': '05:10 PM',
    },
  ];

  void _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _startDate = pickedDate;
        _endDate = null;
        _selectedDateRange = DateFormat('dd MMM yyyy').format(_startDate!);
      });
    }
  }

  void _showDateRangePicker() async {
    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedRange != null) {
      setState(() {
        _startDate = pickedRange.start;
        _endDate = pickedRange.end;
        _selectedDateRange =
        "${DateFormat('dd MMM yyyy').format(_startDate!)} - ${DateFormat('dd MMM yyyy').format(_endDate!)}";
      });
    }
  }

  List<Map<String, dynamic>> _getFilteredData() {
    if (_startDate == null) return [];

    return sampleData.where((record) {
      final date = record['date'] as DateTime;
      if (_endDate == null) {
        return date.year == _startDate!.year && date.month == _startDate!.month && date.day == _startDate!.day;
      }
      return date.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
          date.isBefore(_endDate!.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    bool isWeb = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _showDatePicker,
          ),
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _showDateRangePicker,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: isWeb ? screenWidth * 0.2 : 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Attendance Records",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isWeb ? 32 : screenWidth / 18,
                color: accentColor,
              ),
            ),
            if (_selectedDateRange.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                "Selected: $_selectedDateRange",
                style: TextStyle(
                  fontSize: isWeb ? 20 : screenWidth / 22,
                  color: Colors.grey[700],
                ),
              ),
            ],
            const SizedBox(height: 20),
            _buildAttendanceList(isWeb),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceList(bool isWeb) {
    final filteredData = _getFilteredData();

    return filteredData.isNotEmpty
        ? ListView.builder(
      shrinkWrap: true,
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        return _buildAttendanceCard(filteredData[index], index, isWeb);
      },
    )
        : Center(
      child: Text(
        "No attendance records found.",
        style: TextStyle(
          fontSize: isWeb ? 24 : screenWidth / 22,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(Map<String, dynamic> data, int index, bool isWeb) {
    final String checkIn = data['checkIn'].replaceAll(' ', '').trim();
    final String checkOut = data['checkOut'].replaceAll(' ', '').trim();

    String totalTimeWorked;

    try {
      final DateTime checkInTime = DateFormat.jm().parse(checkIn);
      final DateTime checkOutTime = DateFormat.jm().parse(checkOut);
      final Duration workedDuration = checkOutTime.difference(checkInTime);
      totalTimeWorked =
      "${workedDuration.inHours}h ${workedDuration.inMinutes.remainder(60)}m";
    } catch (e) {
      totalTimeWorked = "Invalid Time";
    }

    return Container(
      margin: EdgeInsets.only(top: index > 0 ? 12 : 0, left: 6, right: 6),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('EEEE, MMM dd, yyyy').format(data['date']),
            style: TextStyle(
              fontSize: isWeb ? 22 : screenWidth / 22,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoBox("Check In", checkIn, Icons.login, Colors.green, isWeb),
              _buildInfoBox("Check Out", checkOut, Icons.logout, Colors.red, isWeb),
              _buildInfoBox(
                  "Total Time", totalTimeWorked, Icons.timer, Colors.blue, isWeb),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(
      String label, String value, IconData icon, Color color, bool isWeb) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: isWeb ? 36 : screenWidth / 12,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: isWeb ? 16 : screenWidth / 30,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isWeb ? 14 : screenWidth / 28,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
