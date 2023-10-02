import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyear/common_textstyle/common_text_style.dart';
import 'package:finalyear/global_variables.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'color_utils.dart';
import 'constants/app_colors/app_colors.dart';
import 'controllers/view_teacher_courses_controller.dart';

class ViewTeacherCourses extends StatelessWidget {
  const ViewTeacherCourses({super.key});

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
    return GetBuilder<ViewTeacherCoursesController>(
        init: ViewTeacherCoursesController(),
        builder: (_) {
          print(
              "teacher id is---------------------------${GlobalVariables.id}");
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
              stream: _.collectionReference
                  .where('teacher_Id', isEqualTo: GlobalVariables.id)
                  .snapshots(),
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

                print("docouments-------------------$documents");

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final data =
                        documents[index].data() as Map<String, dynamic>;
                    // Access fields in the document using data['field_name']
                    return  Column(
                      children: [
                          const SizedBox(
                          height: 30,
                        ),
                        Container(
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
                                   
                                    Text(
                                      'Complete Hours : ${GlobalVariables.totalDuration ?? ""}',
                                      style: CommonTextStyle.font15weight700D9D9,
                                    ),
                                    Text(
                                      'Total Hours : 48 Hours',
                                      style: CommonTextStyle.font15weight700D9D9,
                                    ),

                                    Text(
                                      'Start Time : ${data['start_time'].toString()}',
                                      style: CommonTextStyle.font15weight700D9D9,
                                    ),
                                    Text(
                                      'End Time : ${data['end_time'].toString()}',
                                      style: CommonTextStyle.font15weight700D9D9,
                                    ),
                                    Text(
                                      'Days: ${data['week_days'].toString()}',
                                      style: CommonTextStyle.font15weight700D9D9,
                                    ),
                                    Text(
                                      'Room Number : ${data['room_number'].toString()}',
                                      style: CommonTextStyle.font15weight700D9D9,
                                    ),
                                    Obx(() {
                                      return Text(
                                        'ESP32 Connection Status : ${_.isConnected.value}',
                                        style: CommonTextStyle.font15weight700D9D9,
                                      );
                                    }),
                                  ],
                                ).marginOnly(top: 20, left: 20),
                              ),
                      ],
                    ).marginSymmetric(horizontal: 10);
                        
                        
                  
                  },
                );
              },
            ),
          );
        });
  }
}
