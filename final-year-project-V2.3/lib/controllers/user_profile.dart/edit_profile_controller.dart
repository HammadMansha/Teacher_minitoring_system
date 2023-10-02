import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyear/global_variables.dart';
import 'package:finalyear/home_screen.dart';
import 'package:finalyear/teacher_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

class EditProfileScreenController extends GetxController {
  PickedFile? imageFile;
  final storage = GetStorage();
  String uid = "";
  RxString pdfPath = ''.obs;
  var imgPath;
  TextEditingController name = TextEditingController();
  TextEditingController specialization = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController id = TextEditingController();
  RxBool isLoading = false.obs;
  String imageUrl = "";

  @override
  void onInit() async {
    uid = await storage.read("uid");
    name.text = GlobalVariables.name;
    specialization.text = GlobalVariables.specialization;
    department.text = GlobalVariables.department;
    id.text = GlobalVariables.id;

    //await getPDFUrl();

    // TODO: implement onInit
    super.onInit();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    imageFile = pickedImage;
    update();
  }

  Future<void> uploadImageToFirebase() async {
    if (imageFile != null) {
      isLoading.value = true;
      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('images/${uid}_profilepic.png');

        firebase_storage.UploadTask uploadTask =
            ref.putFile(File(imageFile!.path));

        await uploadTask.whenComplete(() {
          print('Image uploaded to Firebase');
        });

        imageUrl = await ref.getDownloadURL();
        print('Download URL: $imageUrl');

        Get.snackbar("Success", "Data update successfully");
        isLoading.value = false;
        Get.offAll(const teacher_class());
      } catch (e) {
        Get.snackbar("Error", "Error while uploading");

        print('Error uploading image to Firebase: $e');
        isLoading.value = false;
      }
    } else {
      isLoading.value = true;

      Get.snackbar("Error", "Please select image");
      print('No image selected.');
    }
  }

  Future<void> getPDFUrl() async {
    try {
      isLoading.value = true;
      String pdfUrlFirebase = await firebase_storage.FirebaseStorage.instance
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

//--------------------Update user data---------------------

  void updateValueInFirestore(Map<String, dynamic> valuesToUpdate) async {
    try {
      isLoading.value = true;
      // Get the current user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Get the reference to the user's document
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('teachers_info').doc(userId);

      // Update the specific key-value pair in the document
      await userRef.update(valuesToUpdate);

      print('Value updated successfully in Firestore.');

      Get.snackbar("Success", "Data update successfully");
      isLoading.value = false;
      Get.offAll(const teacher_class());
    } catch (e) {
      print('Error updating value in Firestore: $e');
    }
  }



}
