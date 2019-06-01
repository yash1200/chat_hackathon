import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_hackathon/ChatUI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      uid = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10))),
      child: FutureBuilder(
          future: Firestore.instance
              .collection('messages')
              .orderBy('time', descending: true)
              .getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
                ),
              );
            } else {
              return ListView.builder(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                itemBuilder: (context, index) {
                  return buildItem(context, snapshot.data.documents[index]);
                },
                itemCount: snapshot.data.documents.length,
              );
            }
          }),
    );
  }

  Widget buildItem(BuildContext context, document) {
    if (uid == document['id1']) {
      return Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ChatUI(
                    chatUserId: document['nickname2'],
                    userId: document['id1'],
                    customId: document['id2'],
                    photoUrl: document['photoUrl2']);
              }));
            },
            title: Text(
              document['nickname2'],
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              document['lastmessage'],
              style: TextStyle(color: Colors.black,),
            ),
            isThreeLine: true,
            leading: Material(
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.indigo),
                      ),
                      width: 60.0,
                      height: 60.0,
                      padding: EdgeInsets.all(15.0),
                    ),
                imageUrl: document['photoUrl2'],
                width: 60.0,
                height: 60.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
            ),
          ),
          Divider(
            height: 1,
            color: Color(0xff2979ff),
          )
        ],
      );
    } else if (uid == document['id2']) {
      return Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ChatUI(
                    chatUserId: document['nickname1'],
                    userId: document['id2'],
                    customId: document['id1'],
                    photoUrl: document['photoUrl1']);
              }));
            },
            title: Text(
              document['nickname1'],
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            isThreeLine: true,
            subtitle: Text(
              document['lastmessage'],
              style: TextStyle(color: Colors.black),
            ),
            leading: Material(
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.indigo),
                      ),
                      width: 60.0,
                      height: 60.0,
                      padding: EdgeInsets.all(15.0),
                    ),
                imageUrl: document['photoUrl1'],
                width: 60.0,
                height: 60.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
            ),
          ),
          Divider(
            height: 1,
            color: Color(0xff2979ff),
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
