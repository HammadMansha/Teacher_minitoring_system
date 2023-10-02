import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyear/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'color_utils.dart';
import 'common_textfields/commn_textfield.dart';
import 'common_textstyle/common_text_style.dart';
import 'constants/app_colors/app_colors.dart';
import 'controllers/view_courses_controller.dart';
import 'global_variables.dart';

class ViewCoursesScreen extends StatelessWidget {
  const ViewCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "View Courses",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: bodyData(context),
    );
  }

  bodyData(context) {
    return GetBuilder<ViewCourseController>(
        init: ViewCourseController(),
        builder: (_) {
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
            child: StreamBuilder<QuerySnapshot>(
              stream: _.collectionReference.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Data is ready
                final documents = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final data =
                        documents[index].data() as Map<String, dynamic>;
                        _.courseName.text=data['course_name'].toString();
                        _.courseId.text=data['course_Id'].toString();
                        _.department.text=data['department_Name'].toString();
                        _.semester.text=data['course_semester'].toString();
                        _.teacherName.text=data['teacher_name'].toString();
                        _.teacherID.text=data['teacher_Id'].toString();
                        _.courseHours.text=data['course_hours'].toString();
                        _.courseDuration.text=data['course_duration'].toString();
                    // Access fields in the document using data['field_name']
                    return Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onDoubleTap: () {
                            editCourseBottomSheet(_, context);
                          },
                          child: Container(
                            height: Get.height / 3.8,
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.alertCardColor,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Course Name : ${data['course_name'].toString()}",
                                  style: CommonTextStyle.font15weight700D9D9,
                                ),
                                Text(
                                  'Course ID : ${data['course_Id'].toString()}',
                                  style: CommonTextStyle.font15weight700D9D9,
                                  
                                ),
                                Text(
                                  'Department : ${data['department_Name'].toString()}',
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                  style: CommonTextStyle.font15weight700D9D9,
                                ),
                                Text(
                                  'Semester : ${data['course_semester'].toString()}',
                                  style: CommonTextStyle.font15weight700D9D9,
                                ),
                                Text(
                                  'Teacher Name : ${data['teacher_name'].toString()}',
                                  style: CommonTextStyle.font15weight700D9D9,
                                ),
                                Text(
                                  'Teacher ID : ${data['teacher_Id'].toString()}',
                                  style: CommonTextStyle.font15weight700D9D9,
                                ),
                                Obx(() {
                                  return Text(
                                    'ESP32 Connection Status : ${_.isConnected.value}',
                                    style: CommonTextStyle.font15weight700D9D9,
                                  );
                                }),
                                Text(
                                  'Complete Hours : ${GlobalVariables.totalDuration ?? ""}',
                                  style: CommonTextStyle.font15weight700D9D9,
                                ),
                                Text(
                                  'Total Hours : 48 Hours',
                                  style: CommonTextStyle.font15weight700D9D9,
                                ),
                              ],
                            ).marginOnly(top: 20, left: 20),
                          ),
                        
                        
                        
                        ),
                      ],
                    ).marginSymmetric(horizontal: 20);
                  },
                );
              },
            ),
          );
        });
  }

  void editCourseBottomSheet(ViewCourseController _, BuildContext context) {
    Get.bottomSheet(
      Obx((){
        return  Container(
        height: Get.height /1.3,
        color: Colors.deepPurpleAccent,
        width: Get.width,
        child: _.isLoading.value==true?const Center(child: CircularProgressIndicator(),):
        SingleChildScrollView(
          child: Form(
            key: _.formKey,
            child: Column(
              children: [
                Text(
                  "Update Course",
                  style: CommonTextStyle.font24weight500WhiteRoboto,
                ).marginOnly(top: 50),
                CommonTextField(
                  hintText: "Course Name",
                  controller: _.courseName,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return _.isEmptyField(value.toString());
                  },
                ).marginOnly(top: 30),
                CommonTextField(
                  hintText: "Course ID",
                  controller: _.courseId,
                  readOnly: true,
                  validator: (value) {
                    return _.isEmptyField(value.toString());
                  },
                  textInputAction: TextInputAction.next,
                ).marginOnly(top: 10),
                CommonTextField(
                  hintText: "Department Name",
                  controller: _.department,
                  validator: (value) {
                    return _.isEmptyField(value.toString());
                  },
                  textInputAction: TextInputAction.next,
                ).marginOnly(top: 10),
                CommonTextField(
                  hintText: "Course Duration",
                  controller: _.courseDuration,
                  validator: (value) {
                    return _.isEmptyField(value.toString());
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                ).marginOnly(top: 10),
                CommonTextField(
                  hintText: "Semester",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    return _.isEmptyField(value.toString());
                  },
                  controller: _.semester,
                  textInputAction: TextInputAction.next,
                ).marginOnly(top: 10),
               
                CommonTextField(
                  hintText: "Teacher Name",
                  controller: _.teacherName,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return _.isEmptyField(value.toString());
                  },
                ).marginOnly(top: 10),
                CommonTextField(
                  hintText: "Teacher ID",
                  controller: _.teacherID,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return _.isEmptyField(value.toString());
                  },
                ).marginOnly(top: 10),
                CommonTextField(
                  hintText: "Coursr Hours",
                  controller: _.courseHours,
                  keyboardType:TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    return _.isEmptyField(value.toString());
                  },
                ).marginOnly(top: 10),
                firebaseUIButton(
                  context,
                  "Update Course",
                  () {
                    if (_.formKey.currentState!.validate()) {
                      _.isLoading.value = true;

                      _.updateCourseInformation(_.courseId.text,
                      
                      {
                         'course_Id': _.courseId.text,
                        'course_duration': _.courseDuration.text,
                        'course_name': _.courseName.text,
                        'course_semester': _.semester.text,
                        'department_Name': _.department.text,
                        'teacher_name': _.teacherName.text,
                        'teacher_Id': _.teacherID.text,
                        'date_time': DateTime.now().toString(),
                        'course_hours':_.courseHours.text,
                      }
                      ).then((value){

                        
                          Get.snackbar("Success", "Course information updated successfully");
                          _.isLoading.value = false;
                          Navigator.pop(context);



                      }).onError((error, stackTrace) {
                        print("Error ${error.toString()}");
                                                  Get.snackbar("Warning", "$error");

                      });


                    }
                  },
                ).marginOnly(top: 30, bottom: 30),
              ],
            ).marginSymmetric(horizontal: 15),
          ),
        ),
      );

      })


    );
     
     
  }
}
