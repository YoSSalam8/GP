import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VacationRequestScreen extends StatefulWidget {
  const VacationRequestScreen({super.key});

  @override
  State<VacationRequestScreen> createState() => _VacationRequestScreenState();
}

class _VacationRequestScreenState extends State<VacationRequestScreen> {
  TextEditingController messageController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  int selectedDays = 0;
  String? selectedAbsenceType;

  final List<String> absenceTypes = [
    "Sickness",
    "Holiday",
    "Paid Leave",
    "Unpaid Leave",
    "Other",
  ];

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
              items: absenceTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
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
