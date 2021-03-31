import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_whatsapp/Chat_Screen.dart';
import 'package:mini_whatsapp/Front_Screen.dart';
import 'package:mini_whatsapp/Otp.dart';

final firebaseAuth=FirebaseAuth.instance;
PhoneAuthCredential authCredential;

var phone;
var code;
final _textEditingController=TextEditingController();
class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:  Color(0xff005D52),
        title: Text('Verify your phone number'),
        actions: <Widget>[
          Icon(Icons.more_vert),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all( 15),
            child: Text('WhatsApp will send an SMS message to verify your phone Number.Enter your country code and phone number.',

              style: TextStyle(
                fontSize: 15,
                height: 1.5,
              ),

            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right:80.0),
            child: TextField(
              keyboardType:TextInputType.text ,

              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                hintText: 'Country',

                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 1.0),

                ),
                focusedBorder:  UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal[600], width: 2.0),
                ),
              suffixIcon: Icon(Icons.arrow_drop_down,color: Colors.teal,),
              ),
            ),
          ),
            SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(right:20.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.add,color: Colors.grey,),
                Expanded(
                  flex: 1,
                  child: TextField(
                    onChanged: (value){
                      code=value;
                    },
                    keyboardType:TextInputType.phone ,

                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal, width: 1.0),

                      ),
                      focusedBorder:  UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal[600], width: 2.0),

                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  flex: 5,
                  child: TextField(
                    onChanged: (value){
                      phone=value;
                    },
                     controller: _textEditingController,
                    keyboardType:TextInputType.phone ,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'Mobile No.',


                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal, width: 1.0),

                      ),
                      focusedBorder:  UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal[600], width: 2.0),

                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                RawMaterialButton(
                  onPressed: ()async{
                    _textEditingController.clear();
                    phone='+'+code+phone;
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Otp()));
                  },
                  child:  Icon(Icons.arrow_forward,color: Colors.white,),
                  fillColor: Colors.green,
                  shape: CircleBorder(side: BorderSide.none),
                  constraints: BoxConstraints.tightFor(width: 40, height: 40),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}
