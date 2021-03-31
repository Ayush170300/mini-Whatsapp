

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'Chat_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List contactsList=[];
String receiverFromContacts;
final _auth=FirebaseAuth.instance;

class Contacts extends StatefulWidget {


  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {

 QuerySnapshot snapshot;
  bool flag;
  getPermissionStatus()async{


    var status=await Permission.contacts.request();
    if(status.isGranted){
      print('granted');

      snapshot= await FirebaseFirestore.instance.collection('User Details').get();
      List<Contact>_contacts=(await ContactsService.getContacts(withThumbnails:false )).toList();
         print(_contacts.length);
         print(_contacts[7].displayName);
      setState(() {
        for(var contact in _contacts){

          try {
            if (contact.phones.first.value.isNotEmpty)
              contactsList.add(contact);
          }
          catch(e){
            continue;
          }
        }

        flag=true;
      });


    }
    if(status.isDenied){
      print('denied');
    }
    if(status.isPermanentlyDenied){
      openAppSettings();
    }

  }


  bodyContent(){

       return ListView.builder(
           itemCount: contactsList.length,
          shrinkWrap: true,
          itemBuilder: (context,index) {
            print(index);
       Contact contact=contactsList[index];
       bool f;
       final messages=snapshot.docs;
       String contactno;
          f = false;
            var comingphn = contact.phones.first.value;

          contactno = comingphn.replaceAll(' ', '');
          print(contactno.trim());
          for (var message in messages) {
            String phn = message.data()['phn'];
            phn = phn.substring(3);
            print('phn:$phn');
            print('contact:$contactno');

            if (contactno.contains(phn)) {
              f = true;
              break;
            }
          }
          if (f== true) {
            return GestureDetector(
              onTap: () {
                receiverFromContacts=contact.displayName;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Text(
                        contact.displayName, style: TextStyle(fontSize: 20,),),
                    ),

                    Expanded(
                      flex: 1,
                      child: RaisedButton(onPressed: () {
                        receiverFromContacts=contact.displayName;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ChatScreen()),);
                      },
                        color: Colors.teal,
                        child: Text(
                          'message', style: TextStyle(color: Colors.white,),),
                        elevation: 2,),
                    ),
                  ],
                ),
              ),
            );
          } else
            return GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Text(
                        contact.displayName, style: TextStyle(fontSize: 20,),),
                    ),

                    Expanded(
                      flex: 1,
                      child: RaisedButton(onPressed: () {},
                        color: Colors.green,
                        child: Text(
                          'invite', style: TextStyle(color: Colors.white,),),
                        elevation: 2,),
                    ),
                  ],
                ),
              ),
            );

      });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     getPermissionStatus();
  }
  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff005D52),
        leading: Icon(Icons.arrow_back),
         title: Text('Select contact'),
        actions: <Widget>[


          Icon(Icons.search),
          SizedBox(width: 10,),
          Icon(Icons.more_vert),
          SizedBox(width: 10,),
          
        ],
      ),

      body:flag==true?bodyContent():Container(
        child: Center(child: CircularProgressIndicator(valueColor:new AlwaysStoppedAnimation<Color>(Colors.teal),),
      ),


      )
    );
  }
}
