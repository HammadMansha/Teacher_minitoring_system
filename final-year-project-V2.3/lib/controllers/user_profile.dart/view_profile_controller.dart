import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyear/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

class ViewProfileScreenController extends GetxController {
  PickedFile? imageFile;
  final storage = GetStorage();
  String uid = "";
  RxString pdfPath = ''.obs;
  late File imgPath;
  TextEditingController name = TextEditingController();
  TextEditingController specialization = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController role = TextEditingController();

  RxBool isLoading = false.obs;
  String pdfUrlFirebase = "";

  @override
  void onInit() async {
    uid = await storage.read("uid");
    name.text = GlobalVariables.name;
    specialization.text = GlobalVariables.specialization;
    department.text = GlobalVariables.department;
    id.text = GlobalVariables.id;
    role.text = GlobalVariables.userRole;
    email.text = GlobalVariables.email;
    await getPDFUrl();

    // TODO: implement onInit
    super.onInit();
  }

  Future<void> getPDFUrl() async {
    try {
      isLoading.value = true;
      pdfUrlFirebase = await firebase_storage.FirebaseStorage.instance
          .ref('images/${uid}_profilepic.png')
          .getDownloadURL();
      print("downloaded url------------$pdfUrlFirebase");

      isLoading.value = false;

      // No need to return anything in this function.
    } catch (e) {
            isLoading.value = false;

      print('Error downloading PDF from Firebase: $e');
    }
  }
}
