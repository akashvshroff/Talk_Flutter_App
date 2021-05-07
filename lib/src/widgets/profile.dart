import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../models/user_profile_model.dart';

import '../blocs/provider.dart';
import '../resources/flutter_fire_auth.dart';

import 'tab_title.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File _image;
  ImagePicker picker = ImagePicker();
  String defaultUrl =
      'https://firebasestorage.googleapis.com/v0/b/talk-chat-app-66f32.appspot.com/o/default_profile.png?alt=media&token=b3d50e26-7355-4a8f-8340-750cee75ed81';
  String username = 'loading...';
  String profilePicPath = '';
  bool crossed = false;
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    final Bloc bloc = Provider.of(context);
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: [
          TabTitle('Profile', 'Sign Out', Icons.logout, signOutUser),
          SizedBox(
            height: 6.0,
          ),
          Divider(),
          SizedBox(
            height: 50.0,
          ),
          profile(bloc),
          Spacer(),
        ],
      ),
    );
  }

  Widget profile(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.profileStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        UserProfileModel profileModel = snapshot.data;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            username = profileModel.username;
            imageUrl = profileModel.profilePicPath;
          });
        });
        return Column(
          children: [
            profileImage(),
            SizedBox(
              height: 60.0,
            ),
            showUsername(),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        );
      },
    );
  }

  Widget profileImage() {
    if (crossed || imageUrl == '') {
      profilePicPath = defaultUrl;
    } else {
      profilePicPath = imageUrl;
    }
    return CircleAvatar(
      radius: 100,
      backgroundColor: Colors.blueGrey,
      child: CircleAvatar(
          backgroundImage: _image == null
              ? NetworkImage(profilePicPath)
              : Image.file(_image).image,
          backgroundColor: Colors.transparent,
          radius: 100.0),
    );
  }

  Widget showUsername() {
    return Text(
      username,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 30.0, fontWeight: FontWeight.bold, letterSpacing: 2.0),
    );
  }

  void signOutUser() async {
    await signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
