import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewerScreen extends StatefulWidget {
  final String base64String;

  const PdfViewerScreen({Key? key, required this.base64String}) : super(key: key);

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PdfControllerPinch pdfController;

  @override
  void initState() {
    super.initState();

    // Decode Base64 string to Uint8List
    Uint8List pdfData = base64Decode(widget.base64String);

    // Initialize pdfController with the decoded PDF data
    pdfController = PdfControllerPinch(
      document: PdfDocument.openData(pdfData),
    );
  }

  @override
  void dispose() {
    pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View CV")),
      body: PdfViewPinch(controller: pdfController), // Display PDF using pdfx
    );
  }
}
