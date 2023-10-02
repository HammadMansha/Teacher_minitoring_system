import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors/app_colors.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? labelText;
  final Color? fillcolor;
  final Color? bordercolor;
  final bool isTextHidden;
  final String? hintText;
  final IconData? buttonIcon;
  final IconData? prefixIcon;
  final bool? togglePassword;
  final int? maxlines;
  final int? maxlength;
  final int? maxLength;
  final Function()? toggleFunction;
  final IconData? toggleIcon;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final Function()? onTap;
  final Function()? prefixIconTap;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focus;
  final TextInputAction? textInputAction;
  final Widget? suffixicon;
  final double? radius;
  final changeObscureStatus;
  const CommonTextField(
      {Key? key,
      @required this.controller,
      this.validator,
      this.radius,
      this.bordercolor,
      this.labelText,
      this.fillcolor,
      this.maxLength,
      this.maxlines,
      this.hintText,
      this.isTextHidden = false,
      this.buttonIcon,
      this.prefixIcon,
      this.onChanged,
      this.togglePassword = false,
      this.toggleFunction,
      this.toggleIcon,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.readOnly,
      this.onTap,
      this.inputFormatters,
      this.prefixIconTap,
      this.changeObscureStatus,
      this.focus,
      this.suffixicon,
      this.maxlength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxlines,
      textAlign: TextAlign.left,
      textAlignVertical: TextAlignVertical.center,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      obscureText: isTextHidden,
      readOnly: readOnly == null ? false : true,
      onTap: onTap,
      maxLength: maxLength,
      focusNode: focus,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        //suffix:suffixicon,
        prefixIcon: prefixIcon != null
            ? GestureDetector(
                child: Icon(
                  prefixIcon,
                  color: Colors.black,
                  size: 20.0,
                ),
                onTap: prefixIconTap,
              )
            : null,
        suffixIcon: suffixicon,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: bordercolor ?? Colors.transparent,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(radius ?? 20.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: bordercolor ?? const Color(0xfff7fbff),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(radius ?? 20.0),
          ),
        ),
        hintText: hintText,
        fillColor: fillcolor,
        filled: true,
        hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
        // contentPadding:
        //     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        labelText: labelText,

        labelStyle: const TextStyle(color: Colors.black, fontSize: 10.0),
        border: OutlineInputBorder(
          borderSide:
              const BorderSide(color: AppColors.allTextFieldBordersColor),
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 20.0)),
        ),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 15),
      controller: controller,
      validator: validator,
    );
  }
}
