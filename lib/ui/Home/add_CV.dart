import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCVScreen extends StatefulWidget {
  final String companyId;
  final String employeeId;
  final String employeeEmail;
  final String token;

  const AddCVScreen({
    Key? key,
    required this.companyId,
    required this.employeeId,
    required this.employeeEmail,
    required this.token,
  }) : super(key: key);

  @override
  State<AddCVScreen> createState() => _AddCVScreenState();
}

class _AddCVScreenState extends State<AddCVScreen> {
  final TextEditingController _candidateNameController = TextEditingController();
  final TextEditingController _candidateEmailController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();

  final TextEditingController _positionNameController = TextEditingController();
  final TextEditingController _positionDescriptionController = TextEditingController();
  final TextEditingController _requirementController = TextEditingController();
  List<String> _requirements = [];

  File? _selectedFile;
  String? _fileName;
  Uint8List? _fileBytes;

  List<Map<String, dynamic>> _jobPositions = []; // Stores position details
  int? _selectedJobPositionId; // Stores selected job position ID


  @override
  void initState() {
    super.initState();
    _fetchJobPositions(); // Fetch job positions when the page loads
  }

  Future<void> _fetchJobPositions() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:8080/api/positions/company/${widget.companyId}"),
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _jobPositions = data.map<Map<String, dynamic>>((position) => position).toList();
          if (_jobPositions.isNotEmpty) {
            _selectedJobPositionId = _jobPositions[0]["id"];
          }
        });
      } else {
        _showSnackbar("Failed to load job positions.");
      }
    } catch (e) {
      _showSnackbar("Error fetching positions: $e");
    }
  }
  // Method to pick a file
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
        if (kIsWeb) {
          _fileBytes = result.files.single.bytes;
        } else {
          _selectedFile = File(result.files.single.path!);
        }
      });
    }
  }

  // Method to submit CV
  Future<void> _submitCV() async {
    if (_candidateNameController.text.isEmpty ||
        _candidateEmailController.text.isEmpty ||
        _selectedJobPositionId == null ||
        (_selectedFile == null && _fileBytes == null)) {
      _showSnackbar("Please fill all fields and upload the CV.");
      return;
    }

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("http://localhost:8080/api/resumes/upload"),
      );

      request.headers["Authorization"] = "Bearer ${widget.token}";

      // Add fields to request
      request.fields["candidateName"] = _candidateNameController.text;
      request.fields["candidateEmail"] = _candidateEmailController.text;
      request.fields["positionId"] = _selectedJobPositionId.toString();

      // Add file
      if (!kIsWeb) {
        request.files.add(await http.MultipartFile.fromPath("file", _selectedFile!.path));
      } else {
        request.files.add(http.MultipartFile.fromBytes(
          "file",
          _fileBytes!,
          filename: _fileName,
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessDialog("CV Submitted", "The CV has been submitted successfully!");
        _candidateNameController.clear();
        _candidateEmailController.clear();
        setState(() {
          _fileName = null;
          _selectedFile = null;
          _fileBytes = null;
        });
      } else {
        _showSnackbar("Failed to submit CV. Status: ${response.statusCode}");
      }
    } catch (e) {
      _showSnackbar("Error: $e");
    }
  }


  // Method to add a Position
  Future<void> _addPosition() async {
    if (_positionNameController.text.isEmpty || _positionDescriptionController.text.isEmpty || _requirements.isEmpty) {
      _showSnackbar("Please fill all position details and add at least one requirement.");
      return;
    }

    final Map<String, dynamic> requestBody = {
      "title": _positionNameController.text,
      "description": _positionDescriptionController.text,
      "requirements": _requirements,
      "createdById": {
        "id": int.parse(widget.employeeId),
        "email": widget.employeeEmail
      },
      "createdByEmail": widget.employeeEmail,
      "companyId": int.parse(widget.companyId),
    };

    try {
      final response = await http.post(
        Uri.parse("http://localhost:8080/api/positions/create"),
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessDialog("Position Added", "The new job position has been created successfully!");
        _positionNameController.clear();
        _positionDescriptionController.clear();
        setState(() {
          _requirements.clear();
        });
      } else {
        _showSnackbar("Failed to add position. Status: ${response.statusCode}");
      }
    } catch (e) {
      _showSnackbar("Error: $e");
    }
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK", style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }


  // Snackbar for showing messages
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
    final bool isWideScreen = MediaQuery.of(context).size.width > 850;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add CV & Position", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF133E87),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFCBDCEB), Color(0xFF608BC1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: isWideScreen
              ? _buildWideLayout() // Desktop / Tablet Layout
              : _buildNarrowLayout(), // Mobile Layout
        ),
      ),
    );
  }

  // Layout for wide screens (desktop/tablets)
  Widget _buildWideLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: _buildAddCVSection()),
        const SizedBox(width: 20),
        Expanded(child: _buildAddPositionSection()),
      ],
    );
  }

  // Layout for narrow screens (mobile)
  Widget _buildNarrowLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildAddCVSection(),
          const SizedBox(height: 20),
          _buildAddPositionSection(),
        ],
      ),
    );
  }

  // Add CV Section
  Widget _buildAddCVSection() {
    return _buildCard(
      title: "Add CV",
      content: Column(
        children: [
          _buildTextField(_candidateNameController, "Candidate's Name", Icons.person),
          const SizedBox(height: 12),
          _buildTextField(_candidateEmailController, "Candidate's Email", Icons.email),
          const SizedBox(height: 12),

          // Job Position Dropdown
          DropdownButtonFormField<int>(
            decoration: InputDecoration(
              labelText: "Job Position",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            value: _selectedJobPositionId,
            items: _jobPositions.map((position) {
              return DropdownMenuItem<int>(
                value: position["id"],
                child: Text(position["title"]),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedJobPositionId = value!;
              });
            },
          ),
          const SizedBox(height: 16),

          // Upload CV
          ElevatedButton.icon(
            onPressed: _pickFile,
            icon: const Icon(Icons.upload_file),
            label: const Text("Upload CV"),
            style: _buttonStyle(),
          ),

          if (_fileName != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text("Selected File: $_fileName", style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black87)),
            ),
          const SizedBox(height: 16),

          Center(
            child: ElevatedButton(
              onPressed: _submitCV,
              style: _buttonStyle().copyWith(backgroundColor: MaterialStateProperty.all(Colors.green)),
              child: const Text("Submit CV", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // Add Position Section
  Widget _buildAddPositionSection() {
    return _buildCard(
      title: "Add Position",
      content: Column(
        children: [
          _buildTextField(_positionNameController, "Position Name", Icons.work_outline),
          const SizedBox(height: 12),
          _buildTextField(_positionDescriptionController, "Position Description", Icons.description),
          const SizedBox(height: 12),

          // Add requirements dynamically
          Row(
            children: [
              Expanded(child: _buildTextField(_requirementController, "Requirement", Icons.add)),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.blue),
                onPressed: () {
                  setState(() {
                    _requirements.add(_requirementController.text);
                    _requirementController.clear();
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          ..._requirements.map((req) => ListTile(title: Text(req))).toList(),
          const SizedBox(height: 16),

          Center(
            child: ElevatedButton(
              onPressed: _addPosition,
              style: _buttonStyle().copyWith(backgroundColor: MaterialStateProperty.all(Colors.orange)),
              child: const Text("Add Position", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Card Layout
  Widget _buildCard({required String title, required Widget content}) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
            const Divider(),
            const SizedBox(height: 10),
            content,
          ],
        ),
      ),
    );
  }

  // Reusable TextField Widget
  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: Icon(icon, color: Colors.blueGrey),
      ),
    );
  }

  // Button Style
  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
