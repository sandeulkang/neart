import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neart/Review/revise_screen.dart';

import '../Model/model_review.dart';

//최근 올라온 리뷰를 클릭하든
//전시 디테일스크린에서 리뷰를 클릭하든
//
//ui 먼저 생각하고
//필수 마라미터 생각하기
//필수 파라미터? 그냥 그 리뷰 doc의 이름으로 하면 되지
//그

class OneReviewScreen extends StatefulWidget {
  OneReviewScreen({required this.reviewdoc});

  final reviewdoc;

  @override
  State<OneReviewScreen> createState() => _OneReviewScreenState();
}

class _OneReviewScreenState extends State<OneReviewScreen> {
  final Auth = FirebaseAuth.instance;

  // final Review review;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('리뷰')),
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('review')
                  .doc(widget.reviewdoc)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //그 전시의 이름과 포스터
                            children: [
                              SizedBox(
                                  child:
                                      Image.network(snapshot.data!['poster']),
                                  width: 70),
                              SizedBox(
                                width: 15,
                              ),
                              Flexible(
                                child: Text(
                                  snapshot.data!['exhibitiontitle'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.visible,
                                  maxLines: 2,
                                ),
                              )
                            ],
                          ),
                          // Positioned(
                          //   top:45,
                          //     right:30,
                          //     child: ),
                          Positioned(
                            right: 30,
                            top: 60,
                            child: FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('member')
                                    .doc(snapshot.data!['writeremail'])
                                    .get(),
                                builder: (context, usersnapshot) {
                                  if (!usersnapshot.hasData)
                                    return LinearProgressIndicator();
                                  return Row(
                                    children: [
                                      Text(
                                        'written by',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black54),
                                      ),
                                      SizedBox(width: 5),
                                      CircleAvatar(
                                          radius: 15,
                                          backgroundImage: NetworkImage(
                                              usersnapshot.data![
                                                  'profileUrl']) //image.network하면 안 되고 networkimage해야 됨
                                          ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Text(
                                        usersnapshot.data!['name'],
                                        style: TextStyle(fontSize: 14),
                                      ),

                                      //writer의 이름과 프로필 url
                                    ],
                                  );
                                }),
                          )
                        ],
                      ),
                      Divider(
                        height: 40,
                        color: Colors.black26,
                      ),
                      Container(
                        child: Text(
                          snapshot.data!['content'],
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.3,
                          ),
                        ),
                      ),
                      SizedBox(height:30),
                      Visibility(
                          visible: FirebaseAuth.instance.currentUser?.email ==
                              snapshot.data!['writeremail'],
                          child: Row(
                            children: [
                              SizedBox(width:MediaQuery.of(context).size.width*0.55),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ReviseScreen(
                                                reviewdoc: widget.reviewdoc)));
                                  },
                                  style: TextButton.styleFrom(backgroundColor:Color(0xfff1f1f1),),
                                  child: const Text(
                                    '수정',
                                    style: TextStyle(color: Colors.black87, fontSize: 12),
                                  )),
                              SizedBox(width: 5,),
                              TextButton(
                                style: TextButton.styleFrom(backgroundColor:Color(0xfff1f1f1),),
                                child: const Text(
                                  '삭제',
                                    style: TextStyle(color: Colors.black87, fontSize: 12),
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          //얘가 futuredynamic탕입이래
                                          content: Text('정말로 리뷰를 삭제하시겠어요?'),
                                          contentPadding: EdgeInsets.all(30),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
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
                                                child: Text('네',
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
