import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewProject extends StatefulWidget {
  final String companyId;
  final String employeeId;
  final String employeeEmail;
  final String token; // Add token parameter

  const ViewProject({
    super.key,
    required this.companyId,
    required this.employeeId,
    required this.employeeEmail,
    required this.token,
  });

  @override
  State<ViewProject> createState() => _ViewProjectState();
}

class _ViewProjectState extends State<ViewProject> {
  List<Map<String, dynamic>> projects = [];
  final TextEditingController hoursController = TextEditingController();
  bool isBillable = false;
  String employeeJobTitle = "";
  bool isLoading = false;
  bool isSubmitted = false;

  Future<void> fetchProjects() async {
    setState(() {
      isLoading = true; // Show loader while fetching data
    });

    final url = Uri.parse("http://localhost:8080/api/projects/company/${widget.companyId}");
    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          // Filter projects where the employee is assigned
          projects = data
              .where((project) => project["employeeIds"]
              .any((employee) => employee["id"].toString() == widget.employeeId))
              .cast<Map<String, dynamic>>()
              .toList();
        });
      } else {
        throw Exception("Failed to fetch projects.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching projects: $e")),
      );
    }
  }

  Future<void> fetchEmployeeJob(Map<String, dynamic> project) async {
    final url = Uri.parse("http://localhost:8080/api/project-jobs/project/${project["id"]}");
    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          final jobDetails = data.firstWhere(
                  (job) => job["employeeId"]["id"].toString() == widget.employeeId,
              orElse: () => null);

          if (jobDetails != null) {
            setState(() {
              employeeJobTitle = jobDetails["name"] ?? "No Job Title Assigned";
              project["jobId"] = jobDetails["id"]; // Assign job ID
            });
          } else {
            throw Exception("No job details found for the current employee.");
          }
        } else {
          throw Exception("Empty response received from the server.");
        }
      } else {
        throw Exception("Failed to fetch project job details. Status: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching employee job: $e")),
      );
    }
  }



  Future<void> submitWorkDetails(Map<String, dynamic> project) async {
    if (hoursController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in the hours worked before submitting!")),
      );
      return;
    }

    if (project["jobId"] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Job ID is missing. Unable to submit work details.")),
      );
      return;
    }

    try {
      final workDetails = {
        "projectId": project["id"],
        "employeeId": {"id": int.parse(widget.employeeId), "email": widget.employeeEmail},
        "jobId": project["jobId"],
        "hoursWorked": int.parse(hoursController.text),
        "date": DateTime.now().toIso8601String().split('T')[0],
        "isClientBillable": isBillable,
      };

      print("Submitting work details: ${jsonEncode(workDetails)}");

      final url = Uri.parse("http://localhost:8080/api/project-hours/assign");
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Content-Type": "application/json",
        },
        body: jsonEncode(workDetails),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Work details submitted successfully!")),
        );

        // Update the project card with the submitted hours
        setState(() {
          project["submittedHours"] = workDetails["hoursWorked"].toString(); // Update the project
          isSubmitted = true;
          hoursController.text = workDetails["hoursWorked"].toString();
        });

        Navigator.pop(context);
      } else {
        throw Exception(
            "Failed to submit work details. Status code: ${response.statusCode}, response: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting work details: $e")),
      );
    }
  }

  void showProjectDetailsModal(Map<String, dynamic> project) async {
    hoursController.clear();
    setState(() {
      isBillable = false;
    });

    await fetchEmployeeJob(project); // Ensure jobId is fetched before opening the modal

    if (project["jobId"] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to fetch job details. Please try again.")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFCBDCEB), Color(0xFF608BC1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Project Details",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF133E87),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Title: ${project["name"]}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Description: ${project["description"]}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Start Date: ${project["startDate"]}",
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "End Date: ${project["endDate"]}",
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Your Job: $employeeJobTitle",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Work Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF133E87),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: hoursController,
                        decoration: InputDecoration(
                          labelText: "Hours Worked",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.timer),
                        ),
                        keyboardType: TextInputType.number,
                        enabled: !isSubmitted, // Disable the field if already submitted
                      ),
                      const SizedBox(height: 20),
                      if (!isSubmitted)
                        SwitchListTile(
                          title: const Text(
                            "Is Billable?",
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          value: isBillable,
                          onChanged: (value) {
                            setStateModal(() {
                              isBillable = value;
                            });
                          },
                          activeColor: const Color(0xFF133E87),
                        ),
                      const SizedBox(height: 20),
                      if (!isSubmitted)
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF133E87),
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () => submitWorkDetails(project),
                            child: const Text(
                              "Submit Work Details",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }


  void _refreshData() {
    fetchProjects(); // Re-fetch projects when the refresh button is pressed
  }
  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "View Projects",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData, // Call the _refreshData method on press
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFCBDCEB), Color(0xFF608BC1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                title: Text(
                  project["name"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF133E87),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Start Date: ${project["startDate"]} | End Date: ${project["endDate"]}",
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    if (project["submittedHours"] != null)
                      Text(
                        "Hours Worked: ${project["submittedHours"]}",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF133E87)),
                onTap: () => showProjectDetailsModal(project),
              ),
            );
          },
        )

      ),
    );
  }
}
