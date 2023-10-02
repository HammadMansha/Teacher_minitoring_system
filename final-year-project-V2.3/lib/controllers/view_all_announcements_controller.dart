import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';


class ViewAllAnnouncementController extends GetxController{


 final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('announcements');


}