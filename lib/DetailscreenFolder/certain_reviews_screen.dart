import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neart/Review/one_review_screen.dart';
import 'package:neart/Model/model_review.dart';

class CertainReviewsScreen extends StatelessWidget {
  final title;
  dynamic reviewdata;

  CertainReviewsScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('review')
          .where("exhibitiontitle", isEqualTo: title)
          .orderBy('time', descending: true)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LinearProgressIndicator();
        }
        return snapshot.data!.docs.isEmpty
            ? SizedBox(
             height: 60,
             child: const Center(child: Text('아직 작성된 후기가 없어요.')))
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, i) {
                  var reviewlist = snapshot.data!.docs;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: GestureDetector(
                      onTap: () async {
                        reviewdata = await Review.fromSnapshot(reviewlist[i]);
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return OneReviewScreen(reviewdata: reviewdata);
                        }));
                      },
                      child: FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('member')
                              .doc(
                                reviewlist[i]['writeremail'],
                              )
                              .get(),
                          builder: (context, usersnapshot) {
                            if (!usersnapshot.hasData) {
                              return const SizedBox(
                                width: 1,
                              );
                            }
                            return Container(
                              decoration: BoxDecoration(
                                color: const Color(0xfff6f6f6),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              padding:
                                  const EdgeInsets.fromLTRB(20, 15, 20, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                          radius: 15,
                                          backgroundImage: NetworkImage(
                                              usersnapshot
                                                  .data?['profileUrl'])),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(usersnapshot.data?['name']),
                                    ],
                                  ),
                                  const Divider(
                                    height: 20,
                                  ),
                                  Text(reviewlist[i]['content'],
                                      style: const TextStyle(
                                        height: 1.3,
                                      )),
                                ],
                              ),
                            );
                          }),
                    ),
                  );
                });
      },
    );
  }
}
