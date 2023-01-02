import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Model/model_exhibitions.dart';

class ReviseScreen extends StatefulWidget {
  final Exhibition exhibition;

  // var now = new DateTime.now();

  ReviseScreen({required this.exhibition});

  @override
  State<ReviseScreen> createState() => _ReviseScreenState();
}

class _ReviseScreenState extends State<ReviseScreen> {
  String userReview = '';
  late TextEditingController reviewController;
  final _formKey = GlobalKey<FormState>();

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            '리뷰 작성',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                _tryValidation();
                FirebaseFirestore
                    .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                    .collection('review')
                    .doc(FirebaseAuth.instance.currentUser!.email! +
                        widget.exhibition.title)
                    .update({
                  'content': reviewController.text,
                  'time': FieldValue.serverTimestamp()
                });
                Navigator.pop(context);
              },
              child: Text(
                '작성',
                style: TextStyle(color: Colors.black),
              ),
            )
          ]),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore
                .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                .collection('review')
                .doc(FirebaseAuth.instance.currentUser!.email! +
                    widget.exhibition.title)
                .get(),
            builder: (context, snapshot) {
              reviewController =
                  TextEditingController(text: snapshot.data!['content']);
              return Form(
                key: _formKey,
                child: TextFormField(
                  style: TextStyle(fontSize: 13, letterSpacing: 0.7),
                  maxLines: null,
                  controller: reviewController,
                  autofocus: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '리뷰를 작성해주세요!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              );
            }),
      ),
    );
  }
}
