import 'package:finalyear/common_textfields/commn_textfield.dart';
import 'package:finalyear/controllers/announcement_controller.dart';
import 'package:finalyear/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'color_utils.dart';

class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyData(context),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Announcement",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget bodyData(context) {
    return GetBuilder<AnnouncementScreenController>(
        init: AnnouncementScreenController(),
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
                      child: Form(
                        key: _.formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 100,
                            ),
                            CommonTextField(
                              validator: (value) {
                                return _.isEmptyField(value.toString());
                              },
                              controller: _.title,
                              bordercolor: Colors.white,
                              hintText: "Announcement Title",
                              
                              maxlines: 1,
                            ).marginSymmetric(horizontal: 15),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: Get.height / 2.7,
                              width: Get.width,
                              child: CommonTextField(
                                validator: (value) {
                                  return _.isEmptyField(value.toString());
                                },
                                controller: _.announcement,
                                bordercolor: Colors.white,
                                hintText: "Description",
                                maxlines: 10,
                              ),
                            ).marginSymmetric(horizontal: 15),
                            firebaseUIButton(
                              context,
                              "Announce",
                              () async {
                                if (_.formKey.currentState!.validate()) {
                                  await _.addAnnouncement();
                                }
                              },
                            ).marginSymmetric(horizontal: 20),
                          ],
                        ),
                      ),
                    ),
            );
          });
        });
  }
}
