import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OneReviewScreen extends StatelessWidget {
  const OneReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('리뷰')),
      body: Container(child:Text('hi'))
    );
  }
}
