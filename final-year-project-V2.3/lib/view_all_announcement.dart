import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyear/controllers/view_all_announcements_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'color_utils.dart';

class ViewAllAnnouncements extends StatelessWidget {
  const ViewAllAnnouncements({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyData(context),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "All Announcements",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  bodyData(BuildContext context) {
    return GetBuilder<ViewAllAnnouncementController>(
        init: ViewAllAnnouncementController(),
        builder: (_) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringToColor("CB2B93"),
                hexStringToColor("9546C4"),
                hexStringToColor("5E61F4")
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: _.collectionReference.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Data is ready
                final documents = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final data =
                        documents[index].data() as Map<String, dynamic>;
                    // Access fields in the document using data['field_name']
                    return ListTile(
                      title: Text(
                        data['title'].toString(),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(data['message'].toString()),
                      leading: const Icon(
                        Icons.announcement_outlined,
                        color: Colors.black,
                      ),
                      trailing: Column(
                        children: [
                          Text(data['date_time'].toString().split(" ").first),
                          Text(data['date_time']
                              .toString()
                              .split(" ")
                              .last
                              .split(".")
                              .first),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          );
        });
  }
}
