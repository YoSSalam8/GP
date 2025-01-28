import 'package:flutter/material.dart';

class ViewCVScreen extends StatefulWidget {
  final String companyId;
  final String employeeId;
  final String employeeEmail;
  final String token;

  const ViewCVScreen({
    Key? key,
    required this.companyId,
    required this.employeeId,
    required this.employeeEmail,
    required this.token,
  }) : super(key: key);

  @override
  State<ViewCVScreen> createState() => _ViewCVScreenState();
}

class _ViewCVScreenState extends State<ViewCVScreen> {
  final List<Map<String, dynamic>> cvs = [
    {
      "position": "Back End Developer",
      "cvCount": "15",
      "cvs": [
        "John Doe",
        "Jane Smith",
        "Michael Brown",
        "Emily Davis",
        "Sarah Wilson",
        "David Clark",
        "Emma Johnson",
        "James Thompson",
        "Sophia Anderson",
        "William Harris",
        "Ava Martin",
        "Alexander Lee",
        "Charlotte Moore",
        "Daniel Walker",
        "Olivia Taylor"
      ],
    },
    {
      "position": "Front End Developer",
      "cvCount": "8",
      "cvs": [
        "Ella Adams",
        "Liam White",
        "Grace Hall",
        "Mason King",
        "Chloe Allen",
        "Lucas Scott",
        "Amelia Green",
        "Noah Wright"
      ],
    },
    {
      "position": "Data Scientist",
      "cvCount": "12",
      "cvs": [
        "Ethan Baker",
        "Sophia Nelson",
        "Benjamin Carter",
        "Mia Mitchell",
        "Isabella Perez",
        "Jacob Roberts",
        "Emily Turner",
        "Daniel Young",
        "Samantha Sanchez",
        "Logan Martinez",
        "Emma Hill",
        "James Lewis"
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("View CVs"),
        backgroundColor: const Color(0xFF133E87),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade300, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isWeb ? 1000 : double.infinity),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cvs.length,
              itemBuilder: (context, index) {
                final cv = cvs[index];
                return _buildCVCard(
                  position: cv["position"] ?? "",
                  cvCount: cv["cvCount"] ?? "",
                  candidates: cv["cvs"] as List<String>,
                  isWeb: isWeb,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCVCard({
    required String position,
    required String cvCount,
    required List<String> candidates,
    required bool isWeb,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 6,
      child: ListTile(
        onTap: () => _showCVDialog(context, position, candidates),
        contentPadding: const EdgeInsets.all(16),
        leading: const Icon(Icons.work, color: Colors.blueAccent, size: 40),
        title: Text(
          position,
          style: TextStyle(
            fontSize: isWeb ? 24 : 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          "Number of CVs: $cvCount",
          style: TextStyle(
            fontSize: isWeb ? 18 : 14,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  void _showCVDialog(BuildContext context, String position, List<String> candidates) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey.shade200],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF133E87), Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    "CVs for $position",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                // Candidate List
                Container(
                  height: 300,
                  child: ListView.builder(
                    itemCount: candidates.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 4,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: Text(
                                candidates[index][0],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              candidates[index],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Add logic to view CV
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    icon: const Icon(Icons.visibility, color: Colors.white),
                                    label: const Text("View CV"),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Add logic to view summary
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    icon: const Icon(Icons.description, color: Colors.white),
                                    label: const Text("View Summary"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Close Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF133E87),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    ),
                    child: const Text("Close", style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
