import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrverse/Screens/pdfViewer.dart';
import 'package:hrverse/Utils/Widgets/myButton.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  Future<File> _createPDF() async {
    final pdf = pw.Document();
    final image = await rootBundle.load('Assets/Images/logo.png');
    final logo = pw.MemoryImage(image.buffer.asUint8List());
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build:
            (context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    // pw.Text(
                    //   "Avitech Nutrition",
                    //   style: pw.TextStyle(
                    //     fontSize: 35,
                    //     fontWeight: pw.FontWeight.bold,
                    //   ),
                    // ),
                    pw.Image(logo, width: 140),
                  ],
                ),
                pw.SizedBox(height: 40),
                pw.Center(
                  child: pw.Text(
                    "Employee PaySlip - July 2025",
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 15),
                pw.Divider(thickness: 1.5, color: PdfColors.blue400),
                pw.SizedBox(height: 20),
                pw.Padding(
                  padding: pw.EdgeInsets.only(top: 20, bottom: 3),
                  child: pw.Column(
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.only(top: 5, bottom: 2),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Name : Nikhil "),
                            pw.Text("Designation : Software Engineer "),
                          ],
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.only(bottom: 2),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Paid Days : 30.00 "),
                            pw.Text("UAN No :  "),
                          ],
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.only(bottom: 2),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("DOJ : 29/05/2023 "),
                            pw.Text("ESIC No :  "),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // Salary Section
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Earnings:',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 15),
                pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColors.black,
                    width: 1.5,
                  ),
                  columnWidths: {
                    0: pw.FixedColumnWidth(1),
                    1: pw.FixedColumnWidth(1),
                  },
                  children: [
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.grey100),
                      children: [
                        pw.Center(
                          child: pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child: pw.Text(
                              'Component',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        pw.Center(
                          child: pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child: pw.Text(
                              'Amount',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...[
                      ['Basic Pay', '20,000'],
                      ['HRA', '5,000'],
                      ['Special Allowance', '3,000'],
                    ].map(
                      (item) => pw.TableRow(
                        children: [
                          pw.Center(
                            child: pw.Padding(
                              padding: pw.EdgeInsets.all(10),
                              child: pw.Text(item[0]),
                            ),
                          ),
                          pw.Center(
                            child: pw.Padding(
                              padding: pw.EdgeInsets.all(10),
                              child: pw.Text(item[1]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 10),
              ],
            ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/demo.pdf");

    await file.writeAsBytes(await pdf.save());
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyButton(
              btnTxt: 'Create PDF',
              func: () async {
                File pdfFile = await _createPDF();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfViewer(file: pdfFile),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      // body: Center(
      //   child: Text.rich(
      //     TextSpan(
      //       children: [
      //         TextSpan(
      //           text: "Hr",
      //           style: TextStyle(
      //             fontSize: 35,
      //             fontWeight: FontWeight.bold,
      //             foreground:
      //                 Paint()
      //                   ..shader = LinearGradient(
      //                     colors: [Colors.blue, Colors.purple],
      //                   ).createShader(Rect.fromLTWH(70, 0, 200, 70)),
      //           ),
      //         ),
      //         TextSpan(
      //           text: "Verse",
      //           style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold,
      //           foreground:
      //             Paint()
      //               ..shader = LinearGradient(
      //                 colors: [Colors.blue, Colors.purple],
      //               ).createShader(Rect.fromLTWH(70, 0, 200, 70)),),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
