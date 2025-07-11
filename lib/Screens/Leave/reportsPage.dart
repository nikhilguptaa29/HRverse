import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrverse/Utils/Widgets/myButton.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  Future<pw.Document> _createPDF() async {
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
                  mainAxisAlignment: pw.MainAxisAlignment.end,
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
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Divider(thickness: 1.5,color: PdfColor(0,0, 0)),
                pw.SizedBox(height: 20),
                pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Name: Nikhil Gupta'),
              pw.Text('Employee ID: EMP1025'),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Designation: Flutter Developer'),
              pw.Text('PAN: ABCDE1234F'),
            ],
          ),
          pw.SizedBox(height: 10),

          // Salary Section
          pw.Text('Earnings:',
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, fontSize: 16)),
          pw.Table.fromTextArray(
            headers: ['Component', 'Amount (₹)'],
            data: [
              ['Basic Pay', '25,000'],
              ['HRA', '10,000'],
              ['Special Allowance', '5,000'],
              ['Incentive', '3,000'],
            ],
          ),
          pw.SizedBox(height: 10),
              ],
            ),
      ),
    );
    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyButton(btnTxt: 'Create PDF'),
            Expanded(
              child: PdfPreview(
                build: (_) => _createPDF().then((value) => value.save()),
              ),
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
