import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Model/model_exhibitions.dart';
import 'detail_screen.dart';

class TogetherExhibit extends StatefulWidget {

  final Exhibition exhibition;

  TogetherExhibit({required this.exhibition});

  @override
  State<TogetherExhibit> createState() => _TogetherExhibitState();
}

class _TogetherExhibitState extends State<TogetherExhibit> {

  dynamic exhibitionInDetail;
  dynamic placeExhibitQuery;

  @override
  void initState() {
    super.initState();
    exhibitionInDetail = widget.exhibition;
    placeExhibitQuery = FirebaseFirestore.instance
        .collection('exhibition')
        .where('place', isEqualTo: exhibitionInDetail.place);  //Query<Map<String, dynamic>> 타입임.
    //placeExhibitQuery를 스냅샷으로 builder로 굴려주고 listview 하면 되지 않을까? 이거랑 지금 비슷한 구조인 게
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // FireStore 인스턴스의 exhibition 컬렉션의 snapshot을 가져옴
      stream: placeExhibitQuery.snapshots(),
      builder: (context, snapshot) {
        // snapshot의 데이터가 없는 경우 Linear~ 생성
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot){
    List<DocumentSnapshot> placeExhibitList = [];
    for (DocumentSnapshot d in snapshot) {
      //이미 같은 이름의 장소를 가진 전시들의 query를 불러온 상황인데, 여기서 또 같은 이름의 장소를 contain하고 있는지 쭉 검사한다
      //당연히 있겠지 ㅇㅇ 이 부분이 너무 비효율적인 것 같은데 placaeExhibitList에 바로 넣는 방법은 없나?
      if (d.data().toString().contains(exhibitionInDetail.place)) {
        // print(word);
        placeExhibitList.add(d);
      }
    }

    return Container(
      height: 430,
      child: ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(3),
          // * map()함수를 통해 각 아이템을 buildListItem 함수로 넣고 호출
          children: placeExhibitList
              .map((data) => _buildListItem(context, data))
              .toList()),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final exhibition = Exhibition.fromSnapshot(data);
    // * 각각을 누를 수 있도록 InkWell() 사용
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: Image.network(exhibition.poster, height: 350,),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
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
    return  _buildBody(context);
  }
}

