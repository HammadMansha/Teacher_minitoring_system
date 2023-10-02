import 'package:finalyear/global_variables.dart';
import 'package:finalyear/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../color_utils.dart';
import '../common_textstyle/common_text_style.dart';
import '../constants/app_colors/app_colors.dart';
import '../controllers/user_profile.dart/edit_profile_controller.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyData(context),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  bodyData(BuildContext context) {
    return GetBuilder<EditProfileScreenController>(
        init: EditProfileScreenController(),
        builder: (_) {
          return Obx(() {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  hexStringToColor("CB2B93"),
                  hexStringToColor("9546C4"),
                  hexStringToColor("5E61F4")
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: _.isLoading.value == true
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await _.pickImage();
                            },
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: AppColors.circle4a4a,
                              backgroundImage: _.imageFile != null
                                  ? FileImage(File(_.imageFile!.path))
                                  : null,
                              child: _.imageFile == null
                                  ? Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        "Edit",
                                        style: CommonTextStyle
                                            .font14weight400White,
                                      ).marginOnly(bottom: 12),
                                    )
                                  : null,
                            ).marginOnly(bottom: 20, top: 23),
                          ),
                          reusableTextField(
                              "Name", Icons.person, false, _.name),
                          const SizedBox(height: 10),
                          reusableTextField(
                              "Department", Icons.person, false, _.department),
                          const SizedBox(height: 10),
                          reusableTextField("Specialization", Icons.person,
                              false, _.specialization),
                          const SizedBox(height: 20),
                          firebaseUIButton(context, "Update", () async {
                            if (_.imageFile != null &&
                                (_.name.text != GlobalVariables.name ||
                                    _.department.text !=
                                        GlobalVariables.department ||
                                    _.specialization.text !=
                                        GlobalVariables.specialization)) {
                              await _.uploadImageToFirebase();
                              _.updateValueInFirestore({
                                "name": _.name.text,
                                "specialization": _.specialization.text,
                                "department": _.department.text,
                              });
                            } else if (_.imageFile != null &&
                                (_.name.text == GlobalVariables.name ||
                                    _.department.text ==
                                        GlobalVariables.department ||
                                    _.specialization.text ==
                                        GlobalVariables.specialization)) {
                              await _.uploadImageToFirebase();
                            } else if (_.imageFile == null &&
                                (_.name.text != GlobalVariables.name ||
                                    _.department.text !=
                                        GlobalVariables.department ||
                                    _.specialization.text !=
                                        GlobalVariables.specialization)) {
                              _.updateValueInFirestore({
                                "name": _.name.text,
                                "specialization": _.specialization.text,
                                "department": _.department.text,
                              });
                            } else if (_.imageFile == null &&
                                (_.name.text == GlobalVariables.name ||
                                    _.department.text ==
                                        GlobalVariables.department ||
                                    _.specialization.text ==
                                        GlobalVariables.specialization)) {
                              Get.snackbar("Warning", "No Change detected");
                            }
                          })
                        ],
                      ).marginSymmetric(horizontal: 20),
                    ),
            );
          });
        });
  }
}
