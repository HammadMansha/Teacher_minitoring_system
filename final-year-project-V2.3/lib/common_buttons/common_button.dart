// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors/app_colors.dart';


class CommonButton extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final void Function() onPressed;
  final Color fillColor;

  // ignore: use_key_in_widget_constructors
  const CommonButton(
      {required this.text,
      required this.textStyle,
      required this.onPressed,
      required this.fillColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //color: CommonColor.loginAndSendCodeButtonColor,
      width: Get.width / 1.9,
      height: 45,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
          side: const BorderSide(
            color: AppColors.allButtonsColor,
          ),
        ),

        onPressed: onPressed,
        // minWidth: Get.width / 3,
        // height: 42,
        // color: Color.fromRGBO(72, 190, 235, 1),
        color: fillColor,
        child: Text(
          text,
          textScaleFactor: 1.0,
          style: textStyle,
          maxLines: 2,
        ),
      ),
    );
  }
}
