import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_firbase/Todocard.dart';
import 'package:todo_firbase/ViewTodo.dart';
import 'package:todo_firbase/sign_up.dart';
import 'package:todo_firbase/todopage.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    super.key,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Stream<QuerySnapshot> _stream ;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Select> selected = [];

  final ImagePicker picker = ImagePicker();
  XFile? image;

  String? uploadedImageUrl;
  String? currentUserId;
  String userEmail = '';
   

  @override
  void initState() {
    super.initState();
    createUserDocument();
    _stream = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("todos")
      .snapshots();
   
  }


  Future<void> createUserDocument() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDocumentSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();

      if (userDocumentSnapshot.exists) {
        setState(() {
          uploadedImageUrl = userDocumentSnapshot.data()?['profileImageUrl'];
          userEmail = currentUser.email ?? '';
        });
      } else {
        // User document doesn't exist, create it here
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .set({'profileImageUrl': uploadedImageUrl});
      }
    } catch (e) {
      print("Error creating/updating user document: $e");
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: const Text(
            'Todays Schedule',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            Tooltip(
              message: "your profile",
              child: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
                child: CircleAvatar(
                  backgroundImage: getImage(),
                ),
              ),
            ),
            const SizedBox(
              width: 30,
            ),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(15),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 155, bottom: 5),
                  child: Text(
                    'Monday 21',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                )),
          ),
        ),
        endDrawer: uploadimage(),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 32,
                  color: Colors.white,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TodoPage()));
                },
                child: const Icon(Icons.add, size: 32, color: Colors.white),
              ),
              label: 'Add',
            ),
          ],
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: StreamBuilder<QuerySnapshot>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                                         
                        selected.add(Select(
                          id: snapshot.data!.docs[index].id,
                          checkValue: false));

                      return FutureBuilder<DocumentSnapshot>(
                        future: snapshot.data!.docs[index].reference.get(),
                        builder: (context, todoSnapshot) {
                          if (!todoSnapshot.hasData) {
                            return Center(child: Container());
                          }
                       Map<String, dynamic> todoData =  todoSnapshot.data!.data() as Map<String, dynamic>;
                      IconData iconData;
                      Color iconColor;
 
                      switch (todoData["Category"]) {
                        case "work":
                          iconData = Icons.run_circle_outlined;
                          iconColor = Colors.red;
                          break;
                        case "workout":
                          iconData = Icons.alarm;
                          iconColor = Colors.teal;
                          break;
                        case "food":
                          iconData = Icons.local_grocery_store;
                          iconColor = Colors.blue;
                          break;
                        case "Design":
                          iconData = Icons.audiotrack;
                          iconColor = Colors.green;
                          break;
                        case "Run":
                          iconData = Icons.run_circle;
                          iconColor = Colors.green;
                          break;
                        default:
                          iconData = Icons.run_circle_outlined;
                          iconColor = Colors.white;
                      }
                          return InkWell(
                            onTap: () {
                              String todoId = snapshot.data!.docs[index].id;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewTodo(
                                    todoData: todoData, // Pass the todoData
                                    id: todoId,
                                  ),
                                ),
                              ); 
                            },
                            child: TodoCard(
                              title: todoData["title"] ?? "Hey There",
                              iconData: iconData,
                              iconColor: iconColor,
                              time: todoData["selectedTime"] ?? "0:00",
                              index: index,
                              onChange: onChange,
                              check: selected[index].checkValue,
                              iconBgColor: Colors.white,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }

  Widget uploadimage() {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Stack(children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: getImage(),
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton.filled(
                        onPressed: () async {
                          image = await picker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            image = image;
                          });
                          if (image != null) {
                            Reference referenceRoot =
                                FirebaseStorage.instance.ref();
                            Reference referenceDirImages =
                                referenceRoot.child("Images");
                            String uniqueName = DateTime.now()
                                .millisecondsSinceEpoch
                                .toString();
                            Reference referenceImageToUpload =
                                referenceDirImages.child(uniqueName);
                            try {
                              await referenceImageToUpload
                                  .putFile(File(image!.path));
                              uploadedImageUrl =
                                  await referenceImageToUpload.getDownloadURL();
                              setState(() {});
                            } catch (e) {
                              print("Error uploading image: $e");
                            }
                          }
                        },
                        icon: const Icon(Icons.add_a_photo)),
                  ),
                ]),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                    onPressed: () async {
                      User? currentUserId = FirebaseAuth.instance.currentUser;
                      if (currentUserId != null) {
                        try {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .update({'profileImageUrl': uploadedImageUrl});
                        } catch (error) {
                          print("Error updating profile picture URL: $error");
                        }
                      }
                    },
                    child: const Text('Update Profile')),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                userEmail,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Groups',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Events',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            IconButton(
              onPressed: () {
                LogOut(context);
              },
              icon: const Icon(Icons.logout, size: 32, color: Colors.white),
            ),
            const SizedBox(
              height: 300,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings, size: 32, color: Colors.white),
            ),
            const Text('Settings')
          ],
        ),
      ),
    );
  }

 

  Future<void> LogOut(BuildContext context) async {
    final _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs.clear();
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Signup()),
        (route) => false);
  }

  void onChange(int index) {
    setState(() {
      selected[index].checkValue = !selected[index].checkValue;
    });
  }

  ImageProvider getProfileImageProvider() {
    if (uploadedImageUrl != null) {
      return NetworkImage(uploadedImageUrl!);
    } else if (image != null) {
      return FileImage(File(image!.path));
    }
    return const AssetImage('Assets/user.jpg');
  }

  ImageProvider getImage() {
    return getProfileImageProvider();
  }
}

class Select {
  String id;
  bool checkValue = false;
  Select({required this.id, required this.checkValue});
}
