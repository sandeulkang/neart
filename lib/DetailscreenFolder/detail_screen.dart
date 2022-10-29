import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neart/DetailscreenFolder/together_exhibiit.dart';
import 'package:neart/Lab/review_screen.dart';
import '../Model/model_exhibitions.dart';
import 'main_info.dart';

class DetailScreen extends StatefulWidget {
  final Exhibition exhibition;

  DetailScreen({required this.exhibition});

  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool heart = false;
  bool havebeen = false;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var information = '';

  @override
  void initState() {
    super.initState();
    heart = widget.exhibition.heart;
    havebeen = widget.exhibition.havebeen;
    // asyncInitState();
  }

  // 이거는 함께 전시중인 전시 띄울 때 필요한 거
  // void asyncInitState() async {
  //   DocumentSnapshot placeinfodata = await firebaseFirestore
  //       .collection('placeinfo')
  //       .doc(widget.exhibition.place)
  //       .get(); //placeinfodata는
  //   setState(() {
  //     information = placeinfodata['info'];
  //   });
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: false,
            expandedHeight: 35,
          ),
          SliverFillRemaining(
            //내용 영역
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    child: Container(
                      height: 220,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Image.network(widget.exhibition.poster),
                            width: MediaQuery.of(context).size.width * 0.35,
                          ),
                          Container(
                            height: 220,
                            width: MediaQuery.of(context).size.width * 0.6,
                            padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.exhibition.title,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.visible,
                                  maxLines: 2,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  widget.exhibition.date,
                                  style: TextStyle(fontSize: 13),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  widget.exhibition.place,
                                ),
                                SizedBox(height: 1),
                                Text(information.replaceAll("\\n", "\n"),
                                    style: TextStyle(height: 1.5)),
                                SizedBox(height: 1),
                                Text(
                                    widget.exhibition.admission
                                        .replaceAll("\\n", "\n"),
                                    style: TextStyle(height: 1.5)),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      heart
                                          ? InkWell(
                                              child: SvgPicture.asset(
                                                "assets/onheart.svg",
                                                width: 40,
                                                height: 40,
                                                color: Colors.red,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  heart = !heart;
                                                  firebaseFirestore
                                                      .collection('exhibition')
                                                      .doc(widget
                                                          .exhibition.title)
                                                      .update({'heart': heart});
                                                });
                                              },
                                            )
                                          : InkWell(
                                              child: SvgPicture.asset(
                                                "assets/offheart.svg",
                                                width: 40,
                                                height: 40,
                                                color: Colors.red,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  heart = !heart;
                                                  firebaseFirestore
                                                      .collection('exhibition')
                                                      .doc(widget
                                                          .exhibition.title)
                                                      .update({'heart': heart});
                                                });
                                              },
                                            ),
                                      havebeen
                                          ? InkWell(
                                              child: SvgPicture.asset(
                                                "assets/oncheck.svg",
                                                width: 40,
                                                height: 40,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  havebeen = !havebeen;
                                                  firebaseFirestore
                                                      .collection('exhibition')
                                                      .doc(widget
                                                          .exhibition.title)
                                                      .update({
                                                    'havebeen': havebeen
                                                  });
                                                });
                                              },
                                            )
                                          : InkWell(
                                              child: SvgPicture.asset(
                                                "assets/off_check.svg",
                                                width: 40,
                                                height: 40,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  havebeen = !havebeen;
                                                  firebaseFirestore
                                                      .collection('exhibition')
                                                      .doc(widget
                                                          .exhibition.title)
                                                      .update({
                                                    'havebeen': havebeen
                                                  });
                                                });
                                                print('daf');
                                              },
                                            ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Opacity(
                    child: Divider(
                      height: 20,
                      thickness: 10,
                    ),
                    opacity: 0.4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '전시 소개',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            widget.exhibition.explanation
                                .replaceAll("\\n", "\n"),
                            style: TextStyle(height: 1.4),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            '추천 칼럼',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 40,),
                          Text('같이 진행하는 다른 전시',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Image.network('https://postfiles.pstatic.net/MjAyMjEwMjlfMjAy/MDAxNjY3MDMwMzE5Mzk5.M7ykM_2llyU1pyzTSLGHUah-xjY0FTujiq-9fhNnqmog.ne6r45qqiLY3JGqgbHZzKa9Idzpepx4moqPIUnsCpmEg.PNG.tksemf0628/tt.png?type=w773'),
                          TogetherExhibit(exhibition: widget.exhibition)
                        ]),
                  )
                ],
              ),
            ),
          ),
        ],
      ),

//        appBar: AppBar(),
    );
  }
}
