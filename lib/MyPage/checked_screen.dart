import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Checked_screen1.dart';
import 'Checked_screen2.dart';

class CheckedScreen extends StatefulWidget {
  @override
  State<CheckedScreen> createState() => _CheckedScreenState();
}

class _CheckedScreenState extends State<CheckedScreen> {
  bool isExhibitScreen = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '보고 온 전시',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isExhibitScreen = true;
                        });
                      },
                      child: Text('전시',style: TextStyle(color: isExhibitScreen ? Colors.black :Colors.black54),)),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isExhibitScreen = false;
                        });
                      },
                      child: Text('남긴 리뷰',style: TextStyle(color: isExhibitScreen ?Colors.black54 :Colors.black ),))
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15,0,15,0),
                child: isExhibitScreen ? const CheckedScreen1() : CheckedScreen2(),
              ),
              //이게 좋을 지 삼항연산이 좋을지
            ],
          ),
        ));
  }
}
