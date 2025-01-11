import 'package:flutter/material.dart';

class DepartmentTreeScreen extends StatelessWidget {
  const DepartmentTreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> departments = [
      {
        "name": "Human Resources",
        "workTitles": [
          {
            "title": "HR Manager",
            "employees": ["Alice Johnson", "Bob Smith"]
          },
          {
            "title": "HR Coordinator",
            "employees": ["Emma Davis"]
          },
        ],
      },
      {
        "name": "Engineering",
        "workTitles": [
          {
            "title": "Software Engineer",
            "employees": ["John Doe", "Jane Doe", "Robert Brown"]
          },
          {
            "title": "System Analyst",
            "employees": ["Samantha Lee"]
          },
        ],
      },
      {
        "name": "Sales",
        "workTitles": [
          {
            "title": "Sales Manager",
            "employees": ["Michael Johnson"]
          },
          {
            "title": "Sales Representative",
            "employees": ["Laura Hill", "Daniel White"]
          },
        ],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Department Tree"),
        backgroundColor: const Color(0xFF133E87),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade200, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: departments.length,
          itemBuilder: (context, index) {
            final department = departments[index];
            return DepartmentTile(department: department);
          },
        ),
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
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade50,
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
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
        boxShadow: [
          BoxShadow(
            color: Colors.orange.shade100,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
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
          return Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(
                  employee,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                subtitle: const Text(
                  "Active",
                  style: TextStyle(color: Colors.green),
                ),
                trailing: const Icon(Icons.check_circle, color: Colors.green),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
