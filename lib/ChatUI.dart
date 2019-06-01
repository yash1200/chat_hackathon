import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatUI extends StatefulWidget {
  String chatUserId, userId, customId, photoUrl;
  File file;
  ChatUI(
      {Key key,
      @required this.chatUserId,
      @required this.userId,
      @required this.customId,
      @required this.photoUrl})
      : super(key: key);

  @override
  _ChatUIState createState() => _ChatUIState(
      chatUserId: chatUserId,
      userId: userId,
      customId: customId,
      photoUrl: photoUrl);
}

class _ChatUIState extends State<ChatUI> {
  String chatUserId, userId, customId, groupId, photoUrl, photoUrl2, username2;
  TextEditingController textEditingController = new TextEditingController();
  int times;

  _ChatUIState(
      {Key key,
      @required this.chatUserId,
      @required this.userId,
      @required this.customId,
      @required this.photoUrl});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readLocal();
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      username2 = user.displayName;
      photoUrl2 = user.photoUrl;
    });
  }

  readLocal() {
    if (userId.hashCode <= customId.hashCode) {
      groupId = '$userId-$customId';
    } else {
      groupId = '$customId-$userId';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatUserId),
      ),
      body: new Container(
        decoration: BoxDecoration(color: Colors.white),
        width: double.infinity,
        height: double.infinity,
        child: new Container(
          child: new Column(
            children: <Widget>[
              buildListMessages(),
              Divider(height: 1.0),
              typeMessage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget typeMessage() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 4),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              color: Color(0xffe6ecea)),
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          child: new Row(
            children: <Widget>[
              new Container(
                width: 48.0,
                height: 48.0,
                child: new IconButton(
                    icon: Icon(Icons.image), onPressed: () {
                      _selectImage(context);
                }),
              ),
              new Flexible(
                child: new TextField(
                  controller: textEditingController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: new InputDecoration.collapsed(
                      hintText: "Enter message",
                      hintStyle: TextStyle(color: Colors.black87)),
                ),
              ),
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 2.0),
                width: 48.0,
                height: 48.0,
                child: new IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    print(textEditingController.text);
                    setState(() {
                      sendMsg(textEditingController.text);
                    });
                  },
                ),
              )
            ],
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
                  File imageFile =
                  await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 1920, maxHeight: 1350);
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

  void sendMsg(String message) {
    if (message.trim() != '') {
      textEditingController.clear();
      Firestore.instance
          .collection('messages')
          .document(groupId)
          .collection(groupId)
          .document(DateTime.now().millisecondsSinceEpoch.toString())
          .setData({
        'idFrom': userId,
        'idTo': customId,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        'message': message,
      });
      Firestore.instance.collection('messages').document(groupId).setData({
        'nickname1': chatUserId,
        'photoUrl1': photoUrl,
        'id1': customId,
        'id2': userId,
        'lastmessage': message,
        'time': DateTime.now().millisecondsSinceEpoch.toString(),
        'photoUrl2': photoUrl2,
        'nickname2': username2,
      });
    }
  }

  Widget buildListMessages() {
    return Flexible(
        child: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('messages')
          .document(groupId)
          .collection(groupId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
            ),
          );
        } else {
          return ListView.builder(
            reverse: true,
            padding: EdgeInsets.all(10),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return buildMessages(index, snapshot.data.documents[index]);
            },
          );
        }
      },
    ));
  }

  buildMessages(int index, DocumentSnapshot document) {
    if (document['idFrom'] == userId) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                child: Text(
                  document['message'],
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                decoration: BoxDecoration(
                    color: Color(0xff2979ff),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        topRight: Radius.circular(0))),
              ),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  document['message'],
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                decoration: BoxDecoration(
                    color: Color(0xffeeeeee),
                    borderRadius: BorderRadius.circular(8.0)),
              )
            ],
          ),
        ),
      );
    }
  }
}
