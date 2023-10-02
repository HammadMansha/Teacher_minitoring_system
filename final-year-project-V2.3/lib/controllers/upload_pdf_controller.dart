import 'dart:io';
import 'dart:typed_data'; // Import 'dart:typed_data' for Uint8List
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PdfUploadController extends GetxController {
  RxString pdfFilePath = ''.obs;
  RxBool isLoading = false.obs;

  Future<void> pickAndUploadPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      pdfFilePath.value = file.path!;
      await uploadPdfToFirebase(file);
    }
  }

  Future<void> uploadPdfToFirebase(PlatformFile file) async {
    isLoading.value = true;

    if (file.path != null) {
      String fileName = 'timetable.pdf';
      try {
        File pdfFile = File(file.path!);
        List<int> fileBytes = await pdfFile.readAsBytes();
        Uint8List uint8List =
            Uint8List.fromList(fileBytes); // Convert to Uint8List
        await firebase_storage.FirebaseStorage.instance
            .ref('pdfs/$fileName')
            .putData(uint8List); // Use Uint8List
        Get.snackbar('Success', 'PDF Uploaded Successfully');
        isLoading.value = false;
      } catch (e) {
        isLoading.value = false;

        print('Error uploading PDF to Firebase: $e');
        Get.snackbar('Error', 'Failed to Upload PDF');
      }
    } else {
      isLoading.value = false;

      Get.snackbar('Error', 'Invalid PDF File');
    }
  }
}
