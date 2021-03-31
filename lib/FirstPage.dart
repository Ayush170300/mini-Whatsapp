import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'RegistrationPage.dart';
import 'Front_Screen.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context,snaphot){
          if(snaphot.hasData) {

            return Frontscreen() ;
          }
          else
            return Registration();
    },
    );
  }
}
