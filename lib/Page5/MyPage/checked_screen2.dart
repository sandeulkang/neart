import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Model/model_exhibitions.dart';
import '../../Model/model_review.dart';
import '../../Review/one_review_screen.dart';

//내가 남긴 후기 스크린
class CheckedScreen2 extends StatelessWidget {
  dynamic reviewlist; //사용자가 남긴 review들을 불러와 넣어줄 리스트
  dynamic reviewdata; //위 리스트에 담긴 데이터를, 내가 만들어둔 모델을 통해 타입 바꿔줄 거임 ㅇㅇ 그걸 넣을 변수

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('review')
            .where("writeremail",
                isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .orderBy('time', descending: true)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LinearProgressIndicator();
          }
          return snapshot.data!.docs.isEmpty
              ? const Center(child: Text('아직 작성한 후기가 없어요!'))
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: InkWell(
                        onTap: () async {
                          reviewdata = await Review.fromSnapshot(reviewlist[i]);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return OneReviewScreen(reviewdata: reviewdata);
                              },
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xfff6f6f6),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          padding: const EdgeInsets.fromLTRB(10, 15, 20, 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<Exhibition>(
                                  future: getExhibitRef(reviewlist[i]),
                                  builder: (context, exhibition) {
                                    var date = DateFormat('yyyy.MM.dd').format(
                                        (reviewlist[i]['time'] as Timestamp)
                                            .toDate());
                                    if (!exhibition.hasData) {
                                      return const SizedBox(
                                        width: 1,
                                      );
                                    }
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: 30,
                                                child: Image.network(
                                                    exhibition.data!.poster)),
                                            const SizedBox(width: 10),
                                            Text(exhibition.data!.title),
                                          ],
                                        ),
                                        Text(
                                          date,
                                          style: const TextStyle(fontSize: 10),
                                        )
                                      ],
                                    );
                                  }),
                              const Divider(
                                height: 20,
                              ),
                              Text(
                                reviewlist[i]['content'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
        });
  }
}

Future<Exhibition> getExhibitRef(DocumentSnapshot review) async {
  dynamic ref;
  dynamic docu;
  dynamic exhibition;

  ref = await review['exhibitref'];
  docu = await ref.get();
  exhibition = Exhibition.fromSnapshot(docu);

  return exhibition;
}
