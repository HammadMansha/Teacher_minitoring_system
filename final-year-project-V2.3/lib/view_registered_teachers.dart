import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyear/constants/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'color_utils.dart';
import 'common_textstyle/common_text_style.dart';
import 'controllers/view_courses_controller.dart';
import 'controllers/view_teachers_controller.dart';

class ViewRegisteredTeachers extends StatelessWidget {
  const ViewRegisteredTeachers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "View Users",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: bodyData(context),
    );
  }

  bodyData(context) {
    return GetBuilder<ViewRegisteredUsersController>(
        init: ViewRegisteredUsersController(),
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
                    // Access fields in the document using data['field_name']
                    return Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: Get.height / 4.5,
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
                                "Name : ${data['name'].toString()}",
                                style: CommonTextStyle.font15weight700D9D9,
                              ),
                              Text(
                                'ID : ${data['Id'].toString()}',
                                style: CommonTextStyle.font15weight700D9D9,
                              ),
                              Text(
                                'Email : ${data['email'].toString()}',
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                                style: CommonTextStyle.font15weight700D9D9,
                              ),
                              Text(
                                'Department : ${data['department'].toString()}',
                                style: CommonTextStyle.font15weight700D9D9,
                              ),
                              Text(
                                'Specialization : ${data['specialization'].toString()}',
                                style: CommonTextStyle.font15weight700D9D9,
                              ),
                              Text(
                                'Role : ${data['role'].toString()}',
                                style: CommonTextStyle.font15weight700D9D9,
                              ),
                            ],
                          ).marginOnly(top: 20, left: 20),
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
}
