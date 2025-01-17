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

  void handleAction(int index, String action) {
    setState(() {
      requests.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Request ${action.toLowerCase()}ed successfully!"),
        backgroundColor: action == "Accept" ? Colors.green : Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600; // Determine if it's a web layout
    double contentWidth = isWeb ? screenWidth * 0.7 : screenWidth * 0.9;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade200, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentWidth),
            child: requests.isNotEmpty
                ? ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return _buildRequestCard(request, index, isWeb);
              },
            )
                : _buildNoRequestsWidget(isWeb),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request, int index, bool isWeb) {
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
            _buildDetailRow(Icons.person, "Employee", request["employee"]),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.category, "Type", request["type"]),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.calendar_today, "Days", "${request["days"]} days"),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.message, "Message", request["message"]),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionButton(
                  "Accept",
                  Colors.green,
                      () => handleAction(index, "Accept"),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  "Deny",
                  Colors.redAccent,
                      () => handleAction(index, "Deny"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF608BC1)),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: Text(
            "$label:",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildNoRequestsWidget(bool isWeb) {
    return Column(
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
    );
  }
}
