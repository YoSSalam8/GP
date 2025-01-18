import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditCompanyScreen extends StatefulWidget {
  final String companyId; // Add companyId
  const EditCompanyScreen({super.key, required this.companyId});

  @override
  State<EditCompanyScreen> createState() => _EditCompanyScreenState();
}

class _EditCompanyScreenState extends State<EditCompanyScreen> {
  bool isLoading = true;
  String companyName = '';
  String creatorEmail = '';
  String workStartTime = '';
  String workEndTime = '';
  List<String> emailDomains = [];
  List<Map<String, String>> countryTaxCodes = [];
  List<Map<String, dynamic>> departments = [];

  final List<Map<String, dynamic>> authorities = [
    {"id": 1, "name": "EDIT_PERSONAL_DETAILS"},
    {"id": 2, "name": "EDIT_EMPLOYEE_DETAILS"},
    {"id": 3, "name": "VIEW_EMPLOYEE_ATTENDANCE"},
    {"id": 4, "name": "VIEW_PERSONAL_ATTENDANCE"},
    {"id": 5, "name": "ACCEPT_LEAVE_REQUEST"},
    {"id": 6, "name": "DENY_LEAVE_REQUEST"},
    {"id": 7, "name": "APPROVE_TIMESHEET"},
    {"id": 8, "name": "REJECT_TIMESHEET"},
    {"id": 9, "name": "ADD_EMPLOYEE"},
    {"id": 10, "name": "REMOVE_EMPLOYEE"},
    {"id": 11, "name": "LOCK_EMPLOYEE"},
    {"id": 12, "name": "UNLOCK_EMPLOYEE"},
    {"id": 13, "name": "ADD_DEPARTMENT"},
    {"id": 14, "name": "REMOVE_DEPARTMENT"},
    {"id": 15, "name": "UPDATE_DEPARTMENT"},
    {"id": 16, "name": "VIEW_COMPANY_DETAILS"},
    {"id": 17, "name": "ADD_COUNTRIES"},
    {"id": 18, "name": "REMOVE_COUNTRIES"},
    {"id": 19, "name": "ADD_TAX_CODES"},
    {"id": 20, "name": "REMOVE_TAX_CODES"},
    {"id": 21, "name": "MANAGE_LEAVE_TYPES"},
    {"id": 22, "name": "ACCEPT_DENY_LEAVES"},
    {"id": 23, "name": "VIEW_PAYROLL_DETAILS"},
    {"id": 24, "name": "EDIT_PAYROLL_DETAILS"},
  ];

  @override
  void initState() {
    super.initState();
    _fetchCompanyDetails();
  }

