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
  final _currentUser = FirebaseAuth.instance.currentUser!;
  final _firestore = FirebaseFirestore.instance;
  String userReview = '';
  TextEditingController reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _tryValidation() {
    final bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            '리뷰 작성',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                if (!_tryValidation()) return;
                _firestore //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                    .collection('review')
                    .doc(_currentUser.email! + widget.exhibition.title)
                    .set({
                  'writeremail': _currentUser.email,
                  'exhibitiontitle': widget.exhibition.title,
                  'content': reviewController.text,
                  'time': FieldValue.serverTimestamp(),
                  'exhibitref': _firestore
                      .collection('exhibition')
                      .doc(widget.exhibition.title),
                  'poster': widget.exhibition.poster,
                });
                Navigator.pop(context);
              },
              child: const Text(
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
            style: const TextStyle(fontSize: 13, letterSpacing: 0.7),
            maxLines: null,
            controller: reviewController,
            autofocus: true,
            validator: (value) {
              if (value == null ||
                  value.isEmpty /*value?.isNotEmpty != true*/) {
                return '리뷰를 작성해주세요!';
              }
              return null;
            },
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
      ),
    );
  }
}
