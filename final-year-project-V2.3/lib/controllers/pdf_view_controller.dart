import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PdfViewController extends GetxController {
  RxString pdfPath = ''.obs;
  Future<String> getPDFUrl(String fileName) async {
    try {
      String pdfUrlFirebase = await firebase_storage.FirebaseStorage.instance
          .ref('pdfs/$fileName')
          .getDownloadURL();
      print("downloaded url------------$pdfUrlFirebase");

      await downloadAndSavePdf(pdfUrlFirebase);

      return pdfPath.value;
    } catch (e) {
      print('Error downloading PDF from Firebase: $e');
      return '';
    }
  }

  Future<void> downloadAndSavePdf(String pdfUrl) async {
    try {
      http.Response response = await http.get(Uri.parse(pdfUrl));
      Uint8List bytes = response.bodyBytes;
      String dir = (await getTemporaryDirectory()).path;
      String pdfPathValue = '$dir/sample.pdf';
      File pdfFile = File(pdfPathValue);
      await pdfFile.writeAsBytes(bytes);
      pdfPath.value = pdfPathValue;
    } catch (e) {
      print('Error downloading PDF: $e');
    }
  }
}
