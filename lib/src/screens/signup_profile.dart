import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignUpProfile extends StatefulWidget {
  @override
  _SignUpProfileState createState() => _SignUpProfileState();
}

class _SignUpProfileState extends State<SignUpProfile> {
  final usernameController = TextEditingController();
  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
    );
  }

  Widget buildBody(context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spacer(
            flex: 2,
          ),
          Text(
            'PROFILE',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.0, letterSpacing: 2.0),
          ),
          Spacer(),
          showImage(context),
          Spacer(),
          usernameField(context),
          Spacer(),
          submitButton(context),
          Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget showImage(context) {
    String imagePath;

    if (_image == null) {
      imagePath = 'images/default_profile.png';
    } else {
      imagePath = _image.path;
    }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey, width: 2.0),
      ),
      child: GestureDetector(
        onTap: () {
          pickImage();
        },
        child: CircleAvatar(
            //Image.file(_image).image,
            backgroundImage: AssetImage(imagePath),
            backgroundColor: Colors.transparent,
            radius: 80.0),
      ),
    );
  }

  Widget usernameField(context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      child: TextField(
        style: TextStyle(fontSize: 18.0),
        controller: usernameController,
        decoration: InputDecoration(
          hintText: 'Username',
          contentPadding: EdgeInsets.only(left: 2.0),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final selected = await picker.getImage(source: ImageSource.gallery);
    if (selected != null) {
      setState(() {
        _image = File(selected.path);
      });
    }
  }

  Container submitButton(context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.purple[600])),
      child: MaterialButton(
        onPressed: () {
          submitDialog(context);
        },
        child: Text('SUBMIT'),
      ),
    );
  }

  void submitDialog(context) {
    AlertDialog alert = AlertDialog(
      title: Text(
        'Information',
        style: TextStyle(fontSize: 20.0),
      ),
      content: Text(
        'While you can change your profile picture, your username is permanent and cannot be altered.',
        style: TextStyle(fontSize: 18.0),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel')),
        TextButton(
            onPressed: () {
              submitProfileDetails();
              Navigator.of(context).pop();
            },
            child: Text('Submit')),
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  void submitProfileDetails() {}
}
