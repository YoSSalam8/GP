import 'package:flutter/material.dart';

class CreateAnnouncementScreen extends StatelessWidget {
  const CreateAnnouncementScreen({super.key}); // Add const constructor

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 600; // Check if the screen width is greater than 600px
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
                  horizontal: horizontalPadding, // Adaptive padding for web and mobile
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isWeb ? 800 : double.infinity), // Limit width for web
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
                            fontSize: isWeb ? 32 : 24, // Larger font for web
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF133E87),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildTextField(
                        label: "Announcement Title",
                        hintText: "Enter the title...",
                        isWeb: isWeb,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
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
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Announcement shared successfully!"),
                backgroundColor: Colors.green,
              ),
            );
          },
          child: const Text(
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
