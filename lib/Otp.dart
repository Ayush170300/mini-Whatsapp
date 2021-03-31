import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_whatsapp/AddPhotoName.dart';
import 'package:mini_whatsapp/RegistrationPage.dart';
PhoneAuthCredential authCredential;
String sms;
int tick=0;
String usersms;
int forcerescendingtoken;
int flag=0;
int length;
String verificationid;


final  _textEditingController=TextEditingController();
class Otp extends StatefulWidget {
  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  void codeSent(id,token)async{
    try {
      verificationid=id;
      forcerescendingtoken=token;
      if(length==6) {
        usersms = sms;
        PhoneAuthCredential authCredential;
        authCredential = PhoneAuthProvider.credential(
            verificationId: id, smsCode: usersms);

        await firebaseAuth.signInWithCredential(authCredential);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AddPhotoName()));
      }

    }
    catch(e){
      print(e);
    }
  }
  void verifyPhone(){

    firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        forceResendingToken: forcerescendingtoken,
        timeout: Duration(seconds: 60),
        verificationCompleted: (phoneAuthCredential)async{
          authCredential=phoneAuthCredential;
          _textEditingController.text = phoneAuthCredential.smsCode;
          _textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: _textEditingController.text.length));
          setState(() {});
          try {
            await firebaseAuth.signInWithCredential(phoneAuthCredential);
            setState(() {
              tick=45;
            });

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AddPhotoName()));
          }
          catch(e){
            print(e);
          }
        },
        verificationFailed: (e){
          print("Firbase:$e");
        },
        codeSent:codeSent,
        codeAutoRetrievalTimeout: (verificationId){
          print(verificationId);
          print('Timeout');
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verifyPhone();
//      Timer.periodic(Duration(seconds: 1),(timer){
//        print(tick);
//        if(tick==45)
//          timer.cancel();
//        setState(() {
//          tick=timer.tick;
//        });







  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
//        backgroundColor:  Color(0xff005D52),
        backgroundColor: Colors.white,

          title: Text('Verify $phone'),
          textTheme: TextTheme(headline6: TextStyle(color:  Colors.teal,fontSize: 20,fontWeight: FontWeight.bold)),
          actions: <Widget>[
            Icon(Icons.more_vert,color:Color(0xff005D52) ,),
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all( 15),
              child: Text('Waiting to Automatically detect SMS Send to $phone',

                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                ),

              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:120.0,vertical: 0),
              child: TextField(

                onChanged: (value){
                  setState(() {
                    sms=value;
                    length=sms.length;
                    if(length==6){
                      codeSent(verificationid,forcerescendingtoken);
                    }
                  });
                  },

                style: TextStyle(fontSize: 25,letterSpacing: 5),

                controller: _textEditingController,

                keyboardType:TextInputType.phone ,
                decoration: InputDecoration(

                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 1.0),

                  ),
                  focusedBorder:  UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal[600], width: 2.0),

                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(child: Text('Enter 6-digit code',style: TextStyle(color: Colors.grey[600]),)),

            ),
            GestureDetector(
              onTap: () async{
                if (tick == 5) {
                   verifyPhone();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(Icons.message,color: Colors.grey,),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(child: Text('Resend SMS',style: TextStyle(color: Colors.grey[600]),)),

                  ),
                  Center(child: Text('00:${45-tick}',style: TextStyle(color: Colors.grey[600]),)),


                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
