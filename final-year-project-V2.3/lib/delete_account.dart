import 'package:finalyear/reusable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'color_utils.dart';

class delete_account extends StatefulWidget {
  const delete_account({super.key});

  @override
  State<delete_account> createState() => _delete_accountState();
}

class _delete_accountState extends State<delete_account> {
  TextEditingController _emailTextController = TextEditingController();

  void deleteAccount(String text) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.delete();

        Fluttertoast.showToast(
          msg: 'Account deleted successfully',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          textColor: Colors.green,
          fontSize: 16.0,
        );

        // Navigate to the home screen or any other desired screen
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomeScreen()),
        // );
        Navigator.pop(context);
      } catch (error) {
        print('Error deleting account: $error');
        Fluttertoast.showToast(
          msg: 'Failed to delete account. Please try again.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          textColor: Colors.red,
          fontSize: 16.0,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'No user is currently signed in.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        textColor: Colors.red,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Delete Account",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.black,
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 150,
              ),
              reusableTextField("Enter Email", Icons.email_outlined, false,
                      _emailTextController)
                  .marginSymmetric(horizontal: 20),
              const SizedBox(
                height: 40,
              ),
              firebaseUIButton(context, "Delete", () {
                deleteAccount(_emailTextController.text);
              }).marginSymmetric(horizontal: 20),
            ],
          ),
        ),
      ),
    );
  }
}
