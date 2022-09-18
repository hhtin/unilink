import 'package:flutter/material.dart';

class PreCallPage extends StatefulWidget {
  @override
  _PreCallPageState createState() => _PreCallPageState();
}

class _PreCallPageState extends State<PreCallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          Container(
            child: Image.asset("assets/icons/avatar-long.jpg",
                width: 100, height: 100),
          )
        ],
      )),
    );
  }
}
