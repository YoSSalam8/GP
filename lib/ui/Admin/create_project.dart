import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';


class CreateProject extends StatefulWidget {
  final String companyId;
  final String employeeId;
  final String employeeEmail;
  final String token; // Add token parameter

  const CreateProject({
    super.key,
    required this.companyId,
    required this.token, required this.employeeId, required this.employeeEmail,
  });

  @override
  State<CreateProject> createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  final TextEditingController projectTitleController = TextEditingController();
  final TextEditingController projectDescriptionController = TextEditingController();
  final TextEditingController clientNameController = TextEditingController();
  final List<Map<String, dynamic>> positions = [];
  DateTime? startDate;
  DateTime? endDate;
  List<Map<String, dynamic>> employees = [];

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    final url = Uri.parse("http://localhost:8080/api/employees/company/${widget.companyId}/employees");
    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          employees = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        throw Exception("Failed to fetch employees. Status code: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching employees: $e")),
      );
    }
  }

  Future<void> submitProject() async {
    if (projectTitleController.text.isEmpty ||
        projectDescriptionController.text.isEmpty ||
        clientNameController.text.isEmpty ||
        startDate == null ||
        endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields must be filled before submitting!")),
      );
      return;
    }

    if (endDate!.isBefore(startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("End date cannot be before start date!")),
      );
      return;
    }

    try {
      // 1st POST request to create the project
      final projectData = {
        "name": projectTitleController.text,
        "description": projectDescriptionController.text,
        "clientName": clientNameController.text,
        "startDate": DateFormat('yyyy-MM-dd').format(startDate!),
        "endDate": DateFormat('yyyy-MM-dd').format(endDate!),
        "companyId": int.tryParse(widget.companyId),
        "creatorId": {"id": int.tryParse(widget.employeeId), "email": widget.employeeEmail},
        "employeeIds": employees.map((e) => {"id": e["id"], "email": e["email"]}).toList(),
      };

      print("Project Data Payload: ${jsonEncode(projectData)}");

      final projectResponse = await http.post(
        Uri.parse("http://localhost:8080/api/projects/create"),
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Content-Type": "application/json",
        },
        body: jsonEncode(projectData),
      );

      print("Response Status: ${projectResponse.statusCode}");
      print("Response Body: ${projectResponse.body}");

      final projectResponseBody = json.decode(projectResponse.body);

      if (projectResponse.statusCode == 201 ||
          (projectResponse.statusCode == 200 && projectResponseBody["id"] != null)) {
        final int projectId = projectResponseBody["id"];
        print("Project created with ID: $projectId");

        // Delay before sending job creation requests
        await Future.delayed(const Duration(seconds: 2));

        for (var position in positions) {
          if (position["employees"].isEmpty) continue;

          for (var employee in position["employees"]) {
            final jobData = {
              "projectId": projectId,
              "name": position["positionName"],
              "description": position["jobDescription"],
              "employeeId": {"id": employee["id"], "email": employee["email"]},
            };

            print("Sending Job Data: ${jsonEncode(jobData)}");

            final jobResponse = await http.post(
              Uri.parse("http://localhost:8080/api/project-jobs/create"),
              headers: {
                "Authorization": "Bearer ${widget.token}",
                "Content-Type": "application/json",
              },
              body: jsonEncode(jobData),
            );

            if (jobResponse.statusCode == 201) {
              print("Job created for employee: ${employee["id"]}");
            } else {
              print("Failed to create job. Status Code: ${jobResponse.statusCode}");
              print("Response: ${jobResponse.body}");
            }
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Project created successfully!")),
        );
        
      } else {
        print("Failed to create project. Status Code: ${projectResponse.statusCode}");
        print("Response: ${projectResponse.body}");
        throw Exception("Failed to create project.");
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting project: $e")),
      );
    }
  }

  void addPosition() {
    setState(() {
      positions.add({
        "positionName": "",
        "jobDescription": "",
        "employees": [],
      });
    });
  }

  void addEmployee(int positionIndex, Map<String, dynamic> employee) {
    setState(() {
      positions[positionIndex]["employees"].add(employee);
    });
  }

  void removePosition(int index) {
    setState(() {
      positions.removeAt(index);
    });
  }

  void removeEmployee(int positionIndex, int employeeIndex) {
    setState(() {
      positions[positionIndex]["employees"].removeAt(employeeIndex);
    });
  }


  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime initialDate = isStartDate ? (startDate ?? DateTime.now()) : (endDate ?? DateTime.now());
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = pickedDate;
          if (endDate != null && endDate!.isBefore(startDate!)) {
            endDate = startDate;
          }
        } else {
          endDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Project",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF133E87),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFCBDCEB), Color(0xFF608BC1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWeb ? screenWidth * 0.2 : 16,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
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
                        const SizedBox(height: 20),
                        TextField(
                          controller: projectTitleController,
                          decoration: InputDecoration(
                            labelText: "Project Title",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.title),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: projectDescriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: "Project Description",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.description),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: clientNameController,
                          decoration: InputDecoration(
                            labelText: "Client Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF133E87),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                icon: const Icon(Icons.calendar_today),
                                label: Text(
                                  startDate != null
                                      ? "Start Date: ${DateFormat('dd/MM/yyyy').format(startDate!)}"
                                      : "Select Start Date",
                                ),
                                onPressed: () => _selectDate(context, true),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF133E87),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                icon: const Icon(Icons.calendar_today_outlined),
                                label: Text(
                                  endDate != null
                                      ? "End Date: ${DateFormat('dd/MM/yyyy').format(endDate!)}"
                                      : "Select End Date",
                                ),
                                onPressed: () => _selectDate(context, false),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Project Positions",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF133E87),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF133E87),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: addPosition,
                      child: const Text("Add Position"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...positions.asMap().entries.map((entry) {
                  int positionIndex = entry.key;
                  Map<String, dynamic> position = entry.value;

                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.only(bottom: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Position Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(Icons.work),
                            ),
                            onChanged: (value) => positions[positionIndex]["positionName"] = value,
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            maxLines: 2,
                            decoration: InputDecoration(
                              labelText: "Job Description",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(Icons.description),
                            ),
                            onChanged: (value) => positions[positionIndex]["jobDescription"] = value,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Employees for this position",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF133E87),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () async {
                                  final selectedEmployee = await showDialog<Map<String, dynamic>>(
                                    context: context,
                                    builder: (_) {
                                      return EmployeeSelectorDialog(employees: employees);
                                    },
                                  );
                                  if (selectedEmployee != null) {
                                    addEmployee(positionIndex, selectedEmployee);
                                  }
                                },
                                child: const Text("Add Employee"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...positions[positionIndex]["employees"].asMap().entries.map((empEntry) {
                            int employeeIndex = empEntry.key;
                            Map<String, dynamic> employee = empEntry.value;

                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                leading: const Icon(Icons.person),
                                title: Text(employee["name"]),
                                subtitle: Text(employee["email"]),
                                trailing: IconButton(
                                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                                  onPressed: () => removeEmployee(positionIndex, employeeIndex),
                                ),
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () => removePosition(positionIndex),
                            child: const Text("Remove Position"),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF133E87),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: submitProject,
                    child: const Text(
                      "Create Project",
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
        ],
      ),
    );
  }
}

class EmployeeSelectorDialog extends StatefulWidget {
  final List<Map<String, dynamic>> employees;

  const EmployeeSelectorDialog({Key? key, required this.employees}) : super(key: key);

  @override
  State<EmployeeSelectorDialog> createState() => _EmployeeSelectorDialogState();
}

class _EmployeeSelectorDialogState extends State<EmployeeSelectorDialog> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredEmployees = widget.employees.where((employee) {
      final name = employee["name"]?.toLowerCase() ?? "";
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    final double dialogWidth = MediaQuery.of(context).size.width * 0.8;
    final double dialogHeight = MediaQuery.of(context).size.height * 0.7;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [Color(0xFFCBDCEB), Color(0xFF608BC1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select an Employee",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Search by name...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF133E87)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListView.builder(
                  itemCount: filteredEmployees.length,
                  itemBuilder: (context, index) {
                    final employee = filteredEmployees[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF133E87),
                        child: Text(
                          employee["name"]?[0]?.toUpperCase() ?? "?",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        employee["name"],
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      subtitle: Text(employee["email"]),
                      trailing: const Icon(Icons.person_add, color: Color(0xFF133E87)),
                      onTap: () {
                        Navigator.pop(context, employee);
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

