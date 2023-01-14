import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neart/Review/one_review_screen.dart';
import 'package:neart/Model/model_review.dart';

import '../Review/revise_screen.dart';

class RecommendColumn extends StatelessWidget {
  final keyword;

  RecommendColumn({required this.keyword});

  late dynamic reviewList;

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('Column')
          .orderBy('time', descending: true)
          .get(), //QuerySnapshot 타입임, .data.docs 붙여줌으로써 리스트가 되는 거임
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  Widget noReview(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: const Center(child: Text('아직 작성된 후기가 없어요.')));
  }

  Widget _buildList(
      BuildContext context, List<QueryDocumentSnapshot> snapshot) {
    List<QueryDocumentSnapshot> searchResults = [];

    for (QueryDocumentSnapshot d in snapshot) {
      // *string.contains()를 활용해 searchText를 포함한 snapshot을 리스트에 추가
      // * 주의!) data.toString()해도 실행은 되지만 검색 결과가 안 나옴!
      if ((d.data()! as Map)['keyword'].toString().contains(keyword)) {
        //여기서는 Exhㅓibition.toString에 포함된(즉 $title,keyword에 포함되어있나를 살펴보는 것 같다)
        //toString이라는 메소드는 해당 데이터 내의 모든 텍스트를 불러와 string타입으로 변환한단 뜻 같다
        searchResults.add(d); //이로써 searchResults는 선별되어진 docs 들로 구성된 list이다
      }
    }

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
