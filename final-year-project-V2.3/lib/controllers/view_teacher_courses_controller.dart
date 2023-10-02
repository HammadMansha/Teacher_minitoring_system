import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global_variables.dart';

class ViewTeacherCoursesController extends GetxController {
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('courses');

  RxBool isConnected = false.obs;
  Timer? timer;


  @override
  void onInit() {
    // TODO: implement onInit
    startTimer();

    super.onInit();
  }

  void startTimer() {
    // Start the timer that will run the API request every 30 seconds
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      print(" check connection status-----${GlobalVariables.deviceConnection}");

      if (GlobalVariables.deviceConnection == true) {
        isConnected.value = true;
      } else {
        isConnected.value = false;
      }
    });
  }
}
