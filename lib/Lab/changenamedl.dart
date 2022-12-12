import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void showPopup(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(

          child: Stack(
              children: [
                TextButton(child: Text('완료'), onPressed: () {},),
                TextFormField(
                  initialValue: FirebaseFirestore.instance
                      .collection('member')
                      .doc(FirebaseAuth.instance.currentUser!.email!).
                ),
              ]
          ),
        );
      });
}