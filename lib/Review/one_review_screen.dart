import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neart/Review/revise_screen.dart';

import '../DetailscreenFolder/exhibition_detail_screen.dart';
import '../Model/model_exhibitions.dart';

class OneReviewScreen extends StatefulWidget {
  OneReviewScreen({required this.reviewdoc});

  final reviewdoc;

  @override
  State<OneReviewScreen> createState() => _OneReviewScreenState();
}

class _OneReviewScreenState extends State<OneReviewScreen> {
  final auth = FirebaseAuth.instance;
  var ref;

  // final Review review;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('리뷰', style: TextStyle(fontSize: 16))),
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('review')
                  .doc(widget.reviewdoc)
                  .get(),
              builder: (context, snapshot) {
                var Date = DateFormat('yyyy.MM.dd.').format((snapshot.data?['time'] as Timestamp).toDate());
                if (!snapshot.hasData) return const LinearProgressIndicator();
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              ref = await snapshot.data!['exhibitref'];
                              await ref
                                  .get()
                                  .then((DocumentSnapshot docu) async {
                                if (docu.exists) {
                                  final exhibition =
                                      Exhibition.fromSnapshot(docu);
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ExhibitionDetailScreen(
                                                exhibition: exhibition)),
                                  );
                                }
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              //그 전시의 이름과 포스터
                              children: [
                                SizedBox(
                                    child:
                                        Image.network(snapshot.data!['poster']),
                                    width: 70),
                                const SizedBox(
                                  width: 15,
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!['exhibitiontitle'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                        overflow: TextOverflow.visible,
                                        maxLines: 2,
                                      ),
                                      SizedBox(height: 5,),
                                      Text(Date, style: TextStyle(color: Colors.black38),),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          // Positioned(
                          //   top:45,
                          //     right:30,
                          //     child: ),
                          Positioned(
                            right: 15,
                            top: 65,
                            child: FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('member')
                                    .doc(snapshot.data!['writeremail'])
                                    .get(),
                                builder: (context, usersnapshot) {
                                  if (!usersnapshot.hasData) {
                                    return const LinearProgressIndicator();
                                  }
                                  return Row(
                                    children: [
                                      const Text(
                                        'written by',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black54),
                                      ),
                                      const SizedBox(width: 5),
                                      CircleAvatar(
                                          radius: 14,
                                          backgroundImage: NetworkImage(
                                              usersnapshot.data![
                                                  'profileUrl']) //image.network하면 안 되고 networkimage해야 됨
                                          ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      Text(
                                        usersnapshot.data!['name'],
                                        style: const TextStyle(fontSize: 13),
                                      ),

                                    ],
                                  );
                                }),
                          )
                        ],
                      ),
                      const Divider(
                        height: 40,
                        color: Colors.black26,
                      ),
                      // Row(
                      //   children: [
                      //     SizedBox(width: MediaQuery.of(context).size.width*0.65),
                      //     Text(Date, style: TextStyle(color: Colors.black38),),
                      //   ],
                      // ),
                      Text(
                        snapshot.data!['content'],
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 50),

                      Visibility(
                          visible: auth.currentUser?.email ==
                              snapshot.data!['writeremail'],
                          child: Row(
                            children: [
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.63),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ReviseScreen(
                                                reviewdoc: widget.reviewdoc)));
                                  },
                                  child: Container(
                                      width: 50,
                                      height: 30,
                                      color: const Color(0xfff1f1f1),
                                      child: const Center(
                                        child: Text(
                                          '수정',
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12),
                                        ),
                                      ))),
                              const SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                child: Container(
                                    width: 50,
                                    height: 30,
                                    color: const Color(0xfff1f1f1),
                                    child: const Center(
                                      child: Text(
                                        '삭제',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12),
                                      ),
                                    )),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          //얘가 futuredynamic탕입이래
                                          content:
                                              const Text('정말로 리뷰를 삭제하시겠어요?'),
                                          contentPadding:
                                              const EdgeInsets.all(30),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  '아니오',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    FirebaseFirestore.instance
                                                        .collection('review')
                                                        .doc(widget.reviewdoc)
                                                        .delete();
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('네',
                                                    style: TextStyle(
                                                        color: Colors.black))),
                                          ],
                                        );
                                      });
                                },
                              ),
                            ],
                          ))
                    ],
                  ),
                );
              }),
        ));
  }
}
