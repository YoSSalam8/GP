import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:graduation_project/ui/Home/pdf_viewer_screen.dart';

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
  List<Map<String, dynamic>> positions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPositions();
  }

  Future<void> _fetchPositions() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:8080/api/positions/company/${widget.companyId}"),
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Content-Type": "application/json",
          "Accept": "application/json", // 👈 Add this line

        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          positions = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        _showSnackbar("Failed to load job positions.");
      }
    } catch (e) {
      _showSnackbar("Error fetching positions: $e");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View CVs"),
        backgroundColor: const Color(0xFF133E87),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: positions.length,
        itemBuilder: (context, index) {
          final position = positions[index];
          return _buildPositionCard(
            positionName: position["title"] ?? "Unknown Position",
            positionId: position["id"].toString(),
          );
        },
      ),
    );
  }

  Widget _buildPositionCard({required String positionName, required String positionId}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 6,
      child: ListTile(
        onTap: () async {
          List<Map<String, dynamic>> candidates = await _fetchCVsForPosition(positionId);
          _showCVDialog(context, positionName, candidates);
        },
        contentPadding: const EdgeInsets.all(16),
        leading: const Icon(Icons.work, color: Colors.blueAccent, size: 40),
        title: Text(positionName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: const Text("Tap to view CVs"),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchCVsForPosition(String positionId) async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:8080/api/resumes/position/$positionId"),
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      print("Response: ${response.body}"); // ✅ Debugging

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) {
          _showSnackbar("No CVs found for this position.");
          return [];
        }

        return data.map<Map<String, dynamic>>((candidate) {
          return {
            "id": candidate["id"].toString(),
            "name": candidate["candidateName"] ?? "Unknown",
            "email": candidate["candidateEmail"] ?? "No Email",
            "cvFile": candidate["file"] ?? "",
            "parsedJson": candidate["parsedJson"] ?? "{}",
          };
        }).toList();
      } else {
        _showSnackbar("Failed to fetch candidates.");
        return [];
      }
    } catch (e) {
      _showSnackbar("Error fetching candidates: $e");
      return [];
    }
  }


  void _showCVDialog(BuildContext context, String positionName, List<Map<String, dynamic>> candidates) {
    if (candidates.isEmpty) {
      _showSnackbar("No candidates found for this position.");
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "CVs for $positionName",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                candidates.isEmpty
                    ? const Text("No candidates available.", style: TextStyle(fontSize: 16))
                    : SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: candidates.length,
                    itemBuilder: (context, index) {
                      final candidate = candidates[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 4,
                        child: ListTile(
                          title: Text(
                            candidate["name"] ?? "Unknown Candidate",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(candidate["email"] ?? "No Email"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(Icons.visibility, color: Colors.white, size: 18),
                                label: const Text("View CV"),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                onPressed: () {
                                  _openCV(candidate["cvFile"]);
                                },
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.description, color: Colors.white, size: 18),
                                label: const Text("View Summary"),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                onPressed: () async {
                                  try {
                                    // Remove markdown syntax if present
                                    String rawJson = candidate["parsedJson"] ?? "{}";
                                    rawJson = rawJson.replaceAll("```json", "").replaceAll("```", "").trim();

                                    // Parse JSON safely
                                    Map<String, dynamic> summary = json.decode(rawJson);

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SummaryPage(summary: summary),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Failed to parse summary: $e"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Close"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _fetchCandidateSummary(String candidateId) async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:8080/api/resumes/summary/$candidateId"),
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Content-Type": "application/json",
          "Accept": "application/json", // 👈 Add this line

        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  void _showSummaryPage(BuildContext context, Map<String, dynamic> summary) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SummaryPage(summary: summary),
      ),
    );
  }

  void _openCV(String cvFile) async {
    if (cvFile.isEmpty) {
      _showSnackbar("No CV file available.");
      return;
    }

    // Check if the CV file is a URL or Base64-encoded
    if (cvFile.startsWith("http") || cvFile.startsWith("https")) {
      // Case 1: Open the CV from a URL
      if (await canLaunch(cvFile)) {
        await launch(cvFile);
      } else {
        _showSnackbar("Could not open CV URL.");
      }
    } else {
      // Case 2: Decode Base64 and Open in a PDF Viewer
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PdfViewerScreen(base64String: cvFile),
        ),
      );
    }
  }
}








class SummaryPage extends StatelessWidget {
  final Map<String, dynamic> summary;

  const SummaryPage({Key? key, required this.summary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Candidate Summary"),
        backgroundColor: const Color(0xFF133E87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Personal Details"),
            _buildDetail("Name", summary["name"]),
            _buildDetail("Email", summary["email"]),
            _buildDetail("Phone", summary["phone_1"]),
            _buildDetail("Address", summary["address"]),
            _buildDetail("City", summary["city"]),
            const SizedBox(height: 16),

            _buildSectionTitle("Education"),
            ..._buildEducationList(summary["education"]),
            const SizedBox(height: 16),

            _buildSectionTitle("Professional Experience"),
            ..._buildExperienceList(summary["professional_experience"]),
            const SizedBox(height: 16),

            _buildSectionTitle("Voluntary Work"),
            ..._buildExperienceList(summary["voluntary_work"]),
            const SizedBox(height: 16),

            _buildSectionTitle("Awards and Certificates"),
            ..._buildAwardsList(summary["awards_and_certificates"]),
            const SizedBox(height: 16),

            _buildSectionTitle("Projects"),
            ..._buildProjectsList(summary["projects"]),
            const SizedBox(height: 16),

            _buildSectionTitle("Skills"),
            Wrap(
              spacing: 8,
              children: (summary["skills"] ?? [])
                  .map<Widget>((skill) => Chip(label: Text(skill)))
                  .toList(),
            ),
            const SizedBox(height: 16),

            _buildSectionTitle("Languages"),
            ..._buildLanguagesList(summary["languages"]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF133E87)),
    );
  }

  Widget _buildDetail(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? "Not provided")),
        ],
      ),
    );
  }

  List<Widget> _buildEducationList(List<dynamic>? education) {
    if (education == null || education.isEmpty) {
      return [const Text("No education details available.")];
    }
    return education.map((edu) {
      return ListTile(
        title: Text(edu["institute_name"] ?? "Unknown Institute"),
        subtitle: Text(
          "${edu["major"] ?? "Unknown Major"} - ${edu["year_of_passing"] ?? "Unknown Year"}",
        ),
      );
    }).toList();
  }

  List<Widget> _buildExperienceList(List<dynamic>? experiences) {
    if (experiences == null || experiences.isEmpty) {
      return [const Text("No experience details available.")];
    }
    return experiences.map((exp) {
      return ListTile(
        title: Text(exp["organisation_name"] ?? "Unknown Organization"),
        subtitle: Text("${exp["role_or_title"] ?? "Unknown Role"}\n${exp["description"] ?? ""}"),
      );
    }).toList();
  }

  List<Widget> _buildAwardsList(List<dynamic>? awards) {
    if (awards == null || awards.isEmpty) {
      return [const Text("No awards or certificates available.")];
    }
    return awards.map((award) {
      return ListTile(
        title: Text(award["title"] ?? "Unknown Award"),
        subtitle: Text(
          "${award["date_or_year"] ?? ""}\n${award["description"] ?? ""}",
        ),
      );
    }).toList();
  }

  List<Widget> _buildProjectsList(List<dynamic>? projects) {
    if (projects == null || projects.isEmpty) {
      return [const Text("No projects available.")];
    }
    return projects.map((project) {
      return ListTile(
        title: Text(project["project_name"] ?? "Unknown Project"),
        subtitle: Text("${project["duration"] ?? ""}\n${project["description"] ?? ""}"),
      );
    }).toList();
  }

  List<Widget> _buildLanguagesList(List<dynamic>? languages) {
    if (languages == null || languages.isEmpty) {
      return [const Text("No languages available.")];
    }
    return languages.map((lang) {
      return ListTile(
        title: Text(lang["language"] ?? "Unknown Language"),
        subtitle: Text("Level: ${lang["level"] ?? "Unknown"}"),
      );
    }).toList();
  }
}
