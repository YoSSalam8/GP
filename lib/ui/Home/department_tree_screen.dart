import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrganizationTreeScreen extends StatefulWidget {
  final String companyId;

  const OrganizationTreeScreen({Key? key, required this.companyId}) : super(key: key);

  @override
  State<OrganizationTreeScreen> createState() => _OrganizationTreeScreenState();
}

class _OrganizationTreeScreenState extends State<OrganizationTreeScreen> {
  late Future<Map<String, Map<String, List<Map<String, dynamic>>>>> _organizationTreeFuture;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _organizationTreeFuture = fetchOrganizationTree(widget.companyId);
  }

  Future<Map<String, Map<String, List<Map<String, dynamic>>>>> fetchOrganizationTree(String companyId) async {
    final url = Uri.parse('http://localhost:8080/api/employees/company/$companyId/employees');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;

        final Map<String, Map<String, List<Map<String, dynamic>>>> organizationTree = {};

        for (var employee in data) {
          final department = employee['departmentName'];
          final workTitle = employee['workTitleName'];

          if (!organizationTree.containsKey(department)) {
            organizationTree[department] = {};
          }

          if (!organizationTree[department]!.containsKey(workTitle)) {
            organizationTree[department]![workTitle] = [];
          }

          organizationTree[department]![workTitle]!.add(employee);
        }

        return organizationTree;
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  List<MapEntry<String, Map<String, List<Map<String, dynamic>>>>> filterData(
      Map<String, Map<String, List<Map<String, dynamic>>>> organizationTree) {
    if (_searchQuery.isEmpty) {
      return organizationTree.entries.toList();
    }

    return organizationTree.entries.where((departmentEntry) {
      final departmentName = departmentEntry.key.toLowerCase();
      final workTitles = departmentEntry.value;

      return departmentName.contains(_searchQuery.toLowerCase()) ||
          workTitles.entries.any((workTitleEntry) {
            final workTitleName = workTitleEntry.key.toLowerCase();
            final employees = workTitleEntry.value;

            return workTitleName.contains(_searchQuery.toLowerCase()) ||
                employees.any((employee) {
                  final employeeName = employee['name']?.toLowerCase() ?? '';
                  return employeeName.contains(_searchQuery.toLowerCase());
                });
          });
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by department, work title, or employee...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, Map<String, List<Map<String, dynamic>>>>>(
              future: _organizationTreeFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No data available"));
                }

                final organizationTree = snapshot.data!;
                final filteredData = filterData(organizationTree);

                return ListView(
                  padding: const EdgeInsets.all(12.0),
                  children: filteredData.map((departmentEntry) {
                    final departmentName = departmentEntry.key;
                    final workTitles = departmentEntry.value;

                    // Calculate total employees in the department
                    final totalEmployees = workTitles.values.fold<int>(
                        0, (sum, workTitleEmployees) => sum + workTitleEmployees.length);

                    return Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        iconColor: Colors.blueAccent,
                        collapsedIconColor: Colors.blueAccent,
                        title: Row(
                          children: [
                            const Icon(Icons.account_tree_rounded, size: 30, color: Colors.blueAccent),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "$departmentName ($totalEmployees Employees)",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                              ),
                            ),
                          ],
                        ),
                        children: workTitles.entries.map((workTitleEntry) {
                          final workTitleName = workTitleEntry.key;
                          final employees = workTitleEntry.value;

                          return Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: ExpansionTile(
                                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                iconColor: Colors.orangeAccent,
                                collapsedIconColor: Colors.orangeAccent,
                                title: Row(
                                  children: [
                                    const Icon(Icons.work_outline, size: 28, color: Colors.orangeAccent),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "$workTitleName (${employees.length} Employees)",
                                        style: const TextStyle(
                                            fontSize: 18, fontWeight: FontWeight.w600, color: Colors.orangeAccent),
                                      ),
                                    ),
                                  ],
                                ),
                                children: employees.map((employee) {
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.blueAccent.shade100,
                                      child: const Icon(Icons.person, color: Colors.white),
                                    ),
                                    title: Text(employee['name'] ?? 'Unnamed Employee'),
                                    subtitle: Text("ID: ${employee['id']}"),
                                    trailing: Text(
                                      employee['status'] ?? '',
                                      style: TextStyle(
                                        color: employee['status'] == 'PRESENT' ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
