import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminRequestsPage extends StatefulWidget {
  final String companyId;
  final String approverId;
  final String approverEmail;
  const AdminRequestsPage({
    super.key,
    required this.companyId,
    required this.approverId,
    required this.approverEmail,
  });

  @override
  State<AdminRequestsPage> createState() => _AdminRequestsPageState();
}

class _AdminRequestsPageState extends State<AdminRequestsPage> {
  List<dynamic> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLeaveRequests();
  }

  Future<void> _fetchLeaveRequests() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:8080/api/leave-requests/company/${widget.companyId}"),
      );

      if (response.statusCode == 200) {
        setState(() {
          // Filter requests with a "Pending" status
          requests = json
              .decode(response.body)
              .where((request) => request["status"] == "Pending")
              .toList();
          isLoading = false;
        });
      } else {
        _showError("Failed to fetch leave requests: ${response.body}");
      }
    } catch (e) {
      _showError("An error occurred: $e");
    }
  }

  Future<void> _handleApproval(int index, int requestId) async {
    final url = "http://localhost:8080/api/leave-requests/$requestId/approve";
    final payload = {
      "approverId": int.parse(widget.approverId),
      "approverEmail": widget.approverEmail,
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Request approved successfully!")),
        );
        setState(() {
          requests.removeAt(index); // Remove the request card
        });
      } else {
        _showError("Failed to approve request: ${response.body}");
      }
    } catch (e) {
      _showError("An error occurred: $e");
    }
  }

  Future<void> _handleRejection(int index, int requestId) async {
    final url = "http://localhost:8080/api/leave-requests/$requestId/reject";
    final payload = {
      "remarks": "Leave denied due to project deadlines.",
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Request denied successfully!")),
        );
        setState(() {
          requests.removeAt(index); // Remove the request card
        });
      } else {
        _showError("Failed to reject request: ${response.body}");
      }
    } catch (e) {
      _showError("An error occurred: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : requests.isNotEmpty
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
            _buildDetailRow(Icons.person, "Employee", request["employeeName"]),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.email, "Email", request["employeeEmail"]),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.category, "Type", request["leaveTypeName"]),
            const SizedBox(height: 8),
            _buildDetailRow(
                Icons.calendar_today, "Start Date", request["startDate"]),
            const SizedBox(height: 8),
            _buildDetailRow(
                Icons.calendar_today_outlined, "End Date", request["endDate"]),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.message, "Remarks", request["remarks"]),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionButton(
                  "Accept",
                  Colors.green,
                      () => _handleApproval(index, request["id"]),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  "Deny",
                  Colors.redAccent,
                      () => _handleRejection(index, request["id"]),
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
