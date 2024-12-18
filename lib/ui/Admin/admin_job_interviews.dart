import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminJobInterviewsPage extends StatefulWidget {
  const AdminJobInterviewsPage({super.key});

  @override
  _AdminJobInterviewsPageState createState() => _AdminJobInterviewsPageState();
}

class _AdminJobInterviewsPageState extends State<AdminJobInterviewsPage> {
  // Sample data for job interviews
  final List<Map<String, dynamic>> jobInterviews = [
    {
      "candidate": "Yousef AbdulSalam",
      "date": "2024-11-15",
      "time": "10:00 AM",
      "description": "Software Engineer Position",
      "completed": false,
    },
    {
      "candidate": "Mohammad Aker",
      "date": "2024-11-16",
      "time": "2:00 PM",
      "description": "Product Manager Position",
      "completed": false,
    },
    {
      "candidate": "Zaid Balout",
      "date": "2024-11-18",
      "time": "11:30 AM",
      "description": "UI/UX Designer Position",
      "completed": false,
    },
  ];

  final Color primaryColor = const Color(0xFF133E87);
  final Color accentColor = const Color(0xFF608BC1);
  final Color cardBackgroundColor = const Color(0xFFF5F5F5);

  void toggleCompletion(int index) {
    setState(() {
      jobInterviews[index]["completed"] = !jobInterviews[index]["completed"];
    });
  }

  void clearCompletedInterviews() {
    setState(() {
      jobInterviews.removeWhere((interview) => interview["completed"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,

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
          // Interviews List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: jobInterviews.length,
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
                        Checkbox(
                          value: jobInterviews[index]["completed"],
                          onChanged: (value) {
                            toggleCompletion(index);
                          },
                          activeColor: accentColor,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                jobInterviews[index]["candidate"],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: jobInterviews[index]["completed"]
                                      ? Colors.grey
                                      : primaryColor,
                                  decoration: jobInterviews[index]["completed"]
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Date: ${jobInterviews[index]["date"]}\n"
                                    "Time: ${jobInterviews[index]["time"]}\n"
                                    "Position: ${jobInterviews[index]["description"]}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: jobInterviews[index]["completed"]
                                      ? Colors.grey
                                      : Colors.black87,
                                  decoration: jobInterviews[index]["completed"]
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.event_available,
                          color: jobInterviews[index]["completed"]
                              ? Colors.grey
                              : accentColor,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Clear Completed Button
          if (jobInterviews.any((interview) => interview["completed"]))
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: clearCompletedInterviews,
                child: const Text(
                  "Clear Completed Interviews",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
