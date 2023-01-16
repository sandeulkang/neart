import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neart/Review/revise_screen.dart';
import '../DetailscreenFolder/exhibition_detail_screen.dart';
import '../Model/model_exhibitions.dart';

//어떤 리뷰를 클릭했을 때 구체적으로 그 리뷰를 보여주는 스크린이다
//내가 만들어 두었던 Review 모델 타입의 파라미터를 전달받는다

class OneReviewScreen extends StatefulWidget {
  OneReviewScreen({required this.reviewdata});

  final reviewdata;

  @override
  State<OneReviewScreen> createState() => _OneReviewScreenState();
}

class _OneReviewScreenState extends State<OneReviewScreen> {
  final auth = FirebaseAuth.instance;
  var date;
  var ref; //reviewdata가 갖고 있는 exhibitionreference를 넣어줄 변수

  @override
  Widget build(BuildContext context) {
    var date = DateFormat('yyyy.MM.dd.')
        .format((widget.reviewdata.time as Timestamp).toDate());
    return Scaffold(
        appBar: AppBar(title: const Text('리뷰', style: TextStyle(fontSize: 16))),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //전시 정보, 작성자
              Stack(
                children: [
                  //전시 정보
                  GestureDetector(
                    onTap: () async {
                      ref = await widget.reviewdata.exhibitref;
                      await ref.get().then((DocumentSnapshot docu) async {
                        if (docu.exists) {
                          final exhibition = Exhibition.fromSnapshot(docu);
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExhibitionDetailScreen(
                                    exhibition: exhibition)),
                          );
                        }
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 70,
                          child: Image.network(widget.reviewdata.poster),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.reviewdata.exhibitiontitle,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.visible,
                                maxLines: 2,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                date,
                                style: const TextStyle(color: Colors.black38),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  //작성자
                  Positioned(
                    right: 15,
                    top: 65,
                    child: Container(
                      child: FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('member')
                              .doc(widget.reviewdata.writeremail)
                              .get(),
                          builder: (context, usersnapshot) {
                            if (!usersnapshot.hasData) {
                              return const LinearProgressIndicator();
                            }
                            return Row(
                              children: [
                                SizedBox(
                                  child: const Text(
                                    'written by',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black54),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                CircleAvatar(
                                    radius: 14,
                                    backgroundImage: NetworkImage(usersnapshot
                                            .data![
                                        'profileUrl']) //image.network하면 안 되고 networkimage해야 됨
                                    ),
                                const SizedBox(
                                  width: 7,
                                ),
                                SizedBox(
                                  child: Text(
                                    usersnapshot.data!['name'],
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                  )
                ],
              ),
              const Divider(
                height: 40,
                color: Colors.black26,
              ),
              Text(
                widget.reviewdata.content,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 50),

              Visibility(
                  visible:
                      auth.currentUser?.email == widget.reviewdata.writeremail,
                  child: Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.63),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReviseScreen(
                                        reviewdoc: widget.reviewdata)));
                          },
                          child: Container(
                              width: 50,
                              height: 30,
                              color: const Color(0xfff1f1f1),
                              child: const Center(
                                child: Text(
                                  '수정',
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 12),
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
                                    color: Colors.black87, fontSize: 12),
                              ),
                            )),
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: const Text('정말로 리뷰를 삭제하시겠어요?'),
                                  contentPadding: const EdgeInsets.all(30),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          '아니오',
                                          style: TextStyle(color: Colors.black),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            FirebaseFirestore.instance
                                                .collection('review')
                                                .doc(widget.reviewdata
                                                        .writeremail +
                                                    widget.reviewdata.title)
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
        )));
  }
}
