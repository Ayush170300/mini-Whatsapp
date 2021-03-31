
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:mini_whatsapp/Front_Screen.dart';

File image;
String name;
String phn;
User user;

final _cloudstore=FirebaseFirestore.instance;
class AddPhotoName extends StatefulWidget {
  @override
  _AddPhotoNameState createState() => _AddPhotoNameState();
}

class _AddPhotoNameState extends State<AddPhotoName> {
 
  addPhotofromGallary()async{
    final pickedimage= await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      image=File(pickedimage.path);

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user=FirebaseAuth.instance.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Welcome to WhatsApp'),
          centerTitle: true,
          backgroundColor:Color(0xff005D52),
          actions: <Widget>[
            GestureDetector(
              onTap: (){
                SpinKitRotatingCircle(
                  color: Colors.white,
                  size: 50.0,
                );
                if(name.isNotEmpty){
                  phn=user.phoneNumber;
                  _cloudstore.collection('User Details').add({'phn':user.phoneNumber,'name':name});
                  if(image!=null) {
                    final storage = FirebaseStorage.instance.ref().child(
                        '$phn');
                    StorageUploadTask task = storage.putFile(image);
                  }
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Frontscreen()));

                }
              },
                child: Icon(Icons.check)),
            SizedBox(width: 10,),
          ],

        ),
        body: SingleChildScrollView(
          child: Column(

            children: <Widget>[
              SizedBox(height: 20,),
              Center(
                child: CircleAvatar( backgroundImage:(image!=null)?FileImage(image):null,radius: 60,backgroundColor:Colors.white,child:(image!=null)?null:Icon(Icons.account_circle,color: Colors.grey[300],size: 120,)),
              ),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Visibility(
                    visible: image==null?true:false ,
                    child: GestureDetector(
                        onTap: addPhotofromGallary,
                        child: Center(child: Text('Add Photo',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.grey[600]),),)),
                  ),

                  Visibility(
                    visible: image!=null?true:false,
                    child: GestureDetector(
                        onTap: (){
                          setState(() {
                            image=null;
                          });
                         },
                        child: Center(child: Text('Remove Photo',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.grey[600]),),)),
                  ),
                ],
              ),
              SizedBox(height:30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 10,),
                  Expanded(
                    flex: 4,
                    child: TextField(
                         onChanged: (value){
                           setState(() {
                             name=value;
                           });
                         },
                      keyboardType:TextInputType.text,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[100],
                        filled: true,
                        hintText: 'Name',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal,width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal,width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 150,)


                ],
              ),
              SizedBox(height: 10,),
              Align(alignment:Alignment.topLeft,child: Text('Your UserName and photo will apear in your profile to the other users',style: TextStyle(color: Colors.grey,fontSize: 15),))
            ],

          ),
        ),
      ),
    );
  }
}



