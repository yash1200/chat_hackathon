import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Moment extends StatefulWidget {
  @override
  _MomentState createState() => _MomentState();
}

class _MomentState extends State<Moment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _selectImage(context);
          },
        ),
        body: Container(
          height: MediaQuery.of(context).size.height / 1.8,
          child: Card(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          'Aayushman Choudhary',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      Icon(
                        Icons.more_vert,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
                Text(
                  'Having Fun in #Hack19',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                Image.asset(
                  'assets/pp.jpeg',
                  height: MediaQuery.of(context).size.height / 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _selectImage(BuildContext parentContext) async {
    File file;
    return showDialog<Null>(
      context: parentContext,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  File imageFile = await ImagePicker.pickImage(
                      source: ImageSource.camera,
                      maxWidth: 1920,
                      maxHeight: 1350);
                  setState(() {
                    file = imageFile;
                  });
                }),
            SimpleDialogOption(
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  File imageFile =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    file = imageFile;
                  });
                }),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
