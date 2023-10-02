import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyear/user_profile/change_password.dart';
import 'package:finalyear/user_profile/edit_profile.dart';
import 'package:finalyear/user_profile/view_profile.dart';
import 'package:finalyear/view_all_announcement.dart';
import 'package:finalyear/view_pdf_screen.dart';
import 'package:finalyear/view_teacher_courses.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'LoginPage.dart';
import 'color_utils.dart';
import 'constants/api_url/api_url.dart';
import 'global_variables.dart';
import 'package:http/http.dart' as http;


final FirebaseAuth _auth = FirebaseAuth.instance;
final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

class teacher_class extends StatefulWidget {
  const teacher_class({super.key});

  @override
  State<teacher_class> createState() => _teacher_classState();
}

class _teacher_classState extends State<teacher_class> {
  bool isLoggedIn = true;
  final storage = GetStorage();
  CollectionReference<Map<String, dynamic>> usersRole =
      FirebaseFirestore.instance.collection('teachers_info');
  String userId = "";
  Timer? _timer;
  int counter = 0;
  DateTime? startTime;
  DateTime? temp;
  DateTime? endTime;
  DateTime? previousDateTime;
  bool stopCalculate = false;

  /////////////-----------------------Find user information----------------------

  Future<void> findUserInformation(String uid) async {
    print("current teacher user id------------------$uid");
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await usersRole.doc(uid).get();

    if (userDoc.exists) {
      GlobalVariables.userRole = userDoc.data()!['role'];
      GlobalVariables.name = userDoc.data()!['name'];
      GlobalVariables.id = userDoc.data()!['Id'];
      GlobalVariables.department = userDoc.data()!['department'];
      GlobalVariables.email = userDoc.data()!['email'];
      GlobalVariables.specialization = userDoc.data()!['specialization'];

      await storage.write("role", GlobalVariables.userRole);
      print("User Role: ${GlobalVariables.userRole}");
    } else {
      Fluttertoast.showToast(
          msg: "User role document is not found in firebase",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          textColor: Colors.red,
          fontSize: 16.0);
      print("User document not found.");
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    userId = await storage.read("uid").toString();

    if (userId != '' || userId != null) {
      await findUserInformation(userId)
          .then((value) => print("All information get"));
    }
    _startTimer();

    super.didChangeDependencies();
  }
  @override
  void dispose() {
    // Dispose of any resources here
    super.dispose();
  }
  void _startTimer() {
    // Start the timer that will run the API request every 30 seconds
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      print("again request");
      getTeacherPresenceDetail();
    });
  }

  Future<void> getTeacherPresenceDetail() async {
    if(isLoggedIn) {
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
          String? storedTotalDurationInMillis = await storage.read(
              "teacherTime");
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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text("Teacher Dashboard")),
        actions: <Widget>[
          ///////////////////////////////////// 3 DOT POP UP MENU//////////////////////////////////////////////////////

          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 2,
                child: Card(
                  elevation: 0,
                  child: ListTile(
                    leading: Icon(
                      Icons.exit_to_app,
                      size: 20,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Exit',
                      style: TextStyle(fontSize: 13),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 15,
                      color: Colors.blue,
                    ),
                    //  tileColor: Colors.white,
                    //  selectedTileColor: Colors.green,
                    //selectedColor: Colors.red,
                  ),
                ),
              ),
              const PopupMenuItem(
                value: 3,
                child: Card(
                  elevation: 0,
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      size: 20,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Logout',
                      style: TextStyle(fontSize: 13),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 15,
                      color: Colors.blue,
                    ), //  tileColor: Colors.white,
                    //  selectedTileColor: Colors.green,
                    //selectedColor: Colors.red,
                  ),
                ),
              ),
            ],
            onSelected: (int menu) {
              if (menu == 2) {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Row(
                      children: [
                        Icon(
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
                        onPressed: () => Navigator.pop(context, 'help'),
                        child: const Text(
                          'Help',
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
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
              } else if (menu == 3) {
                FirebaseAuth.instance.signOut().then((value) async {
                  await storage.remove("email");
                  await storage.remove("password");
                  await storage.remove("role");
                  await storage.remove("uid");
                  isLoggedIn=false;
                  _timer!.cancel();
                  setState(() {

                  });
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()),
                    (route) => true, // Remove all routes from the stack
                  );
                });
              }
            },
          ),
///////////////////////////////////// 3 DOT POP UP MENU//////////////////////////////////////////////////////
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
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
        child: ListView(
          scrollDirection: Axis.vertical,
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
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
                'View Courses',
                style: TextStyle(fontSize: 13),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15,
                color: Colors.black,
              ),
              onTap: () {
                Get.to(() => const ViewTeacherCourses());
              }, //  tileColor: Colors.white,
            ),
            //-------------------------Announcement screen route---------------------
            ListTile(
              leading: const Icon(
                Icons.add_task_rounded,
                size: 20,
                color: Colors.black,
              ),
              title: const Text(
                'Check Announcements',
                style: TextStyle(fontSize: 13),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15,
                color: Colors.black,
              ),
              onTap: () {
                Get.to(() => const ViewAllAnnouncements());
              }, //  tileColor: Colors.white,
            ),
            //---------------------view time table screen----------------

            ListTile(
              leading: const Icon(
                Icons.timer,
                size: 20,
                color: Colors.black,
              ),
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

            //---------------------Edit Profile screen----------------

            ListTile(
              leading: const Icon(
                Icons.person,
                size: 20,
                color: Colors.black,
              ),
              title: const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 13),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15,
                color: Colors.black,
              ), //  tileColor: Colors.white,
              onTap: () {
                Get.to(() => const EditProfileScreen());
              },
            ),

            //---------------------View Profile screen----------------

            ListTile(
              leading: const Icon(
                Icons.person,
                size: 20,
                color: Colors.black,
              ),
              title: const Text(
                'View Profile',
                style: TextStyle(fontSize: 13),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15,
                color: Colors.black,
              ), //  tileColor: Colors.white,
              onTap: () {
                Get.to(() => const ViewProfileScreen());
              },
            ),

            //---------------------Change Password screen----------------

            ListTile(
              leading: const Icon(
                Icons.lock,
                size: 20,
                color: Colors.black,
              ),
              title: const Text(
                'Change Password',
                style: TextStyle(fontSize: 13),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15,
                color: Colors.black,
              ), //  tileColor: Colors.white,
              onTap: () {
                Get.to(() => const ChangePasswordScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
