import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../models/user_profile_model.dart';

import '../blocs/provider.dart';
import '../resources/flutter_fire_auth.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Profile',
                  style: TextStyle(
                    fontSize: 24.0,
                    letterSpacing: 2.0,
                  )),
              signOutButton(),
            ],
          ),
          SizedBox(
            height: 6.0,
          ),
          Divider(),
          SizedBox(
            height: 50.0,
          ),
          profile(bloc),
          Spacer(),
          submitButton(context),
          Spacer(),
        ],
      ),
    );
  }

  Widget signOutButton() {
    return GestureDetector(
      onTap: signOutUser,
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.pink[50],
        ),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.logout,
              color: Colors.purple[600],
              size: 20,
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              "Sign Out",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
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
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            pickImage();
          },
          child: CircleAvatar(
            radius: 100,
            backgroundColor: Colors.blueGrey,
            child: CircleAvatar(
                backgroundImage: _image == null
                    ? NetworkImage(profilePicPath)
                    : Image.file(_image).image,
                backgroundColor: Colors.transparent,
                radius: 100.0),
          ),
        ),
        Positioned(
            bottom: -7.0,
            right: -5.0,
            child: IconButton(
              icon: Icon(
                Icons.highlight_off,
                color: Colors.red,
                size: 36.0,
              ),
              onPressed: () {
                setState(() {
                  crossed = true;
                  _image = null;
                });
              },
            ))
      ],
    );
  }

  Widget showUsername() {
    return Text(
      username,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.bold, letterSpacing: 2.0),
    );
  }

  Widget submitButton(context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.3,
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.purple[600])),
      child: MaterialButton(
        onPressed: changePicture,
        child: Text('SUBMIT'),
      ),
    );
  }

  Future<void> pickImage() async {
    final selected =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    if (selected != null) {
      setState(() {
        _image = File(selected.path);
      });
    }
  }

  void signOutUser() async {
    await signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void changePicture() {}
}
