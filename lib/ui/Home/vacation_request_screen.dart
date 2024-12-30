import 'package:flutter/material.dart';

class VacationRequestScreen extends StatefulWidget {
  const VacationRequestScreen({super.key});

  @override
  State<VacationRequestScreen> createState() => _VacationRequestScreenState();
}

class _VacationRequestScreenState extends State<VacationRequestScreen> {
  TextEditingController messageController = TextEditingController();
  int selectedDays = 1;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Determine if the device is web
    bool isWeb = screenWidth > 600;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: isWeb ? screenWidth * 0.2 : 16, // Adjust margins for web
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Number of Days:",
              style: TextStyle(
                fontSize: isWeb ? 20 : 18, // Larger font for web
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<int>(
              isExpanded: true,
              value: selectedDays,
              items: List.generate(
                30,
                    (index) => DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text("${index + 1} day(s)"),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  selectedDays = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Message to Manager:",
              style: TextStyle(
                fontSize: isWeb ? 20 : 18, // Larger font for web
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: messageController,
              maxLines: isWeb ? 8 : 5, // Increase lines for web
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter your message...",
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: isWeb ? screenWidth * 0.4 : double.infinity, // Constrain button width on web
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF133E87),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    // Handle request submission
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Request sent for $selectedDays day(s): ${messageController.text}",
                        ),
                      ),
                    );
                    messageController.clear();
                  },
                  child: const Text(
                    "Submit Request",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
