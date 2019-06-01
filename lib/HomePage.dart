import 'package:chat_hackathon/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> getUser() async {
    return await FirebaseAuth.instance.currentUser();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser().then((_firebaseUser) {
      if (_firebaseUser != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    });
  }

  Future<FirebaseUser> _signIn(BuildContext context) async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: gSA.accessToken,
      idToken: gSA.idToken,
    );
    final FirebaseUser firebaseUser =
        await _auth.signInWithCredential(credential);
    if (firebaseUser != null) {
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .setData({
          'email': firebaseUser.email,
          'nickname': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoUrl,
          'id': firebaseUser.uid
        });
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomeScreen();
      }));
    }
    print("User Name : ${firebaseUser.displayName}");
    return firebaseUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Image.asset(
                'assets/cover.jpg',
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height / 2,
              ),
            ),
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/communication.png',
                    height: 100,
                    width: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Text(
                      'Welcome To DevChat',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    'Chat with over 2+ Developers',
                    style: TextStyle(color: Colors.grey, fontSize: 17),
                  ),
                  InkWell(
                    onTap: () {
                      _signIn(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 120, right: 120, top: 10, bottom: 10),
                        child: Text(
                          'Continue',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Made with ❤️ in ',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        Text(
                          '#Hack19',
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
