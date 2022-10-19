import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//listview로 쫙 뽑는 거 ㅇㅇ 최근 올라온 리뷰용
class Reviews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('review').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final reviewDocs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: reviewDocs.length,
          itemBuilder: (context, index){
            return Text(reviewDocs[index]['text']);
          }
        );
        }
        );
  }
}
