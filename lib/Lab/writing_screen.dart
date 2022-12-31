import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Model/model_exhibitions.dart';

class WritingScreen extends StatefulWidget {
  final Exhibition exhibition;

  WritingScreen({required this.exhibition});

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  String userReview = '';
  TextEditingController reviewController = TextEditingController();
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
                '리뷰',
                style: TextStyle(fontSize: 16),
              ),
              centerTitle: true,
              actions: [
                TextButton(
                  onPressed: () {
                    _tryValidation();
                    setState(() {
                      // FirebaseFirestore
                      //     .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                      //     .collection('member')
                      //     .doc(FirebaseAuth.instance.currentUser?.email)
                      //     .collection('review')
                      //     .doc(widget.exhibition.title)
                      //     .set({
                      //   'content': reviewController.text,
                      //   'time' : FieldValue.serverTimestamp()
                      // });
                      FirebaseFirestore
                          .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                          .collection('exhibition')
                          .doc(widget.exhibition.title)
                          .collection('reviews')
                          .doc(FirebaseAuth.instance.currentUser!.email!)
                          .set({
                        'useremail': FirebaseAuth.instance.currentUser!.email!,
                        'content': reviewController.text,
                        'time' : FieldValue.serverTimestamp()
                      });
                    });
                  },
                  child: Text(
                    '작성',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ]),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(25,10,25,10),
            child: Form(
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
            ),
          ),
        );
  }
}