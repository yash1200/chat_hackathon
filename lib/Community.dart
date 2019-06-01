import 'package:chat_hackathon/ChatUI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

// ignore: camel_case_types
class Community extends StatefulWidget {
  @override
  _CommunityState createState() => _CommunityState();
}

// ignore: camel_case_types
class _CommunityState extends State<Community> {
  FirebaseUser firebaseUser;
  String userid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      userid = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: FutureBuilder(
        future: Firestore.instance
            .collection('users')
            .orderBy('nickname', descending: false)
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
        },
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    String id = document['id'].toString();
    String name = document['nickname'].toString();
    print("userid is:$userid");
    print("Document id:$id");
    if (userid != id) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: ListTile(
              title: Text(
                "$name",
                style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 18),
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
                  imageUrl: document['photoUrl'],
                  width: 60.0,
                  height: 60.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.message,
                  color: Color(0xff2979ff),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return ChatUI(chatUserId: name,
                        userId: userid,
                        customId: id,
                        photoUrl: document['photoUrl']);
                  }));
                },
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
