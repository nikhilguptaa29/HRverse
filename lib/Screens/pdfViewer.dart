import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatelessWidget {
  final File file;
  const PdfViewer({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: SfPdfViewer.file(file)));
  }
}
