import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'model_exhibitions.dart';

class DetailScreen extends StatefulWidget {
  final Exhibition exhibition;

  DetailScreen({required this.exhibition});

  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool bookmark = false;
  bool havebeen = false;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var information = '';

  @override
  void initState() {
    super.initState();
    bookmark = widget.exhibition.bookmark;
    havebeen = widget.exhibition.havebeen;
    asyncInitState();
  }

  void asyncInitState() async {
    DocumentSnapshot placeinfodata = await firebaseFirestore
        .collection('placeinfo')
        .doc(widget.exhibition.place)
        .get();
    setState(() {
      information = placeinfodata['info'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            //헤더 영역
            pinned: false, //축소시 상단에 AppBar가 고정되는지 설정
            expandedHeight: 60, //헤더의 최대 높이
            flexibleSpace: FlexibleSpaceBar(
              //늘어나는 영역의 UI 정의
              title: Text(''),
            ),
          ),
          SliverFillRemaining(
            //내용 영역
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Image.network(widget.exhibition.poster),
                        width: MediaQuery.of(context).size.width * 0.35,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 200,
                        padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.exhibition.title,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
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
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  bookmark
                                      ? InkWell(
                                          child: SvgPicture.asset(
                                            "assets/onheart.svg",
                                            width: 40,
                                            height: 40,
                                            color: Colors.red,
                                          ),
                                          onTap: () {
                                            setState(() {
                                              bookmark = !bookmark;
                                              firebaseFirestore
                                                  .collection('exhibition')
                                                  .doc(widget.exhibition.title)
                                                  .update({'bookmark': bookmark});
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
                                              bookmark = !bookmark;
                                              firebaseFirestore
                                                  .collection('exhibition')
                                                  .doc(widget.exhibition.title)
                                                  .update({'bookmark': bookmark});
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
                                            .doc(widget.exhibition.title)
                                            .update({'havebeen': havebeen});
                                      });
                                    },
                                  )
                                      : InkWell(
                                    child: SvgPicture.asset(
                                      "assets/offcheck.svg",
                                      width: 30,
                                      height: 30,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        havebeen = !havebeen;
                                        firebaseFirestore
                                            .collection('exhibition')
                                            .doc(widget.exhibition.title)
                                            .update({'havebeen': havebeen});
                                      });
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
                Opacity(
                  child: Divider(
                    height: 20,
                    thickness: 10,
                  ),
                  opacity: 0.4,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                          widget.exhibition.explanation.replaceAll("\\n", "\n"),
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
                      ]),
                )
              ],
            ),
          ),
        ],
      ),

//        appBar: AppBar(),
    );
  }
}
