import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyear/common_snackbar/common_snackbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AddCourseController extends GetxController {
  TextEditingController courseName = TextEditingController();
  TextEditingController courseId = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController courseDuration = TextEditingController();
  TextEditingController courseAdvisor = TextEditingController();
  TextEditingController semester = TextEditingController();
  TextEditingController teacherName = TextEditingController();
  TextEditingController teacherID = TextEditingController();
  TextEditingController courseHours=TextEditingController();
  TextEditingController roomNumber=TextEditingController();
  TextEditingController startTime=TextEditingController();
  TextEditingController endTime=TextEditingController();
  TextEditingController weekDaysName=TextEditingController();
  RxBool isLoading = false.obs;
}
