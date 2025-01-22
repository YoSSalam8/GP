import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class VacationRequestScreen extends StatefulWidget {
  final String companyId;
  final String employeeId;
  final String employeeEmail;
  const VacationRequestScreen({super.key, required this.companyId, required this.employeeId, required this.employeeEmail});

  @override
  State<VacationRequestScreen> createState() => _VacationRequestScreenState();
}

class _VacationRequestScreenState extends State<VacationRequestScreen> {
  TextEditingController messageController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  int selectedDays = 0;
  String? selectedAbsenceType;
  List<dynamic> leaveTypes = [];
  Map<String, int> remainingDaysMap = {};

  final List<String> absenceTypes = [
    "Sickness",
    "Holiday",
    "Paid Leave",
    "Unpaid Leave",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    _fetchCompanyLeaveTypes();
    _fetchEmployeeLeaveBalances();
  }

  void _submitVacationRequest() async {
    if (startDate == null || endDate == null || selectedAbsenceType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields before submitting.")),
      );
      return;
    }

    try {
      // Find the selected leave type ID
      final selectedLeaveType = leaveTypes.firstWhere(
            (type) => type['name'] == selectedAbsenceType,
        orElse: () => null,
      );

      if (selectedLeaveType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid leave type selected.")),
        );
        return;
      }

      final leaveTypeId = selectedLeaveType['id'];

      // Prepare the request payload
      final requestPayload = {
        "employeeId": int.parse(widget.employeeId),
        "employeeEmail": widget.employeeEmail,
        "leaveTypeId": leaveTypeId,
        "startDate": DateFormat('yyyy-MM-dd').format(startDate!),
        "endDate": DateFormat('yyyy-MM-dd').format(endDate!),
        "remarks": messageController.text.isNotEmpty ? messageController.text : "Vacation leave request."
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse("http://localhost:8080/api/leave-requests/submit"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestPayload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vacation request submitted successfully.")),
        );
        // Reset the form
        setState(() {
          startDate = null;
          endDate = null;
          selectedDays = 0;
          selectedAbsenceType = null;
          messageController.clear();
        });
      } else {
        _showError("Failed to submit vacation request: ${response.body}");
      }
    } catch (e) {
      _showError("An error occurred: $e");
    }
  }
  Future<void> _fetchCompanyLeaveTypes() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:8080/api/companies/${widget.companyId}"),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          leaveTypes = data['leaveTypes'];
        });
      } else {
        _showError("Failed to fetch company leave types.");
      }
    } catch (e) {
      _showError("An error occurred: $e");
    }
  }

  Future<void> _fetchEmployeeLeaveBalances() async {
    try {
      final response = await http.get(
        Uri.parse(
          "http://localhost:8080/api/leave-requests/employee/${widget.employeeId}/${widget.employeeEmail}/balances",
        ),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          remainingDaysMap = {
            for (var balance in data) balance['leaveTypeName']: balance['remainingDays']
          };
        });
      } else {
        _showError("Failed to fetch leave balances.");
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
    bool isWeb = screenWidth > 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade300, Colors.grey.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: isWeb ? screenWidth * 0.2 : 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Center(
                child: Text(
                  "Vacation Request",
                  style: TextStyle(
                    fontSize: isWeb ? 32 : 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF133E87),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildDateSelectionCard(isWeb),
              const SizedBox(height: 20),
              _buildAbsenceTypeDropdown(isWeb),
              const SizedBox(height: 20),
              _buildMessageCard(isWeb),
              const SizedBox(height: 20),
              _buildRequestSummaryCard(isWeb),
              const SizedBox(height: 30),
              Center(
                child: _buildSubmitButton(isWeb, screenWidth),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelectionCard(bool isWeb) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Vacation Dates:",
              style: TextStyle(
                fontSize: isWeb ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildDatePickerButton("Start Date", startDate, (date) {
                    setState(() {
                      startDate = date;
                      if (endDate != null && endDate!.isBefore(startDate!)) {
                        endDate = startDate;
                      }
                      _updateSelectedDays();
                    });
                  }),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDatePickerButton("End Date", endDate, (date) {
                    setState(() {
                      if (startDate == null || date.isBefore(startDate!)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("End date cannot be before start date.")),
                        );
                        return;
                      }
                      endDate = date;
                      _updateSelectedDays();
                    });
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbsenceTypeDropdown(bool isWeb) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Absence Type:",
              style: TextStyle(
                fontSize: isWeb ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedAbsenceType,
              hint: const Text("Select absence type"),
              isExpanded: true,
              items: leaveTypes.map((type) {
                String name = type['name'];
                int maxDays = type['maxDays'];
                int remainingDays = remainingDaysMap[name] ?? maxDays;
                return DropdownMenuItem<String>(
                  value: name,
                  child: Text(
                    "$name (${remainingDays} days remaining)",
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedAbsenceType = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerButton(String label, DateTime? date, Function(DateTime) onDateSelected) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF608BC1),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () async {
        DateTime? selected = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (selected != null) {
          onDateSelected(selected);
        }
      },
      child: Text(
        date != null ? DateFormat('dd MMM yyyy').format(date) : label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _updateSelectedDays() {
    if (startDate != null && endDate != null) {
      selectedDays = endDate!.difference(startDate!).inDays + 1;
    } else {
      selectedDays = 0;
    }
  }

  Widget _buildMessageCard(bool isWeb) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Message to Manager:",
              style: TextStyle(
                fontSize: isWeb ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: messageController,
              maxLines: isWeb ? 8 : 5,
              onChanged: (_) => setState(() {}), // To dynamically update the summary
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: "Enter your message...",
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestSummaryCard(bool isWeb) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Request Summary:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            _buildSummaryRow(Icons.calendar_today, "Total Days:", selectedDays > 0 ? "$selectedDays day(s)" : "--"),
            const SizedBox(height: 10),
            _buildSummaryRow(Icons.category, "Absence Type:", selectedAbsenceType ?? "Not selected"),
            const SizedBox(height: 10),
            _buildSummaryRow(
              Icons.message,
              "Message:",
              messageController.text.isNotEmpty ? messageController.text : "No message provided.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(bool isWeb, double screenWidth) {
    return SizedBox(
      width: isWeb ? screenWidth * 0.4 : double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF133E87),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () {
          if (startDate == null || endDate == null || selectedAbsenceType == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please fill all fields before submitting.")),
            );
            return;
          }
          _submitVacationRequest();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Vacation request submitted for $selectedDays day(s) as $selectedAbsenceType.\nMessage: ${messageController.text.isNotEmpty ? messageController.text : "No message"}",
              ),
            ),
          );
          messageController.clear();
          setState(() {
            startDate = null;
            endDate = null;
            selectedDays = 0;
            selectedAbsenceType = null;
          });
        },
        child: const Text(
          "Submit Request",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
