import 'package:flutter/material.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 600; // Web if width > 600 pixels

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.shade300, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isWeb ? 1000 : double.infinity),
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: isWeb ? 40 : 16, // Extra padding for web
                  ),
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.announcement_rounded,
                            color: Color(0xFF133E87),
                            size: 80,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Latest Announcements",
                            style: TextStyle(
                              fontSize: isWeb ? 32 : 24, // Larger font for web
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF133E87),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildAnnouncementCard(
                      title: "Office Maintenance",
                      date: "7 January 2025",
                      content: "The office will remain closed on Friday for maintenance purposes.",
                      isWeb: isWeb,
                    ),
                    const SizedBox(height: 20),
                    _buildAnnouncementCard(
                      title: "Team Meeting",
                      date: "6 January 2025",
                      content: "Join the all-hands meeting tomorrow at 10:00 AM in the main hall.",
                      isWeb: isWeb,
                    ),
                    const SizedBox(height: 20),
                    _buildAnnouncementCard(
                      title: "Holiday Announcement",
                      date: "1 January 2025",
                      content: "The company will observe a public holiday on 15 January 2025.",
                      isWeb: isWeb,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnnouncementCard({
    required String title,
    required String date,
    required String content,
    required bool isWeb,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(isWeb ? 24 : 16), // More padding for web
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.announcement_rounded,
                  color: isWeb ? Colors.blue.shade800 : Colors.blueAccent, // Slightly different color for web
                  size: isWeb ? 32 : 24, // Larger icon for web
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: isWeb ? 26 : 18, // Larger title font for web
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "📅 $date",
              style: TextStyle(
                fontSize: isWeb ? 20 : 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                fontSize: isWeb ? 20 : 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
