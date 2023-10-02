import 'package:finalyear/controllers/user_profile.dart/change_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../color_utils.dart';
import '../reusable_widget.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyData(context),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Change Password ",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  bodyData(BuildContext context) {
    return GetBuilder<ChangePasswordController>(
        init: ChangePasswordController(),
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
                  : Form(
                      key: _.formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 200,
                            ),
                            reusableTextField(
                              "Passowrd",
                              Icons.password,
                              true,
                              _.password,
                              (value) {
                                return _.isEmptyField(value.toString());
                              },
                            ),
                            const SizedBox(height: 10),
                            reusableTextField(
                                "Confirm Password",
                                Icons.password,
                                true,
                                _.confirmPassword, (value) {
                              return _.isEmptyField(value.toString());
                            }),
                            const SizedBox(height: 20),
                            firebaseUIButton(context, "Update Password",
                                () async {
                              if (_.formKey.currentState!.validate()) {
                                _.changePassword(_.password.text);
                              }
                            })
                          ],
                        ).marginSymmetric(horizontal: 20),
                      ),
                    ),
            );
          });
        });
  }
}
