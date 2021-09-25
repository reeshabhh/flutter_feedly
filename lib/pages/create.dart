// import 'dart:html';
// import 'dart:io';

// import 'dart:html';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _postTextController =
      TextEditingController(text: '');
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // File? _image;
  XFile? _image;

  String? user_uid;
  String? user_display_name;

  _post() async {
    if (_postTextController.text.trim().length == 0) {
      // _key.currentState!.showSnackBar(
      //   SnackBar(
      //     content: Text('Please enter some text'),
      //   ),
      // );
      return;
    }
    DocumentReference ref;
    try {
      debugPrint('inside try ***************');
      ref = await _firestore.collection('posts').add(
        {
          'text': _postTextController.text.trim(),
          
          // TODO: owner name is null fix it 
          'owner_name': user_display_name,
          'owner': user_uid,
          'created': DateTime.now(),
          'likes': {},
          'likes_count': 0,
          'comments_count': 0,
        },
      );

      if (_image != null) {
        String _url = await _uploadImageAndGetUrl(
          ref.id,
          File(_image!.path),
        );

      await  ref.update({
          'image': _url,
        });
      }

      // _key.currentState!.showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       'Post created successfully',
      //     ),
      //   ),
      // );
      Future.delayed(
        Duration(seconds: 1),
        () {
          Navigator.pop(context);
        },
      );
    } catch (e) {
      // // _key.currentState!.showSnackBar(
      // //   SnackBar(
      // //     content: Text(
      // //       e.toString(),
      // //     ),
      // //   ),
      // );
    }
  }

  _showModelBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: (Icon(Icons.camera_alt)),
              title: Text('Camera'),
              onTap: () async {
                // TODO: Use image_picker plugin
                XFile? image = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                  maxHeight: 480,
                  maxWidth: 480,
                );

                setState(() {
                  _image = image;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
                leading: (Icon(
                  Icons.photo_album,
                )),
                title: Text('Photo Album'),
                onTap: () async {
                  // TODO: Use image_picker plugin

                  XFile? image = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    maxHeight: 480,
                    maxWidth: 480,
                  );

                  setState(() {
                    _image = image;
                  });

                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }

  Future<String> _uploadImageAndGetUrl(String fileName, File file) async {
    FirebaseStorage _storage = FirebaseStorage.instance;

    UploadTask _task = _storage.ref().child(fileName).putFile(
          file,
          SettableMetadata(contentType: 'image/png'),
        );
    final String _downloadURL = await (await _task).ref.getDownloadURL();
    return _downloadURL;
  }

  @override
  void initState() {
    super.initState();

    User? user = _firebaseAuth.currentUser;

    // final User user = await _firebaseAuth.currentUser();
    user_uid = user!.uid;
    user_display_name = user.displayName;

    // await _firebaseAuth.currentUser

    //   (User user) {
    //     user_uid = user.uid;
    //     user_display_name = user.displayName;
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: const Text('Compose new post'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepOrange.withOpacity(0.2),
                ),
              ),
              child: TextField(
                controller: _postTextController,
                maxLines: 5,
                maxLength: 300,
                decoration: const InputDecoration(
                  hintText: 'Write something here ... ',
                  border: InputBorder.none,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30.0,
                          ),
                        ),
                        // primary: Colors.deepOrange,
                        backgroundColor: Colors.deepOrange,
                      ),
                      onPressed: () {
                        _showModelBottomSheet();
                      },
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
                            child: Text(
                              'Add image',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Icon(
                            Icons.add_photo_alternate,
                            color: Colors.white,
                            size: 16.0,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30.0,
                          ),
                        ),
                        // primary: Colors.deepOrange,
                        backgroundColor: Colors.deepOrange,
                      ),
                      onPressed: () {
                        _post();
                      },
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
                            child: Text(
                              'Create post',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 16.0,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _image == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              child: Image.file(
                                File(_image!.path),
                                fit: BoxFit.cover,
                              ),
                              width: 150,
                              height: 150,
                            ),
                            Positioned(
                              top: 4.0,
                              right: 4.0,
                              child: IconButton(
                                icon: Icon(Icons.close),
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
