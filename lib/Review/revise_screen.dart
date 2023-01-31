import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReviseScreen extends StatefulWidget {
  final reviewdoc;

  ReviseScreen({required this.reviewdoc});

  @override
  State<ReviseScreen> createState() => _ReviseScreenState();
}

class _ReviseScreenState extends State<ReviseScreen> {
  String userReview = '';
  late TextEditingController reviewController;
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
                FirebaseFirestore
                    .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                    .collection('review')
                    .doc(widget.reviewdoc.writeremail+widget.reviewdoc.exhibitiontitle)
                    .update({
                  'content': reviewController.text,
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
        child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore
                .instance
                .collection('review')
                .doc(widget.reviewdoc.writeremail+widget.reviewdoc.exhibitiontitle)
                .get(),
            builder: (context, snapshot) {
              reviewController = TextEditingController(text: snapshot.data!['content']);
              return Form(
                key: _formKey,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(fontSize: 13, letterSpacing: 0.7),
                  maxLines: null,
                  controller: reviewController,
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty/*value?.isNotEmpty != true*/) {
                      return '리뷰를 작성해주세요!';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              );
            }),
      ),
    );
  }
}
