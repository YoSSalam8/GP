import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data'; // For Uint8List
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:file_picker/file_picker.dart';

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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  File? _selectedFile;
  String? _fileName;
  Uint8List? _fileBytes; // For storing file bytes on web

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
          _fileBytes = result.files.single.bytes; // Use bytes for web
        } else {
          _selectedFile = File(result.files.single.path!); // Use file path for non-web
        }
      });
    }
  }

  // Method to submit the form
  void _submitCV() {
    if (_nameController.text.isEmpty ||
        _positionController.text.isEmpty ||
        (_selectedFile == null && _fileBytes == null)) {
      _showSnackbar("Please fill all the fields and upload the CV.");
      return;
    }

    // Logic for submitting the CV data (e.g., sending it to a server)
    _showSnackbar("CV '${_fileName ?? ''}' submitted successfully!");
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
    final bool isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add CV"),
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
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isWeb ? 500 : double.infinity),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Field
                    const Text(
                      "Candidate's Name",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "Enter the candidate's name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Job Position Field
                    const Text(
                      "Job Position",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _positionController,
                      decoration: InputDecoration(
                        hintText: "Enter the job position",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Upload CV Button
                    const Text(
                      "Upload CV",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _pickFile,
                            icon: const Icon(Icons.upload_file),
                            label: const Text("Upload CV"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF133E87),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_fileName != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Selected File: $_fileName",
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(height: 32),

                    // Submit Button
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitCV,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 32,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Submit CV",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
