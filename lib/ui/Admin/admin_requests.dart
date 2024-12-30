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
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600; // Determine if it's web layout

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
                horizontal: isWeb ? 40 : 16, // Add padding for web
                vertical: 16,
              ),
              child: requests.isNotEmpty
                  ? ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return Card(
                    elevation: isWeb ? 6 : 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isWeb ? 20 : 18,
                              color: const Color(0xFF133E87),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Type: ${request["type"]}",
                            style: TextStyle(
                              fontSize: isWeb ? 18 : 16,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "Days: ${request["days"]}",
                            style: TextStyle(
                              fontSize: isWeb ? 18 : 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Message: ${request["message"]}",
                            style: TextStyle(
                              fontSize: isWeb ? 18 : 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  handleAction(index); // Remove card on accept
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF608BC1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "Accept",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  handleAction(index); // Remove card on deny
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "Deny",
                                  style: TextStyle(color: Colors.white),
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
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox,
                    size: isWeb ? 80 : 60,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No requests available.",
                    style: TextStyle(
                      fontSize: isWeb ? 20 : 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
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
