import 'dart:async';
import 'package:finalyear/LoginPage.dart';
import 'package:finalyear/home_screen.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){ //init means initialize
    super.initState();
    Timer(
        Duration(seconds: 4), (){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => SignInScreen(),
          ));
    }
    );

  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/fyp.jpeg',width: 200,height: 200,),
            SizedBox(
              height: 30,
            ),


            SizedBox(
              height: 250,
            ),
            Center(child: Text('From',style: TextStyle(fontSize: 12,color: Colors.black,fontFamily: "avenir"),)),
            Center(child: Text('SRS Technologies',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black,fontFamily: "avenir"),)),
          ],
        ),
      ),
    );
  }
}
