import 'package:flutter/material.dart';

class CompaniesScreen2 extends StatelessWidget {
  const CompaniesScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body:SizedBox(
        height:height,
        width:width,
        child:Stack(
          children:[
            Stack(children:[
             Container(
               height:height/1.4,
               width:width,
               color:Colors.white
              ),
              Container(
                height:height/1.4,
                width:width,
                decoration:BoxDecoration(
                  color:Colors.amber,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(70))
                )
              )
            ])
          ]
        )
      )
    );
  }
}
