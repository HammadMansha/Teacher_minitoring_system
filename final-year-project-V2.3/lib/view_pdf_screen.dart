import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'controllers/pdf_view_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PdfViewScreen extends StatelessWidget {
  final String pdfFileName;

  PdfViewScreen(this.pdfFileName);

  @override
  Widget build(BuildContext context) {
    final PdfViewController pdfViewController = Get.put(PdfViewController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Time table View'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<String?>(
        future: pdfViewController.getPDFUrl("timetable.pdf"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            print("snapshot data--------------${snapshot.data}");
            return PDFView(
              filePath: snapshot.data!.toString(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading PDF'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
