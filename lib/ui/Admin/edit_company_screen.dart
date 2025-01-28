import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditCompanyScreen extends StatefulWidget {
  final String companyId; // Add companyId
  final String token; // Add token parameter

  const EditCompanyScreen({super.key, required this.companyId, required this.token});

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
    {"id": 17, "name": "ATTENDANCE" ,},
    {"id": 18, "name": "VIEW_MONTHLY_ATTENDANCE" },
    {"id": 19, "name": "VIEW_PROFILE" },
    {"id": 20, "name": "EDIT_PROFILE"},
    {"id": 21, "name": "ADD_EMPLOYEE"},
    {"id": 22, "name": "EDIT_EMPLOYEE"},
    {"id": 23, "name": "EDIT_COMPANY"},
    {"id": 24, "name": "CREATE_ANNOUNCEMENT"},
    {"id": 25, "name": "VIEW_ANNOUNCEMENTS"},
    {"id": 26, "name": "PAYROLL"},
    {"id": 27, "name": "REQUEST_LEAVE"},
    {"id": 28, "name": "APPROVE_REJECT_LEAVES"},
    {"id": 29, "name": "VIEW_LEAVE"},
    {"id": 30, "name": "VIEW_ORGANIZATION_TREE"},
    {"id": 31, "name": "CREATE_PROJECT"},
    {"id": 32, "name": "VIEW_PROJECT"},
    {"id": 35, "name": "VIEW_CV"},
    {"id": 37, "name": "ADD_CV"},
  ];

  @override
  void initState() {
    super.initState();
    _fetchCompanyDetails();
  }

  Future<void> _fetchCompanyDetails() async {
    final String apiUrl = 'http://localhost:8080/api/companies/${widget.companyId}';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${widget.token}', // Include the token
          'Content-Type': 'application/json',
        },

      );
      print("API Response: ${response.body}");


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
              "name": department['name'],
              "workTitles": List<Map<String, dynamic>>.from(
                (department['workTitles'] ?? []).map((workTitle) => {
                  "id": workTitle['id'],
                  "name": workTitle['name'],
                  "authorities": List<String>.from(workTitle['authorities'] ?? []), // Adjusted to handle string authorities
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
        "emailDomains": emailDomains, // Ensure this is a list of strings
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
                "authorityIds": workTitle["authorities"].map((authName) {
                  final authority = authorities.firstWhere(
                        (a) => a["name"] == authName,
                    orElse: () => {"id": -1}, // Return a default Map<String, dynamic> with id -1
                  );
                  return authority["id"];
                }).where((id) => id != -1).toList(), // Filter out invalid IDs

              };
            }).toList(),

          };
        }).toList(),

      });

      print("Request Body: $body"); // Debug log

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}"); // Debug log

      if (response.statusCode == 200) {
        await _fetchCompanyDetails(); // Refresh to get updated data from the backend.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Company details updated successfully!')),
        );
      } else {
        // Log and show the error message
        final errorMessage = jsonDecode(response.body)['message'] ?? 'Unknown error';
        throw Exception('Failed to update company details: $errorMessage');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _saveChanges() {
    _updateCompanyDetails();
  }



  void _editAuthorities(Map<String, dynamic> workTitle) {
    // Get the initially selected authorities
    List<int> selectedAuthorities = workTitle["authorities"].map<int>((authName) {
      final authority = authorities.firstWhere(
            (a) => a["name"] == authName,
        orElse: () => {"id": -1},
      );
      return authority["id"] as int;
    }).where((id) => id != -1).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Edit Authorities for ${workTitle["name"]}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Number of columns
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 3,
                        ),
                        itemCount: authorities.length,
                        itemBuilder: (context, index) {
                          final authority = authorities[index];
                          final isSelected = selectedAuthorities.contains(authority["id"]);
                          final isDisabled =
                              authority["name"] == "ATTENDANCE" || authority["name"] == "VIEW_PROFILE";

                          return GestureDetector(
                            onTap: isDisabled
                                ? null
                                : () {
                              setModalState(() {
                                if (isSelected) {
                                  selectedAuthorities.remove(authority["id"]);
                                } else {
                                  selectedAuthorities.add(authority["id"]);
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue // Selected authority
                                    : Colors.white, // Deselected authority
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue // Border for selected
                                      : isDisabled
                                      ? Colors.grey // Disabled border
                                      : Colors.black, // Default border
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  authority["name"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white // Text color for selected
                                        : isDisabled
                                        ? Colors.grey // Disabled text
                                        : Colors.black, // Default text
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              workTitle["authorities"] = selectedAuthorities.map((id) {
                                final authority = authorities.firstWhere(
                                      (a) => a["id"] == id,
                                  orElse: () => {"name": ""},
                                );
                                return authority["name"];
                              }).toList();
                            });

                            _updateCompanyDetails();
                            Navigator.of(context).pop();
                          },
                          child: const Text("Save"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
                          decoration: const InputDecoration(labelText: "Department Name"),
                          onFieldSubmitted: (newValue) {
                            if (newValue.isNotEmpty) {
                              setState(() {
                                department["name"] = newValue;
                              });
                              _updateCompanyDetails();
                            }
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
                          children: department["workTitles"].map<Widget>(
                                (workTitle) {
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              initialValue: workTitle["name"],
                                              decoration: const InputDecoration(
                                                  labelText: "Work Title"),
                                              onFieldSubmitted: (newValue) {
                                                if (newValue.isNotEmpty) {
                                                  setState(() {
                                                    workTitle["name"] = newValue;
                                                  });
                                                  _updateCompanyDetails();
                                                }
                                              },
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.settings, color: Colors.blue),
                                            onPressed: () {
                                              _editAuthorities(workTitle);
                                            },
                                          ),
                                        ],

                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          decoration:
                          const InputDecoration(labelText: "Add Work Title"),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                department["workTitles"]
                                    .add({"id": null, "name": value, "authorities": []});
                              });
                              _updateCompanyDetails();
                            }
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
                if (value.isNotEmpty) {
                  setState(() {
                    departments.add({
                      "id": null, // `null` for new department.
                      "name": value,
                      "workTitles": [],
                    });
                  });
                  _updateCompanyDetails();
                }
              },
            ),
          ],
        ),
      ),
    );
  }


}
