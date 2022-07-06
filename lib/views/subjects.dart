import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor_final_project/views/profilescreen.dart';
import 'package:mytutor_final_project/views/tutor.dart';
import '../constant.dart';
import '../models/palette.dart';
import '../models/subjects.dart';
import '../models/user.dart';
import 'cartscreen.dart';

class SubjectScreen extends StatefulWidget {
  final User user;
  const SubjectScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<SubjectScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectScreen> {
  List<Subjects> subjects = <Subjects>[];
  String titlecenter = "Loading....";
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  var _tapPosition;
  var numofpage, curpage = 1;
  var color;
  TextEditingController searchController = TextEditingController();
  String search = "";
  int _selectedIndex = 0;
  String dropdownvalue = 'All';
  var subrating = [
    'All',
    '5.0',
    '4.5',
    '4.0',
    '3.5',
    '3.0',
    '2.5',
    '2.0',
    '1.5',
    '1.0',
    '0',
  ];
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
    _loadSubjects(1, search, dropdownvalue);
    _loadMyCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      //rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount = 3;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subjects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _loadSearchDialog();
            },
          ),
          TextButton.icon(
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => CartScreen(
                            user: widget.user,
                          )));
              _loadSubjects(1, search, dropdownvalue);
              _loadMyCart();
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            label: Text(widget.user.cart.toString(),
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
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
        child: subjects.isEmpty
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  children: [
                    Center(
                        child: Text(titlecenter,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                  ],
                ),
              )
            : Column(children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text("Subjects Available",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                ),
                Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (0.60 / 1),
                        children: List.generate(subjects.length, (index) {
                          return InkWell(
                            splashColor: Colors.amber,
                            onTap: () => {_loadSubjectDetails(index)},
                            onTapDown: _storePosition,
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  children: [
                                    Flexible(
                                      flex: 6,
                                      child: CachedNetworkImage(
                                        imageUrl: CONSTANTS.server +
                                            "/mytutor/mobile/assets/courses/" +
                                            subjects[index].id.toString() +
                                            '.png',
                                        fit: BoxFit.cover,
                                        width: resWidth,
                                        placeholder: (context, url) =>
                                            const LinearProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    Flexible(
                                        flex: 4,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 7,
                                                  child: Column(children: [
                                                    Text(
                                                      subjects[index]
                                                          .name
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "RM " +
                                                          double.parse(subjects[
                                                                      index]
                                                                  .price
                                                                  .toString())
                                                              .toStringAsFixed(
                                                                  2),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      subjects[index]
                                                              .sessions
                                                              .toString() +
                                                          " sessions",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      double.parse(subjects[
                                                                      index]
                                                                  .rating
                                                                  .toString())
                                                              .toStringAsFixed(
                                                                  2) +
                                                          " stars",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ]),
                                                ),
                                                Expanded(
                                                    flex: 3,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          _addtocartDialog(
                                                              index);
                                                        },
                                                        icon: const Icon(Icons
                                                            .shopping_cart))),
                                              ],
                                            ),
                                          ],
                                        ))
                                  ],
                                )),
                          );
                        }))),
                SizedBox(
                  height: 30,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if ((curpage - 1) == index) {
                        color = Colors.amber;
                      } else {
                        color = Colors.black;
                      }
                      return SizedBox(
                        width: 40,
                        child: TextButton(
                            onPressed: () => {
                                  _loadSubjects(
                                      index + 1, search, dropdownvalue)
                                },
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: color),
                            )),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ]),
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

  void _loadSubjects(int pageno, String _search, String _subrating) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/load_subject.php"),
        body: {
          'pageno': pageno.toString(),
          'search': _search,
          'subrating': _subrating,
        }).then((response) {
      var jsondata = jsonDecode(response.body);

      print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);

        if (extractdata['subjects'] != null) {
          subjects = <Subjects>[];
          extractdata['subjects'].forEach((v) {
            subjects.add(Subjects.fromJson(v));
            titlecenter = "No Subject Available";
          });
        }
        setState(() {});
      }
    });
  }

  _loadSubjectDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Subject Details",
              style: TextStyle(),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: CONSTANTS.server +
                      "/mytutor/mobile/assets/courses/" +
                      subjects[index].id.toString() +
                      '.png',
                  fit: BoxFit.cover,
                  width: resWidth,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Text(
                  subjects[index].name.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text("",
                    style: TextStyle(
                        fontSize: 14.0,
                        height: 1 //You can set your custom height here
                        )),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text(
                    "Subject Description: ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subjects[index].description.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const Text("",
                      style: TextStyle(
                          fontSize: 14.0,
                          height: 1 //You can set your custom height here
                          )),
                  const Text(
                    "Price: ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "RM" +
                        double.parse(subjects[index].price.toString())
                            .toStringAsFixed(2),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const Text("",
                      style: TextStyle(
                          fontSize: 14.0,
                          height: 1 //You can set your custom height here
                          )),
                  const Text(
                    "Tutor Id In Charge: ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subjects[index].tutorid.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const Text("",
                      style: TextStyle(
                          fontSize: 14.0,
                          height: 1 //You can set your custom height here
                          )),
                  const Text(
                    "Tutor Name In Charge: ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subjects[index].tutorname.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const Text("",
                      style: TextStyle(
                          fontSize: 14.0,
                          height: 1 //You can set your custom height here
                          )),
                  const Text(
                    "Subject Sessions: ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subjects[index].sessions.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const Text("",
                      style: TextStyle(
                          fontSize: 14.0,
                          height: 1 //You can set your custom height here
                          )),
                  const Text(
                    "Subject Rating: ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    double.parse(subjects[index].rating.toString())
                            .toStringAsFixed(2) +
                        " stars",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ])
              ],
            )),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    // <-- TextButton
                    onPressed: () {
                      _addtocartDialog(index);
                    },
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                      size: 24.0,
                    ),
                    label: Text(
                      'Add to cart',
                      style: TextStyle(
                        color: Colors.black, //for text color
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
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

  void _loadSearchDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search ",
                ),
                content: SingleChildScrollView(
                  child: SizedBox(
                    height: screenHeight / 2.8,
                    child: Column(
                      children: [
                        TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                              labelText: 'Enter here to search',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Subjects rating = and above :",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 45,
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5.0))),
                          child: DropdownButton(
                            value: dropdownvalue,
                            underline: const SizedBox(),
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: subrating.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue = newValue!;
                              });
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            search = searchController.text;
                            Navigator.of(context).pop();
                            _loadSubjects(1, search, dropdownvalue);
                          },
                          child: const Text("Search"),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  void _addtocartDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Add to cart?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _addtoCart(index);
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addtoCart(int index) {
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/insert_cart.php"),
        body: {
          "email": widget.user.email.toString(),
          "subjectid": subjects[index].id.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString());
        setState(() {
          widget.user.cart = jsondata['data']['carttotal'].toString();
        });
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "You already added this course to cart.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _loadMyCart() {
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/load_mycartqty.php"),
        body: {
          "email": widget.user.email.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString());
        setState(() {
          widget.user.cart = jsondata['data']['carttotal'].toString();
        });
      }
    });
  }
}
