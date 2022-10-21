import 'package:flutter/material.dart';
import 'package:neart/Model/model_exhibitions.dart';
import 'package:neart/Lab/Listvew_builder.dart';
import 'package:neart/trash/box_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../DetailscreenFolder/detail_screen.dart';

class Page2 extends StatefulWidget {
  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> streamData;

  @override
  void initState() {
    super.initState();
    streamData = firebaseFirestore
        .collection('exhibition')
        .orderBy('time', descending: true)
        .snapshots();
  }

  Widget _fetchData(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: streamData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Some error occured: ${snapshot.error.toString()}'),
            );
          }
          if (snapshot.hasData) {
            return _buildBody(context, snapshot.data!.docs);
          }
          return LinearProgressIndicator();
        });
  }

  //Querysnapshot 타입의 stream을 불러온 것.
  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {

    List<Exhibition> exhibitions =
    snapshot.map((d) => Exhibition.fromSnapshot(d)).toList();
    //exhibitions 라는 리스트는 들어온 snapshot이라는 list 안의 map들을 Exhibition화 시켜준 리스트이다. 'd'라는 글자는 다른 글자로 교체 가능하다

    return Column(children: [
      OutlinedButton(
        onPressed: () {Navigator.pushNamed(context, "/SsearchScreenExhibit");},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search, color: Colors.black38,),
            SizedBox(width:10,),
            Text(
              '장소, 지역, 장르 등 키워드를 검색해 보세요!  ',
              style: TextStyle(color: Colors.black38),
            ),
          ],
        ),
        style: OutlinedButton.styleFrom(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.all(15),
            side: BorderSide(
              color: Colors.black26,
            )),
      ),
      SizedBox(
        height: 15,
      ),
      Expanded(
        child: GridView.builder(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10, //수평 Padding
                crossAxisSpacing: 10,
                childAspectRatio: 0.5 //수직 Padding
            ),
            semanticChildCount: 6,
            itemCount: exhibitions.length,
            itemBuilder: (BuildContext context, int i) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailScreen(exhibition: exhibitions[i])),
                      );
                    },
                    child: Container(
                      height: 250,
                      child: Image.network(
                        exhibitions[i].poster,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 8, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exhibitions[i].title,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(exhibitions[i].place),
                        const SizedBox(height: 2),
                        Text(exhibitions[i].date),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),

    ]);
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }
}
