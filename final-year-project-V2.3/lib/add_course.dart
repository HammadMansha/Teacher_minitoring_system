import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyear/common_buttons/common_button.dart';
import 'package:finalyear/common_textfields/commn_textfield.dart';
import 'package:finalyear/constants/app_colors/app_colors.dart';
import 'package:finalyear/controllers/add_course_controller.dart';
import 'package:finalyear/reusable_widget.dart';
import 'package:finalyear/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'color_utils.dart';
import 'common_textstyle/common_text_style.dart';

class AddCourseScreen extends StatelessWidget with ValidateUserEmail {
  AddCourseScreen({super.key});

  final formKey = GlobalKey<FormState>();

  String? isEmptyField(String value) {
    if (value.isEmpty) {
      return "This field is required";
    } else {
      return null;
    }
  }

  //-----------------------Add data in firebase----------------

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('courses');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(

        elevation: 0,
        title: const Text(
          "Add Course",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
        body: SafeArea(
          child:         bodyData(context),

        )
    );
  }

  bodyData(BuildContext context) {
    return GetBuilder<AddCourseController>(
        init: AddCourseController(),
        builder: (_) {
          return Obx(() {
            return Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  hexStringToColor("CB2B93"),
                  hexStringToColor("9546C4"),
                  hexStringToColor("5E61F4")
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: _.isLoading.value == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                         const SizedBox(height: 70,),
                            CommonTextField(
                              hintText: "Course Name",
                              controller: _.courseName,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                return isEmptyField(value.toString());
                              },
                            ).marginOnly(top: 30),
                            CommonTextField(
                              hintText: "Course ID",
                              controller: _.courseId,
                              validator: (value) {
                                return isEmptyField(value.toString());
                              },
                              textInputAction: TextInputAction.next,
                            ).marginOnly(top: 10),
                            CommonTextField(
                              hintText: "Department Name",
                              controller: _.department,
                              validator: (value) {
                                return isEmptyField(value.toString());
                              },
                              textInputAction: TextInputAction.next,
                            ).marginOnly(top: 10),
                            CommonTextField(
                              hintText: "Semester",
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                return isEmptyField(value.toString());
                              },
                              controller: _.semester,
                              textInputAction: TextInputAction.next,
                            ).marginOnly(top: 10),
                           
                            CommonTextField(
                              hintText: "Teacher Name",
                              controller: _.teacherName,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                return isEmptyField(value.toString());
                              },
                            ).marginOnly(top: 10),
                            CommonTextField(
                              hintText: "Teacher ID",
                              controller: _.teacherID,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                return isEmptyField(value.toString());
                              },
                            ).marginOnly(top: 10),

                             CommonTextField(
                              hintText: "Course Hours",
                              controller: _.courseHours,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                return isEmptyField(value.toString());
                              },
                            ).marginOnly(top: 10),


                            CommonTextField(
                              hintText: "Start Time(24 Hours format)",
                              controller: _.startTime,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                return isEmptyField(value.toString());
                              },
                            ).marginOnly(top: 10),


                            CommonTextField(
                              hintText: "End Time(24 Hours format)",
                              controller: _.endTime,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                return isEmptyField(value.toString());
                              },
                            ).marginOnly(top: 10),

                            CommonTextField(
                              hintText: "Days Name",
                              controller: _.weekDaysName,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                return isEmptyField(value.toString());
                              },
                            ).marginOnly(top: 10),


                            CommonTextField(
                              hintText: "Room Number",
                              controller: _.roomNumber,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                return isEmptyField(value.toString());
                              },
                            ).marginOnly(top: 10),



                            firebaseUIButton(
                              context,
                              "Add Course",
                              () {
                                if (formKey.currentState!.validate()) {
                                  _.isLoading.value = true;
                                  collectionReference.add({
                                    'course_Id': _.courseName.text,
                                    'course_name': _.courseName.text,
                                    'course_semester': _.semester.text,
                                    'department_Name': _.department.text,
                                    'teacher_name': _.teacherName.text,
                                    'teacher_Id': _.teacherID.text,
                                     'course_hours': _.courseHours.text,
                                    'start_time': _.startTime.text,
                                    'room_number':_.roomNumber.text,
                                    'end_time':_.endTime.text,
                                    'week_days':_.weekDaysName.text,


                                    // Add other fields and their values
                                  }).then(
                                    (value) {
                                      print("Course data added successfully");
                                      _.courseName.clear();
                                      _.courseId.clear();
                                      _.department.clear();
                                      _.courseDuration.clear();
                                      _.semester.clear();
                                      _.courseHours.clear();

                                      Fluttertoast.showToast(
                                          msg: "Course has been added",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 3,
                                          textColor: Colors.green,
                                          fontSize: 16.0);
                                      _.isLoading.value = false;
                                      Navigator.pop(context);
                                    },
                                  ).onError((error, stackTrace) {
                                    print("Error ${error.toString()}");
                                    _.isLoading.value=false;
                                  });
                                }
                              },
                            ).marginOnly(top: 30, bottom: 30),
                          ],
                        ).marginSymmetric(horizontal: 15),
                     
                     
                     
                      ),
                    ),
            
            
            );
          });
        });
  }
}
