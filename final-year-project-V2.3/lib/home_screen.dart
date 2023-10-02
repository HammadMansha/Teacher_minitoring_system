// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyear/LoginPage.dart';
import 'package:finalyear/add_course.dart';
import 'package:finalyear/announcement.dart';
import 'package:finalyear/delete_account.dart';
import 'package:finalyear/signup_screen.dart';
import 'package:finalyear/upload_pdf_screen.dart';
import 'package:finalyear/view_all_announcement.dart';
import 'package:finalyear/view_courses.dart';
import 'package:finalyear/view_pdf_screen.dart';
import 'package:finalyear/view_registered_teachers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'color_utils.dart';
import 'constants/api_url/api_url.dart';
import 'package:http/http.dart' as http;

import 'global_variables.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoggedIn = false;
  late User? currentUser;
  Map<String, dynamic>? userData;
  String role = "";
  late StreamSubscription sseSubscription;
  String responseMessage = '';
  Timer? _timer;
  DateTime? startTime;
  DateTime? temp;
  DateTime? endTime;
  DateTime? previousDateTime;
  bool stopCalculate = false;
  int counter = 0;
  final storage = GetStorage();
  @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Fetch the data of the current user's document
      getUserDocumentData(currentUser!.uid);
    }

    //getAlertStream();
    //getTime();

    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    //_startTimer();
  }

  //-------------------Get user roles---------------------

  Future<void> getUserDocumentData(String uid) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users_role")
          .doc(uid)
          .get();
      if (snapshot.exists) {
        setState(() {
          userData = snapshot.data() as Map<String, dynamic>?;
        });

        print("user data-------------------------${userData!["role"]}");
        role = userData!["role"];
      } else {
        print('Document with ID: $uid does not exist.');
      }
    } catch (error) {
      print('Error getting user document data: $error');
    }
  }

