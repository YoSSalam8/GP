import 'dart:convert'; // For JSON encoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:graduation_project/ui/Login/login_page.dart';
import 'package:graduation_project/ui/Admin/add_admin.dart';
import 'dart:io';

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
  List<String> taxCodeIds = []; // Changed to List<String> for better formatting
  List<Map<String, dynamic>> departments = [];
  String workStartTime = "09:00:00"; // Default start time
  String workEndTime = "18:00:00"; // Default end time
  List<Map<String, dynamic>> leaveTypes = [];

  final List<Map<String, dynamic>> authorities = [
    {"id": 17, "name": "ATTENDANCE" , "mandatory": true},
    {"id": 18, "name": "VIEW_MONTHLY_ATTENDANCE" ,"mandatory": false},
    {"id": 19, "name": "VIEW_PROFILE" ,"mandatory": true},
    {"id": 20, "name": "EDIT_PROFILE","mandatory": false},
    {"id": 21, "name": "ADD_EMPLOYEE","mandatory": false},
    {"id": 22, "name": "EDIT_EMPLOYEE","mandatory": false},
    {"id": 23, "name": "EDIT_COMPANY","mandatory": false},
    {"id": 24, "name": "CREATE_ANNOUNCEMENT","mandatory": false},
    {"id": 25, "name": "VIEW_ANNOUNCEMENTS","mandatory": false},
    {"id": 26, "name": "PAYROLL","mandatory": false},
    {"id": 27, "name": "REQUEST_LEAVE","mandatory": false},
    {"id": 28, "name": "APPROVE_REJECT_LEAVES","mandatory": false},
    {"id": 29, "name": "VIEW_LEAVE","mandatory": false},
    {"id": 30, "name": "VIEW_ORGANIZATION_TREE","mandatory": false},
    {"id": 31, "name": "CREATE_PROJECT","mandatory": false},
    {"id": 32, "name": "VIEW_PROJECT","mandatory": false},
    {"id": 35, "name": "VIEW_CV","mandatory": false},
    {"id": 37, "name": "ADD_CV","mandatory": false},
  ];

  final List<String> countries = [
    'Australia',
    'Canada',
    'Germany',
    'France',
    'United Kingdom',
    'India',
    'Japan',
    'United States',
  ];

  // Mapping between countries and their tax codes
  final Map<String, String> countryTaxCodes = {
    'Australia': 'AU505',
    'Canada': 'CA456',
    'Germany': 'DE202',
    'France': 'FR303',
    'United Kingdom': 'UK789',
    'India': 'IN101',
    'Japan': 'JP404',
    'United States': 'US123',
  };



  void nextStage() {
    if (!validateCurrentStage()) {
      return;
    }
    setState(() {
      currentStage++;
      _pageController.animateToPage(
        currentStage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  bool validateCurrentStage() {
    String errorMessage = "";

    if (currentStage == 0) {
      if (creatorEmail.isEmpty || !creatorEmail.contains("@")) {
        errorMessage = "Please enter a valid creator's email.";
      } else if (companyName.isEmpty) {
        errorMessage = "Please enter the company name.";
      } else if (emailDomains.isEmpty) {
        errorMessage = "Please provide at least one email domain.";
      }
    } else if (currentStage == 1) {
      if (selectedCountries.isEmpty) {
        errorMessage = "Please select at least one country.";
      }
    } else if (currentStage == 2) {
      if (departments.isEmpty || departments.any((dept) => dept["name"].isEmpty)) {
        errorMessage = "Each department must have a name.";
      } else if (departments.any((dept) =>
      (dept["workTitles"] as List).isEmpty ||
          (dept["workTitles"] as List).any((title) => title["name"].isEmpty))) {
        errorMessage = "Each department must have at least one work title with a name.";
      }
    } else if (currentStage == 3) {
      if (leaveTypes.isEmpty || leaveTypes.any((leave) => leave["type"].isEmpty)) {
        errorMessage = "Each leave type must have a name.";
      } else if (leaveTypes.any((leave) => leave["daysAllowed"] <= 0)) {
        errorMessage = "Each leave type must allow at least one day.";
      }
    }

    if (errorMessage.isNotEmpty) {
      showErrorDialog(context, errorMessage);
      return false;
    }

    return true;
  }



  void addLeaveType() {
    setState(() {
      leaveTypes.add({"type": "", "daysAllowed": 0, "isPaid": false});
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
      departments[departmentIndex]["workTitles"].add({
        "name": "",
        "authorityIds": authorities
            .where((auth) => auth["mandatory"] == true) // Add mandatory authorities
            .map((auth) => auth["id"])
            .toList(),
      });
    });
  }


  void sendRequest(BuildContext context, Map<String, dynamic> requestPayload) async {
    const String url = "http://192.168.68.107:8080/api/companies/create-structure";
    int companyId ; // Variable to store the company ID


    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestPayload),

      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        companyId = responseData['id']; // Extract company ID
        print("Company ID: $companyId");
        print(response);
        print(jsonEncode(requestPayload));
        showSuccessDialog(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddAdmin(companyId: companyId), // Convert to string if needed for AddAdmin
          ),
        );
      } else {
        showErrorDialog(context, response.body);
      }
    } catch (error) {
      showErrorDialog(context, error.toString());
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
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
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
                "Validation Error",
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
                  Navigator.pop(context);
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


  Widget buildLeaveTypeStage() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: currentStage == 3 ? 1.0 : 0.0,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Step 4: Define Leave Types",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addLeaveType,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade600,
                foregroundColor: Colors.white,
                minimumSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("Add Leave Type"),
            ),
            const SizedBox(height: 20),
            ...leaveTypes.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> leaveType = entry.value;

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
                        labelText: "Leave Type (e.g., Sickness, Vacation)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.category),
                      ),
                      onChanged: (value) => leaveTypes[index]["type"] = value,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Number of Allowed Days",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.calendar_today),
                      ),
                      onChanged: (value) => leaveTypes[index]["daysAllowed"] = int.tryParse(value) ?? 0,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          "Paid Leave?",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Switch(
                          value: leaveTypes[index]["isPaid"],
                          onChanged: (value) {
                            setState(() {
                              leaveTypes[index]["isPaid"] = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          leaveTypes.removeAt(index);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(150, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Remove Leave Type"),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
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
                    buildLeaveTypeStage(), // New leave type stage

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
                        if (currentStage == 3) {
                          final requestPayload = {
                            "name": companyName,
                            "creatorEmail": creatorEmail,
                            "emailDomains": emailDomains,
                            "countryTaxCode": taxCodeIds,
                            "workStartTime": workStartTime,
                            "workEndTime": workEndTime,
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
                            "leaveTypes": leaveTypes.map((leaveType) {
                              return {
                                "name": leaveType["type"], // Map "type" to "name"
                                "maxAllowedDays": leaveType["daysAllowed"], // Adjust key
                                "isPaid": leaveType["isPaid"],
                              };
                            }).toList(),
                          };

                          sendRequest(context, requestPayload);
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
                      child: Text(currentStage == 3 ? "Submit" : "Next"),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 600;

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: currentStage == 0 ? 1.0 : 0.0,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: isWeb ? constraints.maxWidth * 0.6 : double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: isWeb ? 20 : 16,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      onChanged: (value) => emailDomains =
                          value.split(",").map((e) => e.trim()).toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Company Working Hours",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "Start Time (e.g., 09:00 )",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(Icons.access_time),
                            ),
                            onChanged: (value) {
                              setState(() {
                                departments.forEach((department) {
                                  department["startTime"] = value;
                                });
                              });
                            },
                          ),
                        ),
                        SizedBox(width: isWeb ? 20 : 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "End Time (e.g., 17:00 )",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(Icons.access_time_filled),
                            ),
                            onChanged: (value) {
                              setState(() {
                                departments.forEach((department) {
                                  department["endTime"] = value;
                                });
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
            items: countries.map((country) {
              return DropdownMenuItem(
                value: country,
                child: Text(country),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  if (!selectedCountries.contains(value)) {
                    selectedCountries.add(value);
                    final taxCode = countryTaxCodes[value];
                    if (taxCode != null) {
                      taxCodeIds.add(taxCode); // Add tax code directly
                    }
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
              label: Text("$country - ${countryTaxCodes[country] ?? ''}"),
              deleteIcon: const Icon(Icons.cancel),
              onDeleted: () {
                setState(() {
                  int index = selectedCountries.indexOf(country);
                  selectedCountries.removeAt(index);
                  taxCodeIds.removeAt(index);
                });
              },
            ))
                .toList(),
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
                              bool isSelected = (workTitle["authorityIds"] ?? []).contains(auth["id"]);
                              bool isMandatory = auth["mandatory"] == true;

                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.blue.shade900 : Colors.grey.shade200,
                                  border: Border.all(
                                    color: isSelected ? Colors.green.shade700 : Colors.grey.shade400,
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
                                  onTap: isMandatory
                                      ? null // Disable interaction for mandatory authorities
                                      : () {
                                    setState(() {
                                      if (isSelected) {
                                        workTitle["authorityIds"].remove(auth["id"]);
                                      } else {
                                        workTitle["authorityIds"].add(auth["id"]);
                                      }
                                    });
                                  },
                                  child: Text(
                                    auth["name"],
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black87,
                                      fontWeight: isMandatory
                                          ? FontWeight.bold // Highlight mandatory authorities
                                          : isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
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
