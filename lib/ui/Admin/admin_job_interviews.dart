import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminJobInterviewsPage extends StatefulWidget {
  const AdminJobInterviewsPage({super.key});

  @override
  _AdminJobInterviewsPageState createState() => _AdminJobInterviewsPageState();
}

class _AdminJobInterviewsPageState extends State<AdminJobInterviewsPage> {
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
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600; // Check for web layout
    String formattedDate =
    DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 800 : double.infinity, // Constrain width for web
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWeb ? 40 : 16,
                vertical: 16,
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
                  // Interviews List
                  Expanded(
                    child: ListView.builder(
                      itemCount: jobInterviews.length,
                      itemBuilder: (context, index) {
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        jobInterviews[index]["candidate"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: isWeb ? 18 : 16,
                                          color: jobInterviews[index]
                                          ["completed"]
                                              ? Colors.grey
                                              : primaryColor,
                                          decoration: jobInterviews[index]
                                          ["completed"]
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
                                          fontSize: isWeb ? 16 : 14,
                                          color: jobInterviews[index]
                                          ["completed"]
                                              ? Colors.grey
                                              : Colors.black87,
                                          decoration: jobInterviews[index]
                                          ["completed"]
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
                                  size: isWeb ? 30 : 24,
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
                      padding: const EdgeInsets.only(top: 16),
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
                        child: Text(
                          "Clear Completed Interviews",
                          style: TextStyle(
                            fontSize: isWeb ? 18 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
