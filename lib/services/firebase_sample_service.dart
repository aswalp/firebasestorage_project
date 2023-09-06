// import 'dart:io';

// import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FirebaseSampleService {
  // an instance to implement all the functions of firestore
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  // final storageRef = FirebaseStorage.instance.ref("images");
  // final storage
//!---------------add image and return image url-----------!//
  Future<String> addimage(String name, Uint8List path) async {
    final nameRef = storage.ref().child("$name.jpg");

    try {
      if (path.isNotEmpty) {
        // Upload the image data
        await nameRef.putData(path);

        // Get the download URL
        String data = await nameRef.getDownloadURL();
        print("Download URL: $data");
        return data;
      } else {
        throw Exception("Image data is empty.");
      }
    } catch (e) {
      print("Error uploading or retrieving image: $e");
      return ""; // Handle the error as needed
    }
  }

  void addToFirestore(Map<String, dynamic> name) {
    firestore.collection("names").add(name);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getdata() {
    final dat = firestore.collection("names");

    return dat.snapshots();
  }
}