  Future<void> _fetchCompanyDetails() async {
    final String apiUrl = 'http://localhost:8080/api/companies/${widget.companyId}';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          companyName = data['name'] ?? '';
          creatorEmail = data['creatorEmail'] ?? '';
          workStartTime = data['workStartTime'] ?? '';
          workEndTime = data['workEndTime'] ?? '';
          emailDomains = List<String>.from(data['emailDomains'] ?? []);
          countryTaxCodes = List<Map<String, String>>.from(
            (data['countryTaxCodes'] ?? []).map((e) => {
              "countryName": e['countryName']?.toString() ?? '',
              "taxCode": e['taxCode']?.toString() ?? '',
            }),
          );
          departments = List<Map<String, dynamic>>.from(
            (data['departments'] ?? []).map((department) => {
              "id": department['id'],
              "name": department['name']?.toString() ?? '',
              "workTitles": List<Map<String, dynamic>>.from(
                (department['workTitles'] ?? []).map((workTitle) => {
                  "id": workTitle['id'],
                  "name": workTitle['name']?.toString() ?? '',
                  "authorities": List<int>.from(
                    (workTitle['authorities'] ?? []).map((auth) => auth['id']),
                  ),
                }),
              ),
            }),
          );
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load company details');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _updateCompanyDetails() async {
    final String apiUrl = 'http://localhost:8080/api/companies/${widget.companyId}';
    try {
      final body = jsonEncode({
        "name": companyName,
        "creatorEmail": creatorEmail,
        "emailDomains": emailDomains,
        "countryTaxCodes": countryTaxCodes.map((tax) => tax["taxCode"]).toList(),
        "workStartTime": workStartTime,
        "workEndTime": workEndTime,
        "departments": departments.map((department) {
          return {
            "id": department["id"], // Send `null` if new department.
            "name": department["name"],
            "workTitles": department["workTitles"].map((workTitle) {
              return {
                "id": workTitle["id"], // Send `null` if new work title.
                "name": workTitle["name"],
                "authorityIds": workTitle["authorities"] ?? [],
              };
            }).toList(),
          };
        }).toList(),
      });

      print("Headers: ${{'Content-Type': 'application/json'}}");
      print("Body: $body");
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        await _fetchCompanyDetails(); // Refresh to get updated data from the backend.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Company details updated successfully!')),
        );
      } else {
        throw Exception('Failed to update company details. Error: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }


  void _saveChanges() {
    _updateCompanyDetails();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isWeb ? 800 : double.infinity),
          padding: EdgeInsets.symmetric(horizontal: isWeb ? 32 : 16, vertical: 20),
          child: ListView(
            children: [
              const Text(
                "Company Details",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildUneditableField("Company Name", companyName),
              const SizedBox(height: 16),
              _buildUneditableField("Creator Email", creatorEmail),
              const SizedBox(height: 16),
              _buildEditableField("Work Start Time", workStartTime, (value) {
                setState(() => workStartTime = value);
              }),
              const SizedBox(height: 16),
              _buildEditableField("Work End Time", workEndTime, (value) {
                setState(() => workEndTime = value);
              }),
              const SizedBox(height: 16),
              _buildSection("Email Domains", emailDomains, "Enter new domain",
                      (value) => setState(() => emailDomains.add(value))),
              const SizedBox(height: 16),
              _buildCountryTaxCodeSection(),
              const SizedBox(height: 16),
              _buildDepartmentSection(),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                    backgroundColor: const Color(0xFF133E87),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _saveChanges,
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildEditableField(String label, String value, Function(String) onChanged) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildUneditableField(String label, String value) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
      readOnly: true,
      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSection(String title, List<String> list, String hint, Function(String) onAdd) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Divider(thickness: 1.2),
            const SizedBox(height: 8),
            Column(
              children: list.map((value) => ListTile(title: Text(value))).toList(),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              onSubmitted: (value) => onAdd(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryTaxCodeSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Country Tax Codes",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Divider(thickness: 1.2),
            const SizedBox(height: 8),
            countryTaxCodes.isEmpty
                ? const Text('No tax codes available.')
                : Column(
              children: countryTaxCodes
                  .map((taxCode) => ListTile(
                title: Text("${taxCode["countryName"]}: ${taxCode["taxCode"]}"),
              ))
                  .toList(),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter new country and tax code (format: Country:TaxCode)",
              ),
              onSubmitted: (value) {
                List<String> parts = value.split(":");
                if (parts.length == 2) {
                  setState(() {
                    countryTaxCodes.add({"countryName": parts[0].trim(), "taxCode": parts[1].trim()});
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Departments and Work Titles",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Divider(thickness: 1.2),
            const SizedBox(height: 8),
            departments.isEmpty
                ? const Text('No departments available.')
                : Column(
              children: departments.map((department) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          initialValue: department["name"],
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          onFieldSubmitted: (newValue) {
                            setState(() {
                              department["name"] = newValue;
                            });
                            _updateCompanyDetails(); // Update after editing department name.
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Work Titles:",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        department["workTitles"].isEmpty
                            ? const Text('No work titles available.')
                            : Column(
                          children: department["workTitles"]
                              .map<Widget>(
                                (workTitle) => ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: workTitle["name"],
                                      onFieldSubmitted: (newValue) {
                                        setState(() {
                                          workTitle["name"] = newValue;
                                        });
                                        _updateCompanyDetails(); // Update after editing work title name.
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.settings, color: Colors.blue),
                                    onPressed: () {
                                      _showAuthorityDialog(context, workTitle);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                              .toList(),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          decoration: const InputDecoration(labelText: "Add Work Title"),
                          onSubmitted: (value) {
                            setState(() {
                              department["workTitles"].add({"id": null, "name": value, "authorities": []});
                            });
                            _updateCompanyDetails(); // Update after adding work title.
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: "Add Department"),
              onSubmitted: (value) {
                setState(() {
                  departments.add({
                    "id": null, // `null` for new department.
                    "name": value,
                    "workTitles": [],
                  });
                });
                _updateCompanyDetails(); // Update after adding department.
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAuthorityDialog(BuildContext context, Map<String, dynamic> workTitle) {
    List<int> selectedAuthorities = List.from(workTitle["authorities"]);
    bool isWeb = MediaQuery.of(context).size.width > 600; // Check if it's web

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Edit Authorities",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF133E87),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Tap to toggle authority access",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        child: GridView.count(
                          crossAxisCount: isWeb ? 5 : 3, // More columns for web
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          shrinkWrap: true,
                          children: authorities.map((auth) {
                            bool isSelected = selectedAuthorities.contains(auth["id"]);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedAuthorities.remove(auth["id"]);
                                  } else {
                                    selectedAuthorities.add(auth["id"]);
                                  }
                                  workTitle["authorities"] = selectedAuthorities;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.all(4), // Smaller padding for web
                                height: isWeb ? 30 : 50, // Smaller height for web
                                width: isWeb ? 60 : 100, // Smaller width for web
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? const LinearGradient(
                                    colors: [Color(0xFF133E87), Color(0xFF608BC1)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                      : const LinearGradient(
                                    colors: [Colors.white, Colors.white],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected ? Colors.blue : Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.4),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                      : [],
                                ),
                                child: Center(
                                  child: Text(
                                    auth["name"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black87,
                                      fontSize: isWeb ? 15 : 12, // Smaller font size for web
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white),
                            label: const Text("Close"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF133E87),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
