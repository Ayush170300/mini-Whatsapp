import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Chat_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import'Contacts.dart';

final firestore=FirebaseFirestore.instance;
User user=FirebaseAuth.instance.currentUser;
class Frontscreen extends StatefulWidget {
  @override
  _FrontscreenState createState() => _FrontscreenState();
}

class _FrontscreenState extends State<Frontscreen> {
 final  _controller= PageController(
   initialPage: 0,
 );



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 140,
              color: Color(0xff005D52),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Text(
                          'WhatsApp',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                      ),
                      Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      SizedBox(width: 20),
                      Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white54,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        child: Text(
                          "CHATS",
                          style: TextStyle(
                              color: Colors.white54,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        child: Text(
                          "STATUS",
                          style: TextStyle(
                              color: Colors.white54,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        child: Text(
                          "CALLS",
                          style: TextStyle(
                              color: Colors.white54,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ChatStream(),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: FloatingActionButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder:(context)=>Contacts())).asStream();
              },
              child: Icon(Icons.message),
              backgroundColor: Color(0xff1FC75A),
              elevation: 4,
            ),
          ),

        ),
          ],
        ),
      ),
    );
  }
}

class ChatStream extends StatelessWidget {
  List<String> receivers=[];
  List<ChatBox> chatBubbleList = [];
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: (firestore.collection('messages').orderBy('order', descending: false).snapshots()),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return Visibility(
            visible: true,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            ),
          );
        }

        final messages = snapshot.data.docs;






        for (final message in messages) {
          int count = 0;
          String messagetext = message.data()['text'];
          String sender = message.data()['sender'];
          String time = message.data()['time'];
          String currReceiver = message.data()['receiver'];
          if (messagetext.length > 5) {
            messagetext = messagetext.substring(0, 5);
            messagetext += '...';
          }
          if ((sender == user.phoneNumber) | (currReceiver == user.phoneNumber)) {
            for (var receiver in receivers) {
              if (receiver == currReceiver)
                break;
              count++;
            }

            if (count == receivers.length) {
              print('add');
              receivers.add(currReceiver);
              chatBubbleList.add(ChatBox(receiver: currReceiver,
                time: time,
                sender: sender,
                text: messagetext,));
            }

            else {
              print('insert');
              chatBubbleList.removeAt(count);
              chatBubbleList.insert(count, ChatBox(receiver: currReceiver,
                time: time,
                sender: sender,
                text: messagetext,));
            }


            print(time);
          }
        }



        return Expanded(
          child: ListView(

            
            children: chatBubbleList,

          ),
        );
      },
    );
  }
}


class ChatBox extends StatelessWidget {

 final String receiver;
  final String time;
  final String sender;
  final String text;

  ChatBox({this.receiver,this.time,this.sender,this.text});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      child: Material(
        color: Colors.white,
        child:Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                  ),

                  Row(

                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[
                          Text('$receiver',style: TextStyle(color: Colors.black,fontSize: 20),),
                          SizedBox(height: 5,),
                          Text('$sender:$text',style: TextStyle(color: Colors.grey[900],fontSize: 14),),


                        ],
                      ),
                       SizedBox(width: 100,),
                      Text('$time',style: TextStyle(color: Colors.grey,fontSize:13 ),)
                    ],
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
                thickness: 0.5,
                indent: 70,
              ),
            ],
          ),
        ),

      ),
    );
  }
}
