import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyear/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class ViewCourseController extends GetxController {
  final CollectionReference collectionReference =
   FirebaseFirestore.instance.collection('courses');
  Timer? timer;
  RxBool isConnected = false.obs;
    final formKey = GlobalKey<FormState>();
  TextEditingController courseName = TextEditingController();
  TextEditingController courseId = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController courseDuration = TextEditingController();
  TextEditingController semester = TextEditingController();
  TextEditingController teacherName = TextEditingController();
  TextEditingController teacherID = TextEditingController();
  TextEditingController courseHours = TextEditingController();

  RxBool isLoading = false.obs;
    final storage = GetStorage();


  Future<void> deleteDocumentByCourseID(String courseId) async {
    try {
      // Query the collection to get documents where "courseID" field matches the value
      QuerySnapshot querySnapshot = await collectionReference
          .where('course_Id', isEqualTo: courseId)
          .get();

      // Delete each document found in the query result
      querySnapshot.docs.forEach((doc) async {
        await doc.reference.delete();
      });

      print('Documents with courseID: $courseId deleted successfully.');
    } catch (e) {
      print('Error deleting documents: $e');
    }
  }

  void startTimer() {
    // Start the timer that will run the API request every 30 seconds
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      print(" check connection status-----${GlobalVariables.deviceConnection}");

      if (GlobalVariables.deviceConnection == true) {
        isConnected.value = true;
      } else {
        isConnected.value = false;
      }
    });
  }




  @override
  void onInit() async{
  
    // startTimer();
    // TODO: implement onInit
    if(GlobalVariables.totalDuration==null){

        String? storedTotalDurationInMillis = await storage.read("teacherTime");

            GlobalVariables.totalDuration = int.parse(storedTotalDurationInMillis!);


    }
    super.onInit();
  }




  Future<void> updateCourseInformation(String courseId,Map<String, dynamic> valuesToUpdate) async {
    try {
      isLoading.value=true;
      QuerySnapshot querySnapshot =
          await collectionReference.where('courseId', isEqualTo: courseId).get();


      if (querySnapshot.size == 1) {
        // Assuming there's exactly one course with the given courseId
        DocumentSnapshot courseSnapshot = querySnapshot.docs.first;

        await courseSnapshot.reference.update(valuesToUpdate);

        print('Course information updated successfully.');
        isLoading.value=false;
      } else {
        print('No course found with the given courseId.');
                isLoading.value=false;

      }
    } catch (error) {
      print('Error updating course information: $error');
              isLoading.value=false;

    }
  }


  String? isEmptyField(String value) {
    if (value.isEmpty) {
      return "This field is required";
    } else {
      return null;
    }
  }
}
