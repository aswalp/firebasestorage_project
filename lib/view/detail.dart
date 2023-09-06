// import 'package:flutter/foundation.dart';
import 'package:firebase/services/firebase_sample_service.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  DetailPage({super.key});
  final firestoreInstance = FirebaseSampleService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: firestoreInstance.getdata(),
          builder: (context, snapshot) {
            return ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          snapshot.data!.docs[index].data()["photo"]),
                    ),
                    title: Text(
                      snapshot.data!.docs[index].data()["name"],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 10,
                  );
                },
                itemCount:
                    snapshot.data == null ? 1 : snapshot.data!.docs.length);
          }),
    );
  }
}
