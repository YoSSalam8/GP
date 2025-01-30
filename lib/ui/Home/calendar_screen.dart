import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

    );
  }
}

class CalendarScreen extends StatefulWidget {
  final String employeeId;
  final String email;
  final String token; // Add token parameter


  const CalendarScreen({Key? key, required this.employeeId, required this.email,    required this.token, // Pass token here
  }) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  String _selectedDateRange = '';
  DateTime? _startDate;
  DateTime? _endDate;

  List<Map<String, dynamic>> attendanceData = [];
  bool isLoading = false;

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
      _fetchAttendanceData();
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
      _fetchAttendanceData();
    }
  }

  Future<void> _fetchAttendanceData() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
        "http://192.168.68.107:8080/api/attendance/employee/${widget.employeeId}/${widget.email}/attendance");

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.token}', // Add token here
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          attendanceData = data.map((record) {
            return {
              'checkInTime': record['checkInTime'] != null
                  ? DateTime.parse(record['checkInTime'])
                  : null,
              'checkOutTime': record['checkOutTime'] != null
                  ? DateTime.parse(record['checkOutTime'])
                  : null,
              'duration': record['duration'] ?? 0.0,
            };
          }).where((record) => record['checkInTime'] != null).toList();
        });
      } else {
        print("Error: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("Error fetching attendance data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }




  List<Map<String, dynamic>> _getFilteredData() {
    if (_startDate == null) return [];

    DateTime today = DateTime.now();

    return attendanceData.where((record) {
      final checkInTime = record['checkInTime'] as DateTime;
      final checkOutTime = record['checkOutTime'];

      // Exclude records from today with null checkOutTime
      if (isSameDate(checkInTime, today) && checkOutTime == null) {
        return false;
      }

      // Filter by date range
      if (_endDate == null) {
        return isSameDate(checkInTime, _startDate!);
      }

      return checkInTime.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
          checkInTime.isBefore(_endDate!.add(const Duration(days: 1)));
    }).toList();
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    bool isWeb = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(

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
            isLoading
                ? Center(child: CircularProgressIndicator())
                : _buildAttendanceList(isWeb),
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
        return _buildAttendanceCard(filteredData[index], isWeb);
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

  Widget _buildAttendanceCard(Map<String, dynamic> data, bool isWeb) {
    final DateTime? checkInTime = data['checkInTime'];
    final DateTime? checkOutTime = data['checkOutTime'];
    final double duration = data['duration'];

    String checkIn = checkInTime != null
        ? DateFormat('hh:mm a').format(checkInTime)
        : "N/A";
    String checkOut = checkOutTime != null
        ? DateFormat('hh:mm a').format(checkOutTime)
        : "N/A";
    String totalDuration = duration >= 0
        ? "${duration.toStringAsFixed(2)} hours"
        : "N/A";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
            DateFormat('EEEE, MMM dd, yyyy').format(checkInTime!),
            style: TextStyle(
              fontSize: isWeb ? 22 : screenWidth / 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoBox("Check In", checkIn, Icons.login, Colors.green, isWeb),
              _buildInfoBox("Check Out", checkOut, Icons.logout, Colors.red, isWeb),
              _buildInfoBox(
                  "Total Time", totalDuration, Icons.timer, Colors.blue, isWeb),
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
