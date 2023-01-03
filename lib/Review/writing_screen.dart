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

  bool _tryValidation() {
    final bool isValid = _formKey.currentState!.validate();
    print(isValid);
    if (isValid) {
      _formKey.currentState!.save();
    }
    return isValid;
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
                if (!_tryValidation()) return;
                FirebaseFirestore
                    .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                    .collection('review')
                    .doc(FirebaseAuth.instance.currentUser!.email! +
                        widget.exhibition.title)
                    .set({
                  'useremail': FirebaseAuth.instance.currentUser!.email,
                  'exhibitiontitle': widget.exhibition.title,
                  'content': reviewController.text,
                  'time': FieldValue.serverTimestamp(),
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
        child: Form(
          key: _formKey,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: TextStyle(fontSize: 13, letterSpacing: 0.7),
            maxLines: null,
            controller: reviewController,
            autofocus: true,
            validator: (value) {
              if (value == null || value.isEmpty/*value?.isNotEmpty != true*/) {
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
