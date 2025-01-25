import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AnnouncementsScreen extends StatefulWidget {
  final String companyId;
  final String token; // Add token parameter


  const AnnouncementsScreen({super.key, required this.companyId, required this.token});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  List<dynamic> announcements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  Future<void> _fetchAnnouncements() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse("http://localhost:8080/api/announcements/company/${widget.companyId}"),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          announcements = json.decode(response.body);
        });
      } else {
        _showError("Failed to fetch announcements: ${response.body}");
      }
    } catch (e) {
      _showError("An error occurred: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 600;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Announcements'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh Announcements',
                onPressed: _fetchAnnouncements, // Refresh announcements
              ),
            ],
          ),
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
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : announcements.isNotEmpty
                    ? ListView(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: isWeb ? 40 : 16,
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
                              fontSize: isWeb ? 32 : 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF133E87),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...announcements.map((announcement) {
                      return _buildAnnouncementCard(
                        title: announcement["title"],
                        content: announcement["text"],
                        postedBy: announcement["postedByName"],
                        postedByEmail: announcement["postedByEmail"],
                        isWeb: isWeb,
                      );
                    }).toList(),
                  ],
                )
                    : Center(
                  child: Text(
                    "No announcements available.",
                    style: TextStyle(
                      fontSize: isWeb ? 24 : 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
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
    required String content,
    required String postedBy,
    required String postedByEmail,
    required bool isWeb,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: EdgeInsets.all(isWeb ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.announcement_rounded,
                  color: isWeb ? Colors.blue.shade800 : Colors.blueAccent,
                  size: isWeb ? 32 : 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: isWeb ? 26 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Posted by: $postedBy ($postedByEmail)",
              style: TextStyle(
                fontSize: isWeb ? 18 : 14,
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
