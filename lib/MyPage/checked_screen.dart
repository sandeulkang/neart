import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../DetailscreenFolder/exhibition_detail_screen.dart';
import '../Model/model_exhibitions.dart';
import 'Checked_screen1.dart';

class CheckedScreen extends StatelessWidget {
  const CheckedScreen({Key? key}) : super(key: key);

  Future<List<DocumentSnapshot>> bringCheckDocs() async {
    final docRef = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('havebeen').orderBy('time', descending: true);
    final docSnapshot = await docRef.get();
    //docSnapshot은 QuerySnapshot<Map<>>이다
    //이 뒤에 .docs를 해주어야 List가 나오는거 ㅇㅇ

    List<DocumentSnapshot> refList = [];

    for (QueryDocumentSnapshot d in docSnapshot.docs) {
      final data = await d.data() as Map<String, dynamic>;
      var ref = await data['ref'];

      await ref.get().then(
            (DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            refList.add(documentSnapshot);
          }
        },
      );
    }
    return refList;
  }

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
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(child:Text('hi')),
            CheckedScreen1(),
          ],
        ),
      )
    );
  }
}
