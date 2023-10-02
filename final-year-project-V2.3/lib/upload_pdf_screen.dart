// upload_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/upload_pdf_controller.dart';

class UploadScreen extends StatelessWidget {
  final PdfUploadController pdfUploadController =
      Get.put(PdfUploadController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Upload Material'),
      ),
      body: Obx(() {
        return pdfUploadController.isLoading.value == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: ElevatedButton(
                  onPressed: () {
                    pdfUploadController.pickAndUploadPdf();
                  },
                  child: Text('Upload PDF'),
                ),
              );
      }),
    );
  }
}
