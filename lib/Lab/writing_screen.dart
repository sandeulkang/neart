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
  TextEditingController? reviewController;
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
      body: Center(
        child: Column(
          children: [
            FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore
                    .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                    .collection('member')
                    .doc(FirebaseAuth.instance.currentUser?.email)
                    .collection('review')
                    .doc(widget.exhibition.title)
                    .get(),
                builder: (context, snapshot) {
                  return Form(
                    key: _formKey,
                    child: TextFormField(
                      initialValue: snapshot.data!.exists
                          ? snapshot.data!['content']
                          : null,
                      //애초에 initial value 가 null일 수도 있고 값이 있을 수도 있음
                      //즉 Texteditingcontroller 안의 초기값이 null일수도 있고 값이 있을 수도 있어야 함
                      //Text
                      //근데 초기화 할 때 그게 가능하냐?
                      controller: reviewController,
                      autofocus: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '리뷰를 작성해주세요!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.red), gapPadding: 10,
                          borderRadius: BorderRadius.all(
                            Radius.circular(35),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            IconButton(
                onPressed: () {
                  _tryValidation();
                  setState(() {
                    FirebaseFirestore
                        .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                        .collection('member')
                        .doc(FirebaseAuth.instance.currentUser?.email)
                        .collection('review')
                        .doc(widget.exhibition.title)
                        .set({
                      'content': reviewController!.text,
                    });
                  });
                },
                icon: Icon(Icons.check))
          ],
        ),
      ),
    );
  }
}
