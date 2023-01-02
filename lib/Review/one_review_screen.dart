import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Model/model_review.dart';

class OneReviewScreen extends StatelessWidget {
  OneReviewScreen({Key? key}) : super(key: key);

  final Auth = FirebaseAuth.instance;
  // final Review review;
  //
  // OneReviewScreen({required this.review})

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('리뷰')),
      // body:
      // FutureBuilder<DocumentSnapshot>(
      //     future: FirebaseAuth.c,
      //     builder: (context, snapshot) {
      //       return Container(child: Text('hi'));
      //     })
      body: Text('hi'),
    );
  }
}
