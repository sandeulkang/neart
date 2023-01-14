import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neart/Review/one_review_screen.dart';
import 'package:neart/Model/model_review.dart';

import '../Review/revise_screen.dart';

class CertainReviewsScreen extends StatelessWidget {
  final title;

  CertainReviewsScreen({required this.title});

  late dynamic reviewList;

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      // FireStore 인스턴스의 exhibition 컬렉션의 snapshot을 가져옴
      future: FirebaseFirestore.instance
          .collection('review')
          .where("exhibitiontitle", isEqualTo: title)
          .orderBy('time', descending: true)
          .get(),
      builder: (context, snapshot) {
        reviewList = snapshot.data!.docs; //list 형태임. 안에
        // snapshot의 데이터가 없는 경우 Linear~ 생성
        if (!snapshot.hasData) {
          return const LinearProgressIndicator();
        }
        return reviewList.isNotEmpty //.length사용 안 하고 isempty사용하면 된다고 말씀해주셨던 거
            ? _buildList(context, reviewList)
            : noReview(context);
      },
    );
  }

  Widget noReview(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: const Center(child: Text('아직 작성된 후기가 없어요.')));
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
        physics: const NeverScrollableScrollPhysics(),
        //shinkwraptrue만 하고 이거 안 하면 안 돼요~
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        // padding: EdgeInsets.all(5),
        // * map()함수를 통해 각 아이템을 buildListItem 함수로 넣고 호출
        children:
            snapshot.map((data) => _buildListItem(context, data)).toList());
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final reviewdata = Review.fromSnapshot(data);
    // * 각각을 누를 수 있도록 InkWell() 사용
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return OneReviewScreen(
                reviewdoc: reviewdata.writeremail +
                    reviewdata
                        .exhibitiontitle); //navigator 하지 않고 그냥 바로 return 뒤에 위젯 안 붙이면 어케 되지?
          }));
        },
        child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('member')
                .doc(reviewdata.writeremail)
                .get(),
            builder: (context, usersnapshot) {
              if (!usersnapshot.hasData){
                return const SizedBox(
                  width: 1,
                );}
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xfff6f6f6),
                  borderRadius: BorderRadius.circular(7),
                ),
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(usersnapshot.data?[
                                'profileUrl']) //image.network하면 안 되고 networkimage해야 됨
                            ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(usersnapshot.data?['name']),
                      ],
                    ),
                    const Divider(
                      height: 20,
                    ),
                    Text(reviewdata.content,
                        style: const TextStyle(
                          height: 1.3,
                        )),
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
