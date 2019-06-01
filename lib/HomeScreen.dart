import 'package:chat_hackathon/Chat.dart';
import 'package:chat_hackathon/Community.dart';
import 'package:chat_hackathon/Moments.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _cIndex = 1;

  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
    });
  }

  final widgets = [
    Moment(),
    Chat(),
    Community(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.white),
        child: BottomNavigationBar(
          elevation: 35,
          currentIndex: _cIndex,
          backgroundColor: Colors.white,
          fixedColor: Colors.white,
          type: BottomNavigationBarType.shifting,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.event_note, color: Color(0xff2979ff)),
                title: new Text(
                  'Moments',
                  style: TextStyle(color: Color(0xff2979ff)),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.message, color: Color(0xff2979ff)),
                title: new Text(
                  'Chats',
                  style: TextStyle(color: Color(0xff2979ff)),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.people, color: Color(0xff2979ff)),
                title: new Text(
                  'Community',
                  style: TextStyle(color: Color(0xff2979ff)),
                )),
          ],
          onTap: (index) {
            _incrementTab(index);
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Color(0xff2979ff),
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    'assets/communication.png',
                    height: 40,
                    width: 40,
                  ),
                  Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: MediaQuery.of(context).size.height / 1.25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10)),
                  color: Colors.white),
              child: widgets[_cIndex],
            ),
          )
        ],
      ),
    );
  }
}