//-----------------------post api-----------------------

  Future<void> getTeacherPresenceDetail() async {
    const url = '${ApiData.baseUrl}${ApiData.checkConnection}';
    print("api url is--------------$url");

    final response = await http.post(Uri.parse(url));

    // Check the response
    print('HTTP Response Code: ${response.statusCode}');
    var data = json.decode(response.body);
    String responseMessage = data["message"];
    print('Response messgae: $responseMessage');

    if (response.statusCode == 200) {
      counter++;
      print("counter value in if--------$counter");

      if (counter == 1) {
        startTime = DateTime.now();
      }

      setState(() {
        GlobalVariables.updateDeviceConnection(true);
        stopCalculate = true;
      });
    } else {
      print("counter value in else--------$counter");

      if (counter >= 1 && stopCalculate == true) {
        String? storedTotalDurationInMillis = await storage.read("teacherTime");
        if (storedTotalDurationInMillis != null) {
          int totalDurationInMillis = int.parse(storedTotalDurationInMillis);
          setState(() {
            endTime = (temp ?? DateTime.now())
                .add(Duration(milliseconds: totalDurationInMillis));
            GlobalVariables.totalDuration = endTime!.difference(startTime!);
          });
          print("total start time in if--------------$startTime");
          print("total end time in if--------------$endTime");

          print(
              "total difference in if--------------$GlobalVariables.totalDuration");
          await storage.write("teacherTime",
              GlobalVariables.totalDuration.inMilliseconds.toString());
        } else {
          endTime = DateTime.now();
          GlobalVariables.totalDuration = endTime!.difference(startTime!);
          print(
              "total difference in else--------------$GlobalVariables.totalDuration");

          await storage.write("teacherTime",
              GlobalVariables.totalDuration.inMilliseconds.toString());
        }
      }

      setState(() {
        GlobalVariables.updateDeviceConnection(false);
        stopCalculate = false;
      });
    }

    print("Total duration----------------${GlobalVariables.totalDuration}");
  }

  void _startTimer() {
    // Start the timer that will run the API request every 30 seconds
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      print("again request");
      getTeacherPresenceDetail();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Dashboard",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: User == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  hexStringToColor("CB2B93"),
                  hexStringToColor("9546C4"),
                  hexStringToColor("5E61F4")
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: ListView(
                scrollDirection: Axis.vertical,
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const SizedBox(
                    height: 100,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.manage_accounts,
                      size: 20,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'Create Teacher Account',
                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 15,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Get.to(() => const SignUpScreen());
                    }, //  tileColor: Colors.white,
                  ),
                  ExpansionTile(
                    title: Row(
                      children: const [
                        Icon(
                          Icons.create_new_folder,
                          size: 20,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 35,
                        ),
                        Text(
                          'Course Management',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    children: [
                      ListTile(
                        onTap: () {
                          Get.to(() => AddCourseScreen());
                        },
                        // contentPadding: EdgeInsets.only(right: 16.0), // Add left padding
                        leading: Icon(
                          Icons.add,
                          size: 20,
                          color: Colors.black,
                        ).marginOnly(left: 40),
                        title: const Text(
                          'Add Course',
                          style: TextStyle(fontSize: 13),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 15,
                          color: Colors.black,
                        ), //  tileColor: Colors.white,
                        //  selectedTileColor: Colors.green,
                        //selectedColor: Colors.red,
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.remove_red_eye_outlined,
                          size: 20,
                          color: Colors.black,
                        ).marginOnly(left: 40),
                        title: const Text(
                          'View Courses',
                          style: TextStyle(fontSize: 13),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 15,
                          color: Colors.black,
                        ), //  tileColor: Colors.white,
                        onTap: () {
                          Get.to(() => const ViewCoursesScreen());
                        },
                      ),
                    ],
                  ),

                  ExpansionTile(
                    title: Row(
                      children: const [
                        Icon(
                          Icons.announcement,
                          size: 20,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 35,
                        ),
                        Text(
                          'Announcement Management',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.announcement,
                          size: 20,
                          color: Colors.black,
                        ).marginOnly(left: 40),
                        title: const Text(
                          'Add Announcement',
                          style: TextStyle(fontSize: 13),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 15,
                          color: Colors.black,
                        ), //  tileColor: Colors.white,
                        onTap: () {
                          Get.to(() => const AnnouncementScreen());
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.surround_sound_outlined,
                          size: 20,
                          color: Colors.black,
                        ).marginOnly(left: 40),
                        title: const Text(
                          'View Announcements',
                          style: TextStyle(fontSize: 13),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 15,
                          color: Colors.black,
                        ), //  tileColor: Colors.white,
                        onTap: () {
                          Get.to(() => const ViewAllAnnouncements());
                        },
                      ),
                    ],
                  ),

                  //--------------------Upload time table-------------

                  ExpansionTile(
                    title: Row(
                      children: const [
                        Icon(
                          Icons.access_time_filled_sharp,
                          size: 20,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 35,
                        ),
                        Text(
                          'Time Table Management',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.access_time_filled_sharp,
                          size: 20,
                          color: Colors.black,
                        ).marginOnly(left: 40),
                        title: const Text(
                          'Upload Timetable',
                          style: TextStyle(fontSize: 13),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 15,
                          color: Colors.black,
                        ), //  tileColor: Colors.white,
                        onTap: () {
                          Get.to(() => UploadScreen());
                        },
                      ),

                      //-----------View time table-------------------------

                      ListTile(
                        leading: const Icon(
                          Icons.timer,
                          size: 20,
                          color: Colors.black,
                        ).marginOnly(left: 40),
                        title: const Text(
                          'View Timetable',
                          style: TextStyle(fontSize: 13),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 15,
                          color: Colors.black,
                        ), //  tileColor: Colors.white,
                        onTap: () {
                          Get.to(() => PdfViewScreen("Time table"));
                        },
                      ),
                    ],
                  ),

                  //------------------------View users--------------
                  ListTile(
                    leading: const Icon(
                      Icons.person,
                      size: 20,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'View Register Users',
                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 15,
                      color: Colors.black,
                    ), //  tileColor: Colors.white,
                    onTap: () {
                      Get.to(() => const ViewRegisteredTeachers());
                    },
                  ),

                  //-----------------Delete Account------------------

                  ListTile(
                    leading: const Icon(
                      Icons.delete_forever,
                      size: 20,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'Delete Account',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 15,
                      color: Colors.black,
                    ), //  tileColor: Colors.white,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const delete_account()),
                      );
                    },
                  ),
                ],
              ),
            ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          scrollDirection: Axis.vertical,
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              "images/fyp.jpeg",
              width: 180,
              height: 100,
            ),
            const SizedBox(
              height: 40,
            ),
            const Divider(
              thickness: 0.6,
              color: Colors.black,
            ),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                size: 20,
                color: Colors.black,
              ),
              title: const Text(
                'Exit',
                style: TextStyle(fontSize: 13),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pop(context);
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Row(
                      children: [
                        const Icon(
                          Icons.exit_to_app,
                          size: 25,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Exit',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ],
                    ),
                    content: const Text(
                      'Are you sure you want to Exit from this app ?',
                      style: TextStyle(fontSize: 15),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => SystemNavigator.pop(),
                        child: const Text('Exit'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 20,
                color: Colors.black,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 13),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15,
                color: Colors.black,
              ), //  tileColor: Colors.white,
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) async {
                  await storage.remove("email");
                  await storage.remove("password");

                  await storage.remove("role");

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()),
                    (route) => false, // Remove all routes from the stack
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
