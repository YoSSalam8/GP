import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Import for localizations
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        MonthYearPickerLocalizations.delegate, // Add this for month year picker localizations
      ],
      supportedLocales: const [
        Locale('en', 'US'), // Add other supported locales if needed
      ],
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

  Color primary = Colors.purple.shade500;

  String _month = DateFormat('MMMM').format(DateTime.now());

  // Sample data for demonstration purposes
  List<Map<String, dynamic>> sampleData = [
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
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                "My Attendance",
                style: TextStyle(
                  fontFamily: "NexaBold",
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 32),
                  child: Text(
                    _month,
                    style: TextStyle(
                      fontFamily: "NexaBold",
                      fontSize: screenWidth / 18,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(top: 32),
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
                                primary: primary,
                                secondary: primary,
                                onSecondary: Colors.white,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: primary,
                                ),
                              ),
                              textTheme: const TextTheme(
                                headlineMedium: TextStyle(
                                  fontFamily: "NexaBold",
                                ),
                                labelSmall: TextStyle(
                                  fontFamily: "NexaBold",
                                ),
                                labelLarge: TextStyle(
                                  fontFamily: "NexaBold",
                                ),
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
                        fontFamily: "NexaBold",
                        fontSize: screenWidth / 18,
                        color: primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight / 1.45,
              child: ListView.builder(
                itemCount: sampleData.length,
                itemBuilder: (context, index) {
                  return DateFormat('MMMM').format(sampleData[index]['date']) == _month
                      ? Container(
                    margin: EdgeInsets.only(top: index > 0 ? 12 : 0, left: 6, right: 6),
                    height: 150,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(2, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Center(
                              child: Text(
                                DateFormat('EE\ndd').format(sampleData[index]['date']),
                                style: TextStyle(
                                  fontFamily: "NexaBold",
                                  fontSize: screenWidth / 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Check In",
                                style: TextStyle(
                                  fontFamily: "NexaRegular",
                                  fontSize: screenWidth / 20,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                sampleData[index]['checkIn'],
                                style: TextStyle(
                                  fontFamily: "NexaBold",
                                  fontSize: screenWidth / 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Check Out",
                                style: TextStyle(
                                  fontFamily: "NexaRegular",
                                  fontSize: screenWidth / 20,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                sampleData[index]['checkOut'],
                                style: TextStyle(
                                  fontFamily: "NexaBold",
                                  fontSize: screenWidth / 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                      : const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
