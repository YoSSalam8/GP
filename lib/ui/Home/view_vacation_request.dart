import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VacationViewScreen extends StatefulWidget {
  final String employeeId;
  final String employeeEmail;

  const VacationViewScreen({
    Key? key,
    required this.employeeId,
    required this.employeeEmail,
  }) : super(key: key);

  @override
  State<VacationViewScreen> createState() => _VacationViewScreenState();
}

class _VacationViewScreenState extends State<VacationViewScreen> {
  List<dynamic> vacationRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVacationRequests();
  }

  Future<void> _fetchVacationRequests() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            "http://localhost:8080/api/leave-requests/employee/${widget.employeeId}/${widget.employeeEmail}"),
      );

      if (response.statusCode == 200) {
        setState(() {
          vacationRequests = json.decode(response.body);
          isLoading = false;
        });
      } else {
        _showError("Failed to fetch vacation requests: ${response.body}");
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600;
    double contentWidth = isWeb ? screenWidth * 0.7 : screenWidth * 0.9;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vacation Requests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Requests',
            onPressed: _fetchVacationRequests, // Refresh the vacation requests
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
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentWidth),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : vacationRequests.isNotEmpty
                ? ListView.builder(
              itemCount: vacationRequests.length,
              itemBuilder: (context, index) {
                final request = vacationRequests[index];
                return _buildVacationCard(request, isWeb);
              },
            )
                : _buildNoRequestsWidget(),
          ),
        ),
      ),
    );
  }

  Widget _buildVacationCard(Map<String, dynamic> request, bool isWeb) {
    Color statusColor;
    IconData statusIcon;

    switch (request["status"]) {
      case "Approved":
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
                _buildDetailRow(Icons.category, "Absence Type:", request["leaveTypeName"]),
                const SizedBox(width: 20),
                _buildDetailRow(Icons.calendar_today, "Days:", "${request["duration"]} days"),
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
            request["remarks"]?.isNotEmpty == true ? request["remarks"] : "No message provided.",
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildNoRequestsWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.inbox,
          size: 80,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 16),
        const Text(
          "No vacation requests available.",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
