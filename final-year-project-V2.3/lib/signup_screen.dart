import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyear/home_screen.dart';
import 'package:finalyear/reusable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'color_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController teacherIdController = TextEditingController();
  TextEditingController teacherName = TextEditingController();
  TextEditingController teacherDepartment = TextEditingController();
  TextEditingController tecaherSpecialization = TextEditingController();
  bool isLoading = false;
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('teachers_info');

  CollectionReference userRoleCollection =
      FirebaseFirestore.instance.collection('users_role');

  final formKey = GlobalKey<FormState>();

  //------------------Validate function------------------------

  String? isEmptyField(String value) {
    if (value.isEmpty) {
      return "This field is required";
    } else {
      return null;
    }
  }

  //-----------------------Create teacher account function---------------------
  Future<void> signUp() async {
    try {
      setState(() {
        isLoading = true;
      });

      String email = _emailTextController.text.trim();
      String password = _passwordTextController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        setState(() {
          isLoading = false;
        });
        // Handle empty fields
        return;
      }

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Sign up success
        // You can navigate to another screen here or show a success message
        collectionReference.doc(userCredential.user!.uid).set({
          "Id": teacherIdController.text,
          "department": teacherDepartment.text,
          "email": email,
          "name": teacherName.text,
          "role": "teacher",
          "specialization": tecaherSpecialization.text,
        });
        
        userRoleCollection.doc(userCredential.user!.uid).set({
          "uid": userCredential.user!.uid,
          "email": email,
          "role": "teacher",
        }).then((value) {
          Fluttertoast.showToast(
              msg: "Account has been created",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3,
              textColor: Colors.green,
              fontSize: 16.0);
          Get.back();
          setState(() {
            isLoading = false;
          });
        }).onError((error, stackTrace) {
          print("Error ${error.toString()}");
          setState(() {
            isLoading = false;
          });
        });

        print('Sign up successful!');
      } else {
        setState(() {
          isLoading = false;
        });
        // Sign up failed
        // You can show an error message to the user
        Fluttertoast.showToast(
            msg: "Sign up failed",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            textColor: Colors.red,
            fontSize: 16.0);
        print('Sign up failed. Please try again later.');
      }
    } catch (e) {
      // Handle other errors that may occur during sign-up (e.g., invalid email format)
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Create Account",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: isLoading == true
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: formKey,
                  child: SingleChildScrollView(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                    child: Column(
                      children: <Widget>[
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        // reusableTextField("Enter UserName", Icons.person_outline, false,
                        //     _userNameTextController),

                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField(
                          "Tecaher name",
                          Icons.person_outline,
                          false,
                          teacherName,
                          (value) {
                            return isEmptyField(value.toString());
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField(
                          "Teacher ID",
                          Icons.app_registration_rounded,
                          false,
                          teacherIdController,
                          (value) {
                            return isEmptyField(value.toString());
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField(
                          "Department",
                          Icons.drive_file_move_rtl_sharp,
                          false,
                          teacherDepartment,
                          (value) {
                            return isEmptyField(value.toString());
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField(
                          "Specialization",
                          Icons.settings_input_component_outlined,
                          false,
                          tecaherSpecialization,
                          (value) {
                            return isEmptyField(value.toString());
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField(
                          "name@teacher.com",
                          Icons.email_outlined,
                          false,
                          _emailTextController,
                          (value) {
                            return isEmptyField(value.toString());
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        reusableTextField(
                          "Enter Password Here",
                          Icons.lock_outlined,
                          true,
                          _passwordTextController,
                          (value) {
                            return isEmptyField(value.toString());
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        firebaseUIButton(
                          context,
                          "Create Teacher Account",
                          () async {
                            if (formKey.currentState!.validate()) {
                              await signUp();
                            }
                          },
                        ),
                      ],
                    ),
                  )),
                )),
    );
  }
}
