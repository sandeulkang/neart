import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../DetailscreenFolder/detail_screen.dart';
import '../Model/model_exhibitions.dart';

class FinishingExhibit extends StatefulWidget {
  @override
  State<FinishingExhibit> createState() => _FinishingExhibitState();
}

class _FinishingExhibitState extends State<FinishingExhibit> {
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // FireStore 인스턴스의 movie 컬렉션의 snapshot을 가져옴
      stream: FirebaseFirestore.instance.collection('exhibition').snapshots(),
      builder: (context, snapshot) {
        // snapshot의 데이터가 없는 경우 Linear~ 생성
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  // *buildlist에서는 검색 결과에 따라 데이터를 처리해 GridView 생성해줌
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    List<DocumentSnapshot> searchResults = [];
    // *데이터에 searchText가 포함되는지 필터링 진행
    for (DocumentSnapshot d in snapshot) {
      // *string.contains()를 활용해 searchText를 포함한 snapshot을 리스트에 추가
      // * 주의!) data.toString()해도 실행은 되지만 검색 결과가 안 나옴!
      if (d.data().toString().contains('곧 끝나는')) {
        searchResults.add(d);
      }
    }

    // * listView 생성
    return Container(
      height: 430,
      child: ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(3),
          // * map()함수를 통해 각 아이템을 buildListItem 함수로 넣고 호출
          children: searchResults
              .map((data) => _buildListItem(context, data))
              .toList()),
    );
  }

  // * buildListItem으로 만들어 각각 detailScreen을 띄울 수 있도록 함.
  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final exhibition = Exhibition.fromSnapshot(data);
    // * 각각을 누를 수 있도록 InkWell() 사용
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: Image.network(
              exhibition.poster,
              height: 350,
              width: 245,
              fit: BoxFit.fitWidth,
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute<Null>(builder: (BuildContext context) {
                // * 클릭한 영화의 DetailScreen 출력
                return DetailScreen(exhibition: exhibition);
              }));
            },
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exhibition.title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(exhibition.place),
                const SizedBox(height: 2),
                Text(exhibition.date),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }
}
