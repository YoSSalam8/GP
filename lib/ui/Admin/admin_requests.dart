import 'package:flutter/material.dart';

class AdminRequestsPage extends StatefulWidget {
  const AdminRequestsPage({super.key});

  @override
  State<AdminRequestsPage> createState() => _AdminRequestsPageState();
}

class _AdminRequestsPageState extends State<AdminRequestsPage> {
  final List<Map<String, dynamic>> requests = [
    {
      "employee": "Mohammad Aker",
      "type": "Vacation",
      "message": "Requesting a vacation for 3 days.",
      "days": 3
    },
    {
      "employee": "Yousef AbdulSalam",
      "type": "Sick Leave",
      "message": "Feeling unwell, requesting 2 days off.",
      "days": 2
    },
  ];

  void handleAction(int index) {
    setState(() {
      requests.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Requests"),
        backgroundColor: const Color(0xFF133E87),
      ),
      body: requests.isNotEmpty
          ? ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return Card(
            margin: const EdgeInsets.all(12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Employee: ${request["employee"]}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "Type: ${request["type"]}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Days: ${request["days"]}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Message: ${request["message"]}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          handleAction(index); // Remove the card on accept
                        },
                        child: const Text(
                          "Accept",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          handleAction(index); // Remove the card on deny
                        },
                        child: const Text(
                          "Deny",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      )
          : const Center(
        child: Text(
          "No requests available.",
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ),
    );
  }
}
