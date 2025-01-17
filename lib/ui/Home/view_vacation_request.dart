import 'package:flutter/material.dart';

class VacationViewScreen extends StatelessWidget {
  const VacationViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600;
    double contentWidth = isWeb ? screenWidth * 0.7 : screenWidth * 0.9;

    // Sample vacation request data
    final List<Map<String, dynamic>> vacationRequests = [
      {
        "id": "1",
        "startDate": "2024-02-01",
        "endDate": "2024-02-05",
        "days": 5,
        "absenceType": "Holiday",
        "status": "Accepted",
        "supervisorMessage": "Enjoy your time off!"
      },
      {
        "id": "2",
        "startDate": "2024-03-10",
        "endDate": "2024-03-15",
        "days": 6,
        "absenceType": "Unpaid Leave",
        "status": "Rejected",
        "supervisorMessage": "Unfortunately, we cannot approve this request due to workload."
      },
      {
        "id": "3",
        "startDate": "2024-04-01",
        "endDate": "2024-04-02",
        "days": 2,
        "absenceType": "Sickness",
        "status": "Pending",
        "supervisorMessage": null
      },
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade300, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentWidth),
            child: ListView.builder(
              itemCount: vacationRequests.length,
              itemBuilder: (context, index) {
                final request = vacationRequests[index];
                return _buildVacationCard(request, isWeb);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVacationCard(Map<String, dynamic> request, bool isWeb) {
    Color statusColor;
    IconData statusIcon;

    switch (request["status"]) {
      case "Accepted":
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case "Rejected":
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
    }

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vacation Date Range
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${request["startDate"]} - ${request["endDate"]}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF133E87),
                  ),
                ),
                Chip(
                  label: Text(
                    request["status"],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: statusColor,
                  avatar: Icon(statusIcon, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Vacation Type and Days
            Row(
              children: [
                _buildDetailRow(Icons.category, "Absence Type:", request["absenceType"]),
                const SizedBox(width: 20),
                _buildDetailRow(Icons.calendar_today, "Days:", "${request["days"]} days"),
              ],
            ),
            const SizedBox(height: 10),
            // Supervisor Message
            _buildSupervisorMessage(request, isWeb),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueAccent),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              "$label $value",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupervisorMessage(Map<String, dynamic> request, bool isWeb) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Supervisor's Message:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isWeb ? 16 : 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            request["supervisorMessage"] ?? "No message provided.",
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
