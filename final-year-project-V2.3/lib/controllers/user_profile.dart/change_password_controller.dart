import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  RxBool isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  String? isEmptyField(String value) {
    if (value.isEmpty) {
      return "This field is required";
    } else {
      return null;
    }
  }

  void changePassword(String newPassword) async {
    try {
      isLoading.value = true;
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updatePassword(newPassword);
        print('Password changed successfully.');
        isLoading.value = false;
        Get.back();

        Get.snackbar("Success", "Password changed successfully");
      } else {
        isLoading.value = false;

        print('No user is currently signed in.');
        Get.snackbar("Warning", "No user is currently signed in");
      }
    } catch (e) {
      isLoading.value = false;

      print('Error changing password: $e');
      Get.snackbar("Warning", "$e");
    }
  }
}
