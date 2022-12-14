import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neart/DetailscreenFolder/exhibition_detail_screen.dart';
import 'package:neart/Model/model_exhibitions.dart';


//특정한 word를 가진 exhibit 모두를 가져오는 certainwordexhibit은 당연히 page2에는 사용할 수 없다.
//page2는 .builder로 구성되기 때문이다. 모두 불러오면 이건 데이터 읽는 비용이 많이 든다.
//page4는 column들 모두 불러와도 데이터 읽는 비용 얼마 안 드니까 .builder아니고 이거로 할까 생각중이다.
//너무많이 부러로아질것같으면 .count 추가하면 된다

class CertainWordExhibit extends StatefulWidget {
  final String word;

  CertainWordExhibit({required this.word});

  @override
  State<CertainWordExhibit> createState() => _CertainWordExhibitState();
}

class _CertainWordExhibitState extends State<CertainWordExhibit> {

  dynamic word;

  @override
  void initState() {
    super.initState();
    word = widget.word;//Query<Map<String, dynamic>> 타입임.
    //placeExhibitQuery를 스냅샷으로 builder로 굴려주고 listview 하면 되지 않을까? 이거랑 지금 비슷한 구조인 게
  }


  Widget _buildBody(BuildContext context) {
    return FutureBuilder <QuerySnapshot>(
      // FireStore 인스턴스의 exhibition 컬렉션의 snapshot을 가져옴
      future: FirebaseFirestore.instance.collection('exhibition').where('keyword', whereIn: [word]).get(),
      builder: (context, snapshot) {
        // snapshot의 데이터가 없는 경우 Linear~ 생성
        if (!snapshot.hasData) return const LinearProgressIndicator();
        return _buildList(context, snapshot.data!.docs);

      },
    );
  }


  // *buildlist에서는 검색 결과에 따라 데이터를 처리해 listView 생성해줌
  Widget _buildList(BuildContext context, List<QueryDocumentSnapshot> snapshot) {
    List<QueryDocumentSnapshot> searchResults = [];
    // *데이터에 searchText가 포함되는지 필터링 진행
    for (QueryDocumentSnapshot d in snapshot) {
      searchResults.add(d);

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
            child: Image.network(exhibition.poster, height: 350,),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    // * 클릭한 영화의 DetailScreen 출력
                    return ExhibitionDetailScreen(exhibition: exhibition);
                  }));
            },
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5,10, 0, 0),
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