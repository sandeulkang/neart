import 'package:flutter/material.dart';

class ChangeNameSt extends StatelessWidget {
  ChangeNameSt({Key? key, this.username}) : super(key: key);

  dynamic username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextFormField(
          initialValue: username,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              border: OutlineInputBorder(),),
        ),
      ),
    );
  }
}
