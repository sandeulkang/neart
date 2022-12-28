import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// 원리뷰스크린은 쫙 뽑아진 리뷰들 중 하나를 눌렀을 때 나오는 페이지다

// 필수파라미터는 전시 타이틀, 그거로 review 들을 검색한다
// 전시 컬렉션의 각각의 전시 doc에 review컬렉션을 만들고 담는 것이 효율적인지
// 아니면 리뷰 컬렉션 자체를 따로 만드는 것이 효율적일지..
// 최근 리뷰 목록 위젯을 사용하지 않으면 굳이 리뷰컬렉션을 따로 만들 필요는 없다.
// 전시
class ReviewScreen extends StatelessWidget {

  final title;

  ReviewScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('review').doc(title).get(),
        builder: (context, snapshot){ //document
        if(snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final reviewDocs = snapshot.data!;
        return Container();
        // return ListView.builder(
        //   itemCount: reviewDocs.length,
        //   itemBuilder: (context, index){
        //     return Text(reviewDocs[index]['text']);
        //   }
        // );
        }
        );
  }
}
