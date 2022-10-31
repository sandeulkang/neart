import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Model/model_exhibitions.dart';

class RecommendColumn extends StatefulWidget {

  String keyword;
  RecommendColumn({required this.keyword});

  @override
  State<RecommendColumn> createState() => _RecommendColumnState();
}

class _RecommendColumnState extends State<RecommendColumn> {
 // 일단 현 디테일 페이지의 키워드 (ex. 서울/입체/동작구)가 keyword라는 변수에 들어있는 상태

  dynamic keywordQuery;

  // @override
  // void initState() {
  //   super.initState();
  //   keywordQuery = FirebaseFirestore.instance
  //       .collection('Column')
  //       .where('keyword', isEqualTo: exhibitionInDetail.place);  //Query<Map<String, dynamic>> 타입임.
  //   //placeExhibitQuery를 스냅샷으로 builder로 굴려주고 listview 하면 되지 않을까? 이거랑 지금 비슷한 구조인 게
  // }
  //
  // Widget _buildBody(BuildContext context) {
  //   return StreamBuilder<QuerySnapshot>(
  //     // FireStore 인스턴스의 exhibition 컬렉션의 snapshot을 가져옴
  //     stream: keywordQuery.snapshots(),
  //     builder: (context, snapshot) {
  //       // snapshot의 데이터가 없는 경우 Linear~ 생성
  //       if (!snapshot.hasData) return LinearProgressIndicator();
  //       return _buildList(context, snapshot.data!.docs);
  //     },
  //   );
  // }
  //
  // Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot){
  //   List<DocumentSnapshot> placeExhibitList = [];
  //   for (DocumentSnapshot d in snapshot) {
  //     // *string.contains()를 활용해 searchText를 포함한 snapshot을 리스트에 추가
  //     // * 주의!) data.toString()해도 실행은 되지만 검색 결과가 안 나옴!
  //     if (d.data().toString().contains(exhibitionInDetail.place)) {
  //       // print(word);
  //       placeExhibitList.add(d);
  //     }
  //   }
  //
  //   return Container(
  //     height: 430,
  //     child: ListView(
  //         scrollDirection: Axis.horizontal,
  //         padding: EdgeInsets.all(3),
  //         // * map()함수를 통해 각 아이템을 buildListItem 함수로 넣고 호출
  //         children: placeExhibitList
  //             .map((data) => _buildListItem(context, data))
  //             .toList()),
  //   );
  // }
  //
  // Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  //   final exhibition = Exhibition.fromSnapshot(data);
  //   // * 각각을 누를 수 있도록 InkWell() 사용
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         InkWell(
  //           child: Image.network(exhibition.poster, height: 350,),
  //           onTap: () {
  //             Navigator.of(context).push(MaterialPageRoute<Null>(
  //                 builder: (BuildContext context) {
  //                   // * 클릭한 영화의 DetailScreen 출력
  //                   return DetailScreen(exhibition: exhibition);
  //                 }));
  //           },
  //         ),
  //         Container(
  //           padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 exhibition.title,
  //                 style: const TextStyle(
  //                     fontSize: 14, fontWeight: FontWeight.w600),
  //
  //               ),
  //               const SizedBox(
  //                 height: 4,
  //               ),
  //               Text(exhibition.place),
  //               const SizedBox(height: 2),
  //               Text(exhibition.date),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  //
  //

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
