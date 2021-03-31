import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Contacts.dart';

User sender=FirebaseAuth.instance.currentUser;
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

AnimationController _animationController1, _animationController2;
IconData icondata = Icons.mic;
String message;
final firestore = FirebaseFirestore.instance;
final _textEditingController=TextEditingController();
class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  int prevlen = 0;
  bool attachmaterialvisibility = false;
  int attachcount = 0;
  @override
  void initState() {
    super.initState();
    attachcount = 0;
    _animationController1 = AnimationController(
      vsync: _ChatScreenState(),
      duration: Duration(milliseconds: 70),
      lowerBound: 0,
      upperBound: 30,
      value: 30,
    );
    _animationController2 = AnimationController(
      vsync: _ChatScreenState(),
      duration: Duration(milliseconds: 70),
      lowerBound: 0,
      upperBound: 25,
      value: 25,
    );

    _animationController1.addListener(() {
      setState(() {});
      print(_animationController1.value);
    });
  }

  @override
  void dispose() {
    _animationController1.dispose(); // TODO: implement dispose
    _animationController2.dispose();
    super.dispose();


  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          setState(() {
            attachmaterialvisibility = false;
          });
        },
        child: Scaffold(
          backgroundColor: Colors.grey,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SafeArea(
                child: Container(
                  color: Color(0xff005D52),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        CircleAvatar(
                          radius: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '$receiverFromContacts',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'online',
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 140,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right:10.0),
                          child: Icon(
                            Icons.videocam,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:10.0),
                          child: Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            FirebaseAuth.instance.signOut();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left:10.0),
                            child: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              MessageStream(),
              Visibility(
                visible: attachmaterialvisibility,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              AttachCircleavtar(
                                  color: Colors.deepPurple,
                                  icon: Icons.insert_drive_file),
                              AttachCircleavtar(
                                  color: Colors.teal, icon: Icons.camera_alt),
                              AttachCircleavtar(
                                  color: Colors.deepOrange,
                                  icon: Icons.headset),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 50),
                                child: Text('Document'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 50.0),
                                child: Text('Camera'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 70),
                                child: Text('Audio'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              AttachCircleavtar(
                                  color: Colors.green, icon: Icons.location_on),
                              AttachCircleavtar(
                                  color: Colors.purple,
                                  icon: Icons.photo_library),
                              AttachCircleavtar(
                                  color: Colors.blue, icon: Icons.contacts),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 55.0),
                                child: Text('Location'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 60.0),
                                child: Text('Gallary'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 60.0),
                                child: Text('Contacts'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(80)),
                        elevation: 1,
                        child: Row(children: <Widget>[
                          SizedBox(width: 10),
                          Icon(
                            Icons.insert_emoticon,
                            color: Colors.grey[700],
                          ),
                          Expanded(
                            child: TextField(
                              controller: _textEditingController,
                              onChanged: (tyvalue) async {
                                if (tyvalue.length == 0) {
                                  await _animationController1.reverse();

                                  icondata = Icons.mic;
                                  _animationController2.forward();
                                  _animationController1.forward();
                                } else if (tyvalue.length == 1 &&
                                    prevlen == 0) {
                                  await _animationController1.reverse();
                                  icondata = Icons.send;
                                  _animationController2.reverse();
                                  _animationController1.forward();
                                }
                                prevlen = tyvalue.length;
                                message = tyvalue;
                              },
                              decoration: InputDecoration(
                                hintText: 'Type a message',
                                hintStyle: TextStyle(
                                    color: Color(0xff878990), fontSize: 18),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              attachcount++;
                              setState(() {
                                attachcount % 2 == 0
                                    ? attachmaterialvisibility = false
                                    : attachmaterialvisibility = true;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.attachment,
                                color: Colors.grey[700],
                                size: 25,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                                (_animationController2.value * 10) / 25),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[700],
                              size: _animationController2.value,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  RoundDoubleUseButton(),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageBox extends StatelessWidget {
  final double radius = 8;
  final text;
  final time;
  MessageBox({this.text, this.time});

//  MessageBox({this.sender,this.receiver,this.text,this.time});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right:8.0,top: 5),
      child: Align(
        alignment: Alignment.topRight,
        child: Material(
          elevation: 1,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(radius),
              bottomRight: Radius.circular(radius),
              bottomLeft: Radius.circular(radius),
              topLeft: Radius.circular(radius)),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 300,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color(0xffE2FECA),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                  bottomLeft: Radius.circular(radius),
                  topLeft: Radius.circular(radius)),
            ),

            child: Column(
              textBaseline: TextBaseline.alphabetic,
                 crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                  child: Text(
                    '$text',
                    style: TextStyle(fontSize: 17, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right:5.0,left: 5.0),
                  child: Text(
                    '$time',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AttachCircleavtar extends StatelessWidget {
  @override
  final Color color;
  final IconData icon;
  AttachCircleavtar({@required this.color, @required this.icon});
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: color,
        child: Icon(
          icon,
        ),
      ),
    );
  }
}

class RoundDoubleUseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Color(0xff005D52),
      onPressed: () {
        _textEditingController.clear();
        if (message != null){
          var hour = (new DateTime.now()).hour;
          var minute=(((new DateTime.now()).minute)%60).round();
          String time;
               if( hour>12&& (minute%10==minute))
                 time='$hour:0$minute PM';
          else if( hour>12&& (minute%10!=minute))
            time='$hour:$minute PM';
               else if( hour<12&& (minute%10==minute))
                 time='$hour:0$minute AM';
               else
                 time='$hour:$minute PM';

          firestore.collection('messages').add({
            'text': message,
            'sender': sender.phoneNumber,
            'time': '$time',
            'receiver':receiverFromContacts,
            'order':FieldValue.serverTimestamp(),
          });
        }

        else
          print('no message');
      },
      onLongPress: () {},
      shape: CircleBorder(side: BorderSide.none),
      constraints: BoxConstraints.tightFor(width: 56, height: 56),
      child: Icon(icondata,
          color: Colors.white, size: _animationController1.value),
    );
  }
}
class MessageStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('messages').orderBy('order', descending: false).where('sender',whereIn: [sender.phoneNumber,receiverFromContacts]).snapshots(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final messages = snapshot.data.docs.reversed;



        List<MessageBox> messageBubbleList = [];
        for (final message in messages) {

          String messagetext = message.data()['text'];
          String sender = message.data()['sender'];
          String time=message.data()['time'];



           messageBubbleList.add(MessageBox(
            text: messagetext,
            time:time,
          ));

        }

        return Expanded(
          child: ListView(

            reverse: true,
            children: messageBubbleList,

          ),
        );
      },
    );
  }
}


