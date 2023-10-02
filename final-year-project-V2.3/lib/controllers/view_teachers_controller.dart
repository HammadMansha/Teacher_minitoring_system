import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ViewRegisteredUsersController extends GetxController {
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('teachers_info');
}
