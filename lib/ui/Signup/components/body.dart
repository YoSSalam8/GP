import 'package:flutter/material.dart';
import 'package:graduation_project/ui/Admin/admin_home.dart';
import 'package:graduation_project/ui/Login/components/rounded_input_field.dart';

class MultiStageSignUp extends StatefulWidget {
  const MultiStageSignUp({super.key});

  @override
  _MultiStageSignUpState createState() => _MultiStageSignUpState();
}

class _MultiStageSignUpState extends State<MultiStageSignUp> {
  int currentStage = 0;

  // Controllers for form data
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController emailDomainsController = TextEditingController();
  final TextEditingController countryIdsController = TextEditingController();
  final TextEditingController taxCodeIdsController = TextEditingController();
  final TextEditingController departmentNameController = TextEditingController();
  final TextEditingController workTitleNameController = TextEditingController();
  final TextEditingController authorityIdsController = TextEditingController();

  List<Map<String, dynamic>> departments = [];

  void nextStage() {
    setState(() {
      currentStage++;
    });
  }

  void previousStage() {
    setState(() {
      if (currentStage > 0) currentStage--;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isWeb = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up - Step ${currentStage + 1}"),
        backgroundColor: const Color(0xFF608BC1),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? size.width * 0.2 : 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (currentStage == 0) buildCompanyStage(),
              if (currentStage == 1) buildCountryStage(),
              if (currentStage == 2) buildDepartmentStage(),
              SizedBox(height: size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentStage > 0)
                    ElevatedButton(
                      onPressed: previousStage,
                      child: const Text("Back"),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      if (currentStage == 2) {
                        // Final submission logic
                        print({
                          "name": companyNameController.text.trim(),
                          "emailDomains": emailDomainsController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList(),
                          "countryIds": countryIdsController.text
                              .split(',')
                              .map((e) => int.tryParse(e.trim()) ?? 0)
                              .toList(),
                          "taxCodeIds": taxCodeIdsController.text
                              .split(',')
                              .map((e) => int.tryParse(e.trim()) ?? 0)
                              .toList(),
                          "departments": departments,
                        });
                      } else {
                        nextStage();
                      }
                    },
                    child: Text(currentStage == 2 ? "Submit" : "Next"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCompanyStage() {
    return Column(
      children: [
        const Text(
          "Step 1: Company Information",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        RoundedInputField(
          hintText: "Company Name",
          controller: companyNameController,
          onChanged: (value) {},
        ),
        RoundedInputField(
          hintText: "Email Domains (comma-separated)",
          controller: emailDomainsController,
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget buildCountryStage() {
    return Column(
      children: [
        const Text(
          "Step 2: Country and Tax Information",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        RoundedInputField(
          hintText: "Country IDs (comma-separated)",
          controller: countryIdsController,
          onChanged: (value) {},
        ),
        RoundedInputField(
          hintText: "Tax Code IDs (comma-separated)",
          controller: taxCodeIdsController,
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget buildDepartmentStage() {
    return Column(
      children: [
        const Text(
          "Step 3: Departments and Authorities",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        RoundedInputField(
          hintText: "Department Name",
          controller: departmentNameController,
          onChanged: (value) {
            if (departments.isEmpty || departments.last["workTitles"] != null) {
              departments.add({"name": value, "workTitles": []});
            } else {
              departments.last["name"] = value;
            }
          },
        ),
        RoundedInputField(
          hintText: "Work Title Name",
          controller: workTitleNameController,
          onChanged: (value) {
            if (departments.isNotEmpty && departments.last["workTitles"] != null) {
              departments.last["workTitles"].add({"name": value, "authorityIds": []});
            }
          },
        ),
        RoundedInputField(
          hintText: "Authority IDs (comma-separated)",
          controller: authorityIdsController,
          onChanged: (value) {
            if (departments.isNotEmpty && departments.last["workTitles"] != null) {
              List<int> authorityIds =
              value.split(",").map((e) => int.tryParse(e.trim()) ?? 0).toList();
              departments.last["workTitles"].last["authorityIds"] = authorityIds;
            }
          },
        ),
      ],
    );
  }
}
