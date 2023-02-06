import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Model/model_exhibitions.dart';
import '../../Model/model_review.dart';
import '../../Review/one_review_screen.dart';

//내가 남긴 후기 스크린
class CcheckedScreen2 extends StatelessWidget {
  dynamic reviewdata; //위 리스트에 담긴 데이터를, 내가 만들어둔 모델을 통해 타입 바꿔줄 거임 ㅇㅇ 그걸 넣을 변수

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('review')
            .where("writeremail",
            isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LinearProgressIndicator(color: Colors.black38,);
          }
          return snapshot.data!.docs.isEmpty
              ? const Center(child: Text('아직 작성한 후기가 없어요!'))
              : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, i) {
                var date = DateFormat('yyyy.MM.dd').format(
                    (snapshot.data!.docs[i]['time'] as Timestamp)
                        .toDate());
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: InkWell(
                    onTap: () async {
                      reviewdata = await Review.fromSnapshot(snapshot.data!.docs[i]);
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
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 7,
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width: 30,
                                        child: Image.network(
                                            snapshot.data!.docs[i]['poster'])),
                                    const SizedBox(width: 10),
                                    Flexible(child: Text(snapshot.data!.docs[i]['exhibitiontitle'], overflow: TextOverflow.ellipsis,)),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  date,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              )
                            ],
                          ),
                          // }),
                          const Divider(
                            height: 20,
                          ),
                          Text(
                            snapshot.data!.docs[i]['content'],
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
