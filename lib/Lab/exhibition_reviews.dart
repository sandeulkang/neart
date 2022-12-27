import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neart/Lab/one_review_screen.dart';
import 'package:neart/Model/model_review.dart';

class ExhibitionReviews extends StatelessWidget {
  final title;

  ExhibitionReviews({required this.title});

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      // FireStore 인스턴스의 exhibition 컬렉션의 snapshot을 가져옴
      future: FirebaseFirestore.instance
          .collection('review')
          .doc(title)
          .collection('reviews')
          .get(),
      builder: (context, snapshot) {
        // snapshot의 데이터가 없는 경우 Linear~ 생성
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Container(
      height: 430,
      child: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(5),
          // * map()함수를 통해 각 아이템을 buildListItem 함수로 넣고 호출
          children:
              snapshot.map((data) => _buildListItem(context, data)).toList()),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final reviewdata = Review.fromSnapshot(data);
    // * 각각을 누를 수 있도록 InkWell() 사용
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            // * 클릭한 영화의 DetailScreen 출력
            return OneReviewScreen();
          }));
        },
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(reviewdata.useremail),
              Divider(height: 1,),
              Text(reviewdata.context),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }
}
