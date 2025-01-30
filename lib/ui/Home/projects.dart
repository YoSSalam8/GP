import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProjectsPage extends StatefulWidget {
  final String companyId;
  final String token;

  const ProjectsPage({super.key, required this.companyId, required this.token});

  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  List<Map<String, dynamic>> projects = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    setState(() {
      isLoading = true;
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
        setState(() {
          projects = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        throw Exception("Failed to fetch projects. Status: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching projects: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showProjectDetails(Map<String, dynamic> project) async {
    final projectId = project["id"];
    final List<Map<String, dynamic>> employees = List<Map<String, dynamic>>.from(project["employeeIds"]);

    for (var employee in employees) {
      final String employeeId = employee["id"].toString();
      final String email = employee["email"];

      // Fetch Job Details for the Employee
      final jobResponse = await http.get(
        Uri.parse("http://localhost:8080/api/project-jobs/project/$projectId"),
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Content-Type": "application/json",
        },
      );

      final List<dynamic> jobData = json.decode(jobResponse.body);
      var employeeJob = jobData.firstWhere(
              (job) => job["employeeId"]["id"].toString() == employeeId,
          orElse: () => null);

      // Fetch Work Hours for the Employee
      final workHoursResponse = await http.get(
        Uri.parse("http://localhost:8080/api/project-hours/employee/$employeeId/project/$projectId"),
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Content-Type": "application/json",
        },
      );

      final List<dynamic> workHoursData = json.decode(workHoursResponse.body);
      double totalHours = workHoursData.fold(0.0, (sum, entry) => sum + (entry["hoursWorked"] ?? 0.0));

      employee["job"] = employeeJob != null ? employeeJob["name"] : "No Job Assigned";
      employee["hoursWorked"] = totalHours > 0 ? totalHours.toString() : "Not Assigned";
    }

    showDialog(
      context: context,
      builder: (context) {
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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF133E87)),
                  ),
                  const SizedBox(height: 15),
                  Text("Title: ${project["name"]}", style: _infoStyle()),
                  Text("Description: ${project["description"]}", style: _infoStyle()),
                  Text("Client: ${project["clientName"]}", style: _infoStyle()),
                  Text("Start Date: ${project["startDate"]}", style: _infoStyle()),
                  Text("End Date: ${project["endDate"]}", style: _infoStyle()),
                  const SizedBox(height: 20),
                  const Text(
                    "Employees",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF133E87)),
                  ),
                  const SizedBox(height: 10),
                  ...employees.map((emp) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Color(0xFF133E87)),
                      title: Text(emp["email"], style: _infoStyle()),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Job: ${emp["job"]}", style: _infoStyle()),
                          Text("Hours Worked: ${emp["hoursWorked"]}", style: _infoStyle()),
                        ],
                      ),
                    ),
                  )),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Close", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  TextStyle _infoStyle() => const TextStyle(fontSize: 16, color: Colors.black87);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Projects", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF133E87),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: fetchProjects),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
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
                title: Text(project["name"], style: _infoStyle()),
                subtitle: Text("Client: ${project["clientName"]}", style: _infoStyle()),
                trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF133E87)),
                onTap: () => showProjectDetails(project),
              ),
            );
          },
        ),
      ),
    );
  }
}
