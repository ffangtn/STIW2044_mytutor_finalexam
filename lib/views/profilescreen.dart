import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytutor_final_project/views/subjects.dart';
import 'package:mytutor_final_project/views/tutor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant.dart';
import '../models/user.dart';
import 'loginscreen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Color? color;
  late double screenHeight, screenWidth, resWidth;
  var _image;
  var val = 50;
  int _selectedIndex = 4;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();

  Random random = Random();
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Subjects',
      style: optionStyle,
    ),
    Text(
      'Index 1: Tutors',
      style: optionStyle,
    ),
    Text(
      'Index 2: Subscribe',
      style: optionStyle,
    ),
    Text(
      'Index 3: Favourite',
      style: optionStyle,
    ),
    Text(
      'Index 4: Profile',
      style: optionStyle,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name.toString();
    _phoneController.text = widget.user.phoneno.toString();
    _addressController.text = widget.user.homeaddress.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.85;
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Your Profile")),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue,
            Colors.red,
          ],
        )),
        child: Center(
            child: Column(
          children: [
            SizedBox(
                height: screenHeight / 4,
                child: SizedBox(
                    width: resWidth,
                    child: Card(
                      child: Row(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  // onTap: () => {_updateImageDialog()},
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: CONSTANTS.server +
                                          "/mytutor/mobile/assets/user/" +
                                          widget.user.id.toString() +
                                          '.jpg',
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const LinearProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              )),
                          Expanded(
                              flex: 6,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.user.name.toString(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(widget.user.email.toString()),
                                    Text(widget.user.phoneno.toString()),
                                    Text(widget.user.homeaddress.toString()),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ))),
            Expanded(
                child: SizedBox(
              width: resWidth,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            )),
          ],
        )),
      ),
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0x00ffffff),
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Subjects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Tutors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_alert_rounded),
            label: 'Subscribe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Color.fromARGB(255, 223, 212, 212),
        selectedItemColor: Colors.amber[900],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (content) => SubjectScreen(
                      user: widget.user,
                    )));
      }
      if (_selectedIndex == 1) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (content) => TutorScreen(
                      user: widget.user,
                    )));
      }
      if (_selectedIndex == 2) {}
      if (_selectedIndex == 3) {}
      if (_selectedIndex == 4) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (content) => ProfileScreen(
                      user: widget.user,
                    )));
      }
    });
  }
}
