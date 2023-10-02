import 'package:finalyear/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../color_utils.dart';
import '../controllers/user_profile.dart/edit_profile_controller.dart';
import '../controllers/user_profile.dart/view_profile_controller.dart';

class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyData(context),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "View Profile",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  bodyData(BuildContext context) {
    return GetBuilder<ViewProfileScreenController>(
        init: ViewProfileScreenController(),
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
                          CircleAvatar(
                            radius:
                                70, // Adjust the radius according to your requirements
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(_.pdfUrlFirebase),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          reusableTextField("", Icons.person_outline, false,
                              _.name, (p0) {}, true),
                          const SizedBox(
                            height: 10,
                          ),
                          reusableTextField(
                              "", Icons.app_registration_rounded, false, _.id,
                              (p0) {
                            return null;
                          }, true),
                          const SizedBox(
                            height: 10,
                          ),
                          reusableTextField("", Icons.email, false, _.email,
                              (p0) {
                            return null;
                          }, true),
                          const SizedBox(
                            height: 10,
                          ),
                          reusableTextField("", Icons.drive_file_move_rtl_sharp,
                              false, _.department, (p0) {
                            return null;
                          }, true),
                          const SizedBox(
                            height: 10,
                          ),
                          reusableTextField(
                              "name",
                              Icons.settings_input_component_outlined,
                              false,
                              _.specialization, (p0) {
                            return null;
                          }, true),
                          const SizedBox(
                            height: 10,
                          ),
                          reusableTextField(
                              "name", Icons.roller_shades, false, _.role, (p0) {
                            return null;
                          }, true),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ).marginSymmetric(horizontal: 20),
                    ),
            );
          });
        });
  }
}
