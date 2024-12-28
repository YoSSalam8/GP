import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Month Year Picker Example',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
      ],
      home: CalendarScreen(),
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

  String _month = DateFormat('MMMM yyyy').format(DateTime.now());

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
                color: accentColor,
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
              color: accentColor,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () async {
                final month = await showMonthYearPicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2099),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        dialogBackgroundColor: Colors.white,
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
                    _month = DateFormat('MMMM yyyy').format(month);
                  });
                }
              },
              child: Text(
                "Pick a Month",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth / 18,
                  color: accentColor,
                ),
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
    DateFormat('MMMM yyyy').format(record['date']) == _month)
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
              fontSize: screenWidth / 22,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoBox("Check In", checkIn, Icons.login, Colors.green),
              _buildInfoBox("Check Out", checkOut, Icons.logout, Colors.red),
              _buildInfoBox("Total Time", totalTimeWorked, Icons.timer, Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String label, String value, IconData icon, Color color) {
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
              size: screenWidth / 12,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: screenWidth / 30,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth / 28,
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
