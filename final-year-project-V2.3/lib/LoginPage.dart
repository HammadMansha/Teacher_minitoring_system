// ignore_for_file: use_build_context_synchronously

import 'package:finalyear/global_variables.dart';
import 'package:finalyear/reset_password.dart';
import 'package:finalyear/reusable_widget.dart';
import 'package:finalyear/signup_screen.dart';
import 'package:finalyear/teacher_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'color_utils.dart';
import 'home_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  bool isLoggedIn = false;
  CollectionReference<Map<String, dynamic>> usersRole =
      FirebaseFirestore.instance.collection('users_role');
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String userRole = "";
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );
      if (userCredential.user!.uid.toString().isNotEmpty) {
        await storage.write(
          "uid",
          userCredential.user!.uid.toString(),
        );
        await findUserInformation(
            _emailTextController.text, userCredential.user!.uid.toString());

        await storage.write("email", _emailTextController.text);
        await storage.write("password", _passwordTextController.text);

        if (userRole == "teacher") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const teacher_class()),
          );
        } else if (userRole == "admin") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }

        setState(() {
          isLoading = false;
        });
      }
      // If sign in is successful, you can navigate to the next screen or perform any other actions.
    } catch (e) {
      // Handle any errors that occur during sign in (e.g., invalid email/password).

      if (e.toString().contains("network")) {
        Fluttertoast.showToast(
            msg: "Internet not available",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            textColor: Colors.red,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
          msg: "Incorrect username or password",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          textColor: Colors.red,
        );
      }

      print('Error during sign in: $e');

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> findUserInformation(String email, String uid) async {
    print("curren user id------------------$uid");
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await usersRole.doc(uid).get();

    if (userDoc.exists) {
      userRole = userDoc.data()!['role'];
      await storage.write("role", userRole);
      print("User Role: $userRole");
      Fluttertoast.showToast(
          msg: "Login Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          textColor: Colors.green,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "User role not define you cannot login",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          textColor: Colors.red,
          fontSize: 16.0);
      print("User document not found.");
    }
  }

  void navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  //-----------------------Email validation-----------------

  String? isEmptyField(String value) {
    if (value.isEmpty) {
      return "This field is required";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                hexStringToColor("CB2B93"),
                hexStringToColor("9546C4"),
                hexStringToColor("5E61F4")
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                      child: Column(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.all(10),
                            child: CircleAvatar(
                              radius: 90,
                              backgroundImage: AssetImage('images/fyp.jpeg'),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          reusableTextField(
                            "Enter UserName",
                            Icons.person_outline,
                            false,
                            _emailTextController,
                            (value) => isEmptyField(value.toString()),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          reusableTextField(
                            "Enter Password",
                            Icons.lock_outline,
                            true,
                            _passwordTextController,
                            (value) => isEmptyField(value.toString()),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          forgetPassword(context),
                          firebaseUIButton(context, "Sign In", () async {
                            if (formKey.currentState!.validate()) {
                              await signInWithEmailAndPassword();
                            }
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ResetPassword()),
        ),
      ),
    );
  }
}
