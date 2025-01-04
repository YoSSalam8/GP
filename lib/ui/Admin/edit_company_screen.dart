import 'package:flutter/material.dart';

class EditCompanyScreen extends StatefulWidget {
  const EditCompanyScreen({super.key});

  @override
  State<EditCompanyScreen> createState() => _EditCompanyScreenState();
}

class _EditCompanyScreenState extends State<EditCompanyScreen> {
  final List<String> emailDomains = ["example.com", "company.org"];
  final List<String> countries = ["United States", "Canada", "Germany"];
  final List<int> taxCodes = [101, 202, 303];
  final List<Map<String, dynamic>> departments = [
    {
      "name": "HR",
      "workTitles": [
        {"name": "Manager", "authorities": [1, 2]},
        {"name": "Assistant", "authorities": [2]}
      ]
    },
    {
      "name": "Finance",
      "workTitles": [
        {"name": "Accountant", "authorities": [3, 5]},
        {"name": "Auditor", "authorities": []}
      ]
    },
  ];

  final List<Map<String, dynamic>> authorities = [
    {"id": 1, "name": "EDIT_PERSONAL_DETAILS"},
    {"id": 2, "name": "EDIT_EMPLOYEE_DETAILS"},
    {"id": 3, "name": "VIEW_EMPLOYEE_ATTENDANCE"},
    {"id": 4, "name": "VIEW_PERSONAL_ATTENDANCE"},
    {"id": 5, "name": "ACCEPT_LEAVE_REQUEST"},
    {"id": 6, "name": "DENY_LEAVE_REQUEST"},
  ];

  void _addItem(List<dynamic> list, dynamic newItem) {
    setState(() {
      list.add(newItem);
    });
  }

  void _editItem(List<dynamic> list, int index, dynamic newValue) {
    setState(() {
      list[index] = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600;

    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isWeb ? 800 : double.infinity),
          padding: EdgeInsets.symmetric(horizontal: isWeb ? 32 : 16, vertical: 20),
          child: ListView(
            children: [
              const Text(
                "Edit Company Details",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              _buildSection(
                "Email Domains",
                emailDomains,
                "Enter new domain",
                    (value) => _addItem(emailDomains, value),
                isEditable: true,
              ),
              const SizedBox(height: 16),
              _buildSection(
                "Countries",
                countries,
                "Enter new country",
                    (value) => _addItem(countries, value),
                isEditable: true,
              ),
              const SizedBox(height: 16),
              _buildSection(
                "Tax Codes",
                taxCodes.map((e) => e.toString()).toList(),
                "Enter new tax code",
                    (value) {
                  int? parsedValue = int.tryParse(value);
                  if (parsedValue != null) {
                    _addItem(taxCodes, parsedValue);
                  }
                },
                isEditable: true,
              ),
              const SizedBox(height: 16),
              _buildDepartmentSection(isWeb),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                    backgroundColor: const Color(0xFF133E87),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Company details updated successfully!")),
                    );
                  },
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

  Widget _buildSection(
      String title, List<String> list, String hint, Function(String) onAdd,
      {required bool isEditable}) {
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
            ...list.asMap().entries.map((entry) {
              int index = entry.key;
              String value = entry.value;
              return ListTile(
                title: isEditable
                    ? TextFormField(
                  initialValue: value,
                  decoration: const InputDecoration(border: InputBorder.none),
                  style: const TextStyle(fontSize: 16),
                  onFieldSubmitted: (newValue) => _editItem(list, index, newValue),
                )
                    : Text(value),
              );
            }).toList(),
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

  Widget _buildDepartmentSection(bool isWeb) {
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
            ...departments.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> department = entry.value;
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: department["name"],
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              onFieldSubmitted: (newValue) {
                                setState(() {
                                  department["name"] = newValue;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Work Titles:",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...department["workTitles"].asMap().entries.map((workEntry) {
                        int workIndex = workEntry.key;
                        Map<String, dynamic> workTitle = workEntry.value;

                        return ListTile(
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
                        );
                      }).toList(),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(labelText: "Add Work Title"),
                        onSubmitted: (value) {
                          setState(() {
                            department["workTitles"].add({"name": value, "authorities": []});
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showAuthorityDialog(BuildContext context, Map<String, dynamic> workTitle) {
    List<int> selectedAuthorities = List.from(workTitle["authorities"]);
    double screenHeight = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Edit Authorities",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: screenHeight * 0.5, // Max height to prevent overflow
                      ),
                      child: GridView.count(
                        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
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
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blue.shade900 : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: isSelected
                                    ? [
                                  const BoxShadow(
                                    color: Colors.blue,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  )
                                ]
                                    : [],
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                child: Text(
                                  auth["name"],
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade900,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
