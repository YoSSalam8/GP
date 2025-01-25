import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateAnnouncementScreen extends StatefulWidget {
  final String employeeId;
  final String employeeEmail;
  final String companyId;
  final String token; // Add token parameter

  const CreateAnnouncementScreen({
    Key? key,
    required this.employeeId,
    required this.employeeEmail,
    required this.companyId,
    required this.token,
  }) : super(key: key);

  @override
  State<CreateAnnouncementScreen> createState() => _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool isLoading = false;

  Future<void> _shareAnnouncement() async {
    if (_titleController.text.isEmpty || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = "http://localhost:8080/api/announcements/create";
    final payload = {
      "employeeId": widget.employeeId,
      "employeeEmail": widget.employeeEmail,
      "companyId": widget.companyId,
      "title": _titleController.text,
      "text": _messageController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}', // Add Authorization header
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Announcement shared successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        _titleController.clear();
        _messageController.clear();
      } else {
        _showError("Failed to share announcement: ${response.body}");
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
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 600;
        double horizontalPadding = isWeb ? constraints.maxWidth * 0.2 : 16;

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
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: horizontalPadding,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isWeb ? 800 : double.infinity),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Icon(
                          Icons.campaign_rounded,
                          color: Color(0xFF133E87),
                          size: 80,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          "Create New Announcement",
                          style: TextStyle(
                            fontSize: isWeb ? 32 : 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF133E87),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildTextField(
                        controller: _titleController,
                        label: "Announcement Title",
                        hintText: "Enter the title...",
                        isWeb: isWeb,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _messageController,
                        label: "Announcement Message",
                        hintText: "Enter the announcement message...",
                        isWeb: isWeb,
                        maxLines: isWeb ? 10 : 5,
                      ),
                      const SizedBox(height: 30),
                      _buildShareButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    bool isWeb = false,
    int maxLines = 1,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isWeb ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              maxLines: maxLines,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: hintText,
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF133E87),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: isLoading ? null : _shareAnnouncement,
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
            "Share Announcement",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
