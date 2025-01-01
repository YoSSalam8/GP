import 'package:flutter/material.dart';
import 'package:graduation_project/ui/Admin/admin_home.dart';
import 'package:graduation_project/ui/Login/components/already_have_an_account_check.dart';
import 'package:graduation_project/ui/Login/components/rounded_button.dart';
import 'package:graduation_project/ui/Login/components/rounded_input_field.dart';
import 'package:graduation_project/ui/Login/components/rounded_password_field.dart';
import 'package:graduation_project/ui/Login/login_page.dart';
import 'package:graduation_project/ui/Signup/components/background.dart';

class MultiStageSignUp extends StatefulWidget {
  const MultiStageSignUp({super.key});

  @override
  _MultiStageSignUpState createState() => _MultiStageSignUpState();
}

class _MultiStageSignUpState extends State<MultiStageSignUp> {
  int currentStage = 0;

  // Form data
  String companyName = "";
  List<String> emailDomains = [];
  List<int> countryIds = [];
  List<int> taxCodeIds = [];
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
                          "name": companyName,
                          "emailDomains": emailDomains,
                          "countryIds": countryIds,
                          "taxCodeIds": taxCodeIds,
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
          onChanged: (value) {
            companyName = value;
          },
        ),
        RoundedInputField(
          hintText: "Email Domains (comma-separated)",
          onChanged: (value) {
            emailDomains = value.split(",").map((e) => e.trim()).toList();
          },
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
          onChanged: (value) {
            countryIds = value.split(",").map((e) => int.tryParse(e.trim()) ?? 0).toList();
          },
        ),
        RoundedInputField(
          hintText: "Tax Code IDs (comma-separated)",
          onChanged: (value) {
            taxCodeIds = value.split(",").map((e) => int.tryParse(e.trim()) ?? 0).toList();
          },
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
          onChanged: (value) {
            if (departments.isNotEmpty && departments.last["workTitles"] != null) {
              departments.last["workTitles"].add({"name": value, "authorityIds": []});
            }
          },
        ),
        RoundedInputField(
          hintText: "Authority IDs (comma-separated)",
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
