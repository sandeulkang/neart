import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//원리뷰스크린은 쫙 뽑아진 리뷰들 중 하나를 눌렀을 때 나오는 페이지다
//즉 타이틀과

// class ReviewScreen extends StatelessWidget {
//
//   final title;
//
//   ReviewScreen({required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<DocumentSnapshot>(
//       future: FirebaseFirestore.instance.collection('review').doc(title).get(),
//         builder: (context, snapshot){ //document
//         if(snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         }
//         final reviewDocs = snapshot.data!;
//         return ListView.builder(
//           itemCount: reviewDocs.length,
//           itemBuilder: (context, index){
//             return Text(reviewDocs[index]['text']);
//           }
//         );
//         }
//         );
//   }
// }
