import 'package:flutter/material.dart';

class CreateProject extends StatefulWidget {
  final String companyId; // Add companyId parameter

  const CreateProject({super.key, required this.companyId});

  @override
  State<CreateProject> createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  final TextEditingController projectTitleController = TextEditingController();
  final List<Map<String, dynamic>> positions = [];

  void addPosition() {
    setState(() {
      positions.add({
        "positionName": "",
        "employees": [], // List of employees for the position
      });
    });
  }

  void addEmployee(int positionIndex) {
    setState(() {
      positions[positionIndex]["employees"].add({
        "employeeName": "",
        "hours": 0,
      });
    });
  }

  void removePosition(int index) {
    setState(() {
      positions.removeAt(index);
    });
  }

  void removeEmployee(int positionIndex, int employeeIndex) {
    setState(() {
      positions[positionIndex]["employees"].removeAt(employeeIndex);
    });
  }

  void submitProject() {
    if (projectTitleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Project title cannot be empty!")),
      );
      return;
    }

    final projectData = {
      "companyId": widget.companyId,
      "title": projectTitleController.text,
      "positions": positions.map((position) {
        return {
          "positionName": position["positionName"],
          "employees": position["employees"],
        };
      }).toList(),
    };

    // Here, send projectData to the backend or perform necessary actions
    print("Project Data: $projectData");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Project created successfully!")),
    );
    Navigator.pop(context); // Navigate back
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Project",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF133E87),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Enhanced Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFCBDCEB), Color(0xFF608BC1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWeb ? screenWidth * 0.2 : 16,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Project Details",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF133E87),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: projectTitleController,
                          decoration: InputDecoration(
                            labelText: "Project Title",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.title),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Project Positions",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF133E87),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: addPosition,
                      child: const Text("Add Position"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...positions.asMap().entries.map((entry) {
                  int positionIndex = entry.key;
                  Map<String, dynamic> position = entry.value;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.teal, width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Position Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.work),
                          ),
                          onChanged: (value) => positions[positionIndex]["positionName"] = value,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Employees for this position",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () => addEmployee(positionIndex),
                              child: const Text("Add Employee"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...positions[positionIndex]["employees"].asMap().entries.map((empEntry) {
                          int employeeIndex = empEntry.key;
                          Map<String, dynamic> employee = empEntry.value;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.orange, width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: "Employee Name",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    prefixIcon: const Icon(Icons.person),
                                  ),
                                  onChanged: (value) => positions[positionIndex]["employees"]
                                  [employeeIndex]["employeeName"] = value,
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Hours",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    prefixIcon: const Icon(Icons.timer),
                                  ),
                                  onChanged: (value) => positions[positionIndex]["employees"]
                                  [employeeIndex]["hours"] = int.tryParse(value) ?? 0,
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade600,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: () => removeEmployee(positionIndex, employeeIndex),
                                  child: const Text("Remove Employee"),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () => removePosition(positionIndex),
                          child: const Text("Remove Position"),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF133E87),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: submitProject,
                    child: const Text(
                      "Create Project",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
