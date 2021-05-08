import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/show_oktoast.dart';

Future<String> saveProfilePic(File image) async {
  try {
    //save compressed profile picture and return path to image.
    String filePath = 'images/${image.path}_${DateTime.now()}.png';
    await FirebaseStorage.instance.ref().child(filePath).putFile(image);
    return await FirebaseStorage.instance
        .ref()
        .child(filePath)
        .getDownloadURL();
  } catch (e) {
    toast(e.toString());
  }
}
