import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AnnouncementScreenController extends GetxController {
  TextEditingController announcement = TextEditingController();
  TextEditingController title = TextEditingController();

  final formKey = GlobalKey<FormState>();
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('announcements');
  RxBool isLoading = false.obs;

  String? isEmptyField(String value) {
    if (value.isEmpty) {
      return "This field is required";
    } else {
      return null;
    }
  }

  Future<void> addAnnouncement() async {
    isLoading.value = true;
    collectionReference.add({
      // Add other fields and their values
      "date_time": DateTime.now().toString(),
      "message": announcement.text,
      "title": title.text,
    }).then((value) {
      print("Announcement added successfully");

      Fluttertoast.showToast(
          msg: "Annuncement has been added",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          textColor: Colors.green,
          fontSize: 16.0);
      Get.back();
      isLoading.value = false;
    }).onError((error, stackTrace) {
      print("Error ${error.toString()}");
    });
  }
}
