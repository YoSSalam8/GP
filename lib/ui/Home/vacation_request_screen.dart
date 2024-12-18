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
    return Scaffold(
      body: SingleChildScrollView( // Wrap the body in a SingleChildScrollView to make it scrollable
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Number of Days:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            const Text(
              "Message to Manager:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: messageController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter your message...",
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
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
                          "Request sent for $selectedDays day(s): ${messageController.text}"),
                    ),
                  );
                  messageController.clear();
                },
                child: const Text(
                  "Submit Request",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
