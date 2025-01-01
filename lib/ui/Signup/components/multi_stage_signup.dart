import 'dart:convert'; // For JSON encoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:graduation_project/ui/Login/login_page.dart';

class MultiStageSignUp extends StatefulWidget {
  const MultiStageSignUp({super.key});

  @override
  _MultiStageSignUpState createState() => _MultiStageSignUpState();
}

class _MultiStageSignUpState extends State<MultiStageSignUp> {
  final PageController _pageController = PageController();
  int currentStage = 0;

  String creatorEmail = "";
  String companyName = "";
  List<String> emailDomains = [];
  List<String> selectedCountries = [];
  List<int> taxCodeIds = [];
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

  final List<String> countries = [
    'United States',
    'Canada',
    'Germany',
    'France',
    'United Kingdom',
    'China',
    'India',
    'Australia',
    'Brazil',
    'Japan',
  ];

  void nextStage() {
    setState(() {
      currentStage++;
      _pageController.animateToPage(
        currentStage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void previousStage() {
    setState(() {
      if (currentStage > 0) {
        currentStage--;
        _pageController.animateToPage(
          currentStage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void addDepartment() {
    setState(() {
      departments.add({"name": "", "workTitles": []});
    });
  }

  void addWorkTitle(int departmentIndex) {
    setState(() {
      departments[departmentIndex]["workTitles"].add({"name": "", "authorityIds": []});
    });
  }

  void sendRequest(BuildContext context, Map<String, dynamic> requestPayload) async {
    const String url = "http://192.168.1.125:8080/api/companies/create-structure";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestPayload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showSuccessDialog(context); // Show success popup
      } else {
        showErrorDialog(context, response.body); // Show error message
      }
    } catch (error) {
      showErrorDialog(context, error.toString()); // Show error message
    }
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              const Text(
                "Success!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your company structure has been created.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      },
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 80),
              const SizedBox(height: 20),
              const Text(
                "Error",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isWeb = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF133E87),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the landing page
          },
        ),
        title: const Text(
          "Sign Up",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? size.width * 0.2 : 16,
            vertical: 20,
          ),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    buildCompanyStage(),
                    buildCountryStage(),
                    buildDepartmentStage(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (currentStage > 0)
                      ElevatedButton(
                        onPressed: previousStage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF133E87),
                          side: const BorderSide(color: Color(0xFF133E87)),
                          minimumSize: const Size(100, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text("Back"),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        if (currentStage == 2) {
                          final Map<String, dynamic> requestPayload = {
                            "name": companyName,
                            "creatorEmail": creatorEmail,
                            "emailDomains": emailDomains,
                            "countryTaxCode": selectedCountries
                                .asMap()
                                .entries
                                .map((entry) => "${entry.value}${taxCodeIds.length > entry.key ? taxCodeIds[entry.key] : ""}")
                                .toList(),
                            "departments": departments.map((department) {
                              return {
                                "name": department["name"],
                                "workTitles": (department["workTitles"] as List).map((workTitle) {
                                  return {
                                    "name": workTitle["name"],
                                    "authorityIds": workTitle["authorityIds"]
                                  };
                                }).toList(),
                              };
                            }).toList(),
                          };

                          sendRequest(context, requestPayload); // Send the request
                        } else {
                          nextStage();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF608BC1),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(100, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(currentStage == 2 ? "Submit" : "Next"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCompanyStage() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: currentStage == 0 ? 1.0 : 0.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Step 1: Company Information",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: "Creator's Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.email),
            ),
            onChanged: (value) {
              creatorEmail = value;
            },
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: "Company Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.business),
            ),
            onChanged: (value) => companyName = value,
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: "Email Domains (comma-separated)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.domain),
            ),
            onChanged: (value) =>
            emailDomains = value.split(",").map((e) => e.trim()).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildCountryStage() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: currentStage == 1 ? 1.0 : 0.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Step 2: Country and Tax Information",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            items: countries
                .map((country) => DropdownMenuItem(
              value: country,
              child: Text(country),
            ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  if (!selectedCountries.contains(value)) {
                    selectedCountries.add(value);
                  }
                });
              }
            },
            decoration: InputDecoration(
              labelText: "Select Country",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.flag),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 5,
            children: selectedCountries
                .map((country) => Chip(
              label: Text(country),
              deleteIcon: const Icon(Icons.cancel),
              onDeleted: () {
                setState(() {
                  selectedCountries.remove(country);
                });
              },
            ))
                .toList(),
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: "Tax Code IDs (comma-separated)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.code),
            ),
            onChanged: (value) => taxCodeIds =
                value.split(",").map((e) => int.tryParse(e.trim()) ?? 0).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildDepartmentStage() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: currentStage == 2 ? 1.0 : 0.0,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Step 3: Departments and Authorities",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addDepartment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade600,
                foregroundColor: Colors.white,
                minimumSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("Add Department"),
            ),
            const SizedBox(height: 20),
            ...departments.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> department = entry.value;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.teal.shade800, width: 2.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Department Name ${index + 1}",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) => departments[index]["name"] = value,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => addWorkTitle(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade600,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(150, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Add Work Title"),
                    ),
                    const SizedBox(height: 10),
                    ...department["workTitles"].asMap().entries.map((workEntry) {
                      int workIndex = workEntry.key;
                      Map<String, dynamic> workTitle = workEntry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              labelText:
                              "Work Title ${workIndex + 1} for Department ${index + 1}",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (value) =>
                            departments[index]["workTitles"][workIndex]
                            ["name"] = value,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Select Authorities",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: authorities.map((auth) {
                              bool isSelected =
                              (workTitle["authorityIds"] ?? [])
                                  .contains(auth["id"]);

                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blue.shade900
                                      : Colors.grey.shade200,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.green.shade700
                                        : Colors.grey.shade400,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: isSelected
                                      ? [
                                    BoxShadow(
                                      color: Colors.green.shade100,
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                      : [],
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        workTitle["authorityIds"]
                                            .remove(auth["id"]);
                                      } else {
                                        workTitle["authorityIds"]
                                            .add(auth["id"]);
                                      }
                                    });
                                  },
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: 1.0,
                                    child: Text(
                                      auth["name"],
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
