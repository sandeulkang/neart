import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neart/Review/one_review_screen.dart';
import 'package:neart/Model/model_review.dart';

class CertainReviewsScreen extends StatelessWidget {
  final title;
  late dynamic reviewList;

  CertainReviewsScreen({required this.title});

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      // FireStore 인스턴스의 exhibition 컬렉션의 snapshot을 가져옴
      future: FirebaseFirestore.instance
          .collection('review')
          .where("exhibitiontitle", isEqualTo: title)
          .get(),
      builder: (context, snapshot) {
        reviewList = snapshot.data!.docs; //list 형태임. 안에
        // snapshot의 데이터가 없는 경우 Linear~ 생성
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        }
        return reviewList.length >= 1 //지금 이거는 map형태
            ? _buildList(context, snapshot.data!.docs)
            : noReview(context);
      },
    );
  }

  Widget noReview(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: Center(child: Text('아직 작성된 후기가 없어요.')));
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

      //이 부분 뭔소린지 모ㅡ르겠다. 리스트뷰의 CHILDREN은 리스트인 것은 알겠다.
      //
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
            return OneReviewScreen(); //navigator 하지 않고 그냥 바로 return 뒤에 위젯 안 붙이면 어케 되지?
          }));
        },
        child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('member')
                .doc(reviewdata.useremail)
                .get(),
            builder: (context, usersnapshot) {
              if (!usersnapshot.hasData)
                return const SizedBox(
                  width: 1,
                );
              return Container(
                decoration: BoxDecoration(
                  color: Color(0xfff6f6f6),
                  borderRadius: BorderRadius.circular(7),
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                            backgroundImage: NetworkImage(usersnapshot.data?[
                                'profileUrl']) //image.network하면 안 되고 networkimage해야 됨
                            ),
                        Text(reviewdata.username),
                      ],
                    ),
                    Divider(
                      height: 1,
                    ),
                    Text(reviewdata.content),
                  ],
                ),
              );
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }
}
