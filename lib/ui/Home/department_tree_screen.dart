import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DepartmentTreeScreen extends StatefulWidget {
  final String companyId;

  const DepartmentTreeScreen({super.key, required this.companyId});

  @override
  _DepartmentTreeScreenState createState() => _DepartmentTreeScreenState();
}

class _DepartmentTreeScreenState extends State<DepartmentTreeScreen> {
  late Future<List<Map<String, dynamic>>> _departmentsFuture;

  @override
  void initState() {
    super.initState();
    _departmentsFuture = fetchDepartments(widget.companyId);
  }

  Future<List<Map<String, dynamic>>> fetchDepartments(String companyId) async {
    final url = Uri.parse('http://localhost:8080/api/employees/company/$companyId/employees');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print("Raw Response: ${response.body}"); // Debug the raw response

        // Clean up the response to handle malformed JSON
        String sanitizedBody = response.body;

        // Fix cases where the response starts with unexpected characters
        sanitizedBody = sanitizedBody.trim().replaceAll('\n', '').replaceAll('\r', '');

        try {
          // Parse the sanitized JSON
          final data = jsonDecode(sanitizedBody) as List;
          return data.map((department) => department as Map<String, dynamic>).toList();
        } catch (jsonError) {
          throw Exception('JSON Parsing Error: ${jsonError.toString()}');
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Department Tree"),
        backgroundColor: const Color(0xFF133E87),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _departmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data available"));
          }

          final departments = snapshot.data!;
          return ListView.builder(
            itemCount: departments.length,
            itemBuilder: (context, index) {
              final department = departments[index];
              return DepartmentTile(department: department);
            },
          );
        },
      ),
    );
  }
}

class DepartmentTile extends StatelessWidget {
  final Map<String, dynamic> department;

  const DepartmentTile({required this.department, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.white, Color(0xFFe3f2fd)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: const Icon(Icons.account_tree_outlined, color: Colors.blue),
            title: Row(
              children: [
                Text(
                  department["name"],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(
                    "${department["workTitles"].length} Roles",
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.blueAccent,
                ),
              ],
            ),
            children: department["workTitles"].map<Widget>((workTitle) {
              return WorkTitleTile(workTitle: workTitle);
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class WorkTitleTile extends StatelessWidget {
  final Map<String, dynamic> workTitle;

  const WorkTitleTile({required this.workTitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        leading: const Icon(Icons.work_outline_rounded, color: Colors.orange),
        title: Row(
          children: [
            Text(
              workTitle["title"],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(width: 8),
            Chip(
              label: Text(
                "${workTitle["employees"].length} Employees",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.orange,
            ),
          ],
        ),
        children: workTitle["employees"].map<Widget>((employee) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              employee["name"],
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            subtitle: Text(
              "ID: ${employee["id"]}",
              style: const TextStyle(color: Colors.grey),
            ),
          );
        }).toList(),
      ),
    );
  }
}
