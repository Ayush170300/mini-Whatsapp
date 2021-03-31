import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
class Status extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return   Material(
      color: Colors.white,
      child:Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(

              children: <Widget>[
               Icon(
                 MdiIcons.accountPlus,
                 size: 50,
                 color: Colors.grey,
               ),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[
                    Text('My status',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                    SizedBox(height: 5,),
                    Text('Tap to add status update',style: TextStyle(color: Colors.grey[900],fontSize: 16),),

                  ],
                ),



              ],
            ),
            Divider(
              color: Colors.grey,
              thickness: 0.5,
            ),
          ],
        ),
      ),

    );
  }
}
