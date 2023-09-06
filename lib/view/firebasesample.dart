// import 'dart:io';

import 'package:firebase/providers/dataimageproviders.dart';
import 'package:firebase/services/firebase_sample_service.dart';
import 'package:firebase/view/detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class FireBaseSample extends ConsumerWidget {
  FireBaseSample({super.key});

  final TextEditingController textEditingController = TextEditingController();
  final firestoreInstance = FirebaseSampleService();

  // String image="";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(),
                    ));
              },
              icon: Icon(Icons.person))
        ],
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              ref.watch(galleryimage) == null
                  ? const CircleAvatar(
                      radius: 80,
                    )
                  : CircleAvatar(
                      radius: 80,
                      backgroundImage: MemoryImage(ref.watch(galleryimage)!),
                    ),
              Positioned(
                  top: 110,
                  left: 110,
                  child: IconButton(
                    onPressed: () {
                      selectimage(context, ref);
                    },
                    icon: const Icon(Icons.camera_alt),
                    iconSize: 30,
                  ))
            ],
          ),
          TextField(
            controller: textEditingController,
          ),
          TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                ref.read(imageProvider.notifier).state =
                    await firestoreInstance.addimage(
                        textEditingController.text, ref.watch(galleryimage)!);

                Map<String, dynamic> data = {
                  "name": textEditingController.text,
                  "photo": ref.watch(imageProvider),
                };
                firestoreInstance.addToFirestore(data);
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("data added")));
              },
              child: const Text("Ok")),
          // ref.watch(imageProvider) == ""
          //     ? const SizedBox()
          //     : SizedBox(
          //         height: 100,
          //         width: 100,
          //         child: Image.network(
          //           ref.watch(imageProvider),
          //           fit: BoxFit.cover,
          //         ),
          //       )
        ],
      ),
    );
  }

  Future<dynamic> selectimage(BuildContext context, WidgetRef ref) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            alignment: Alignment.center,
            height: 200,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  "Select Image from",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        ref.read(galleryimage.notifier).state =
                            await selectImageGallery();
                        if (ref.watch(galleryimage) != "") {
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("image is not selected")));
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            elevation: 3,
                            child: Image.asset(
                              "assets/images/gallery.png",
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Text("Gallery")
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        ref.read(galleryimage.notifier).state =
                            await selectimagecamera();

                        if (ref.watch(galleryimage) != "") {
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("image is not selected")));
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            elevation: 3,
                            child: Image.asset(
                              "assets/images/camera.png",
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Text("Camera")
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<Uint8List?> selectImageGallery() async {
  XFile? file = await ImagePicker()
      .pickImage(source: ImageSource.gallery, imageQuality: 10);
  if (file != null) {
    var i = file.readAsBytes();
    return i;
  }
  return null;
}

Future<Uint8List?> selectimagecamera() async {
  XFile? file = await ImagePicker()
      .pickImage(source: ImageSource.camera, imageQuality: 10);

  if (file != null) {
    var i = file.readAsBytes();

    return i;
  }
  return null;
}
