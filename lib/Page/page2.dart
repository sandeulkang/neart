import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Model/model_exhibitions.dart';
import '../DetailscreenFolder/detail_screen.dart';

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final TextEditingController _filter = TextEditingController();

  // *현재 검색 위젯에 커서가 있는지에 대한 상태 등을 가지고 있는 위젯
  FocusNode focusNode = FocusNode();

  // 현재 검색값을 가지고 있는 _searchText 선언
  String _searchText = ""; //searchText가 null이 아닌 빈 값을 줘서 모든 전시가 다 나올 수 있는 것

  // * 검색 위젯을 컨트롤하는 _filter가 변화를 감지하여 _searchText의 상태를 변화시키는 코드
  _SsearchScreenExhibitState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('exhibition')
          .orderBy('time', descending: true)
          .snapshots(), //QuerySnapshot 타입임
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  //현재 snapshot이 어떤 상태인지 파악이 필요함 Querysnapshot의 모든 데이터, 즉 모든 docs를 가지고 있는 상태, 즉 doc들의 집합인 list
  Widget _buildList(
      BuildContext context, List<QueryDocumentSnapshot> snapshot) {
    //documentSnapshot이 아닌 QueryDocumentSnapshot이다
    List<QueryDocumentSnapshot> searchResults = [];

    for (QueryDocumentSnapshot d in snapshot) {
      // *string.contains()를 활용해 searchText를 포함한 snapshot을 리스트에 추가
      // * 주의!) data.toString()해도 실행은 되지만 검색 결과가 안 나옴!
      if (d.data().toString().contains(_searchText)) {
        searchResults.add(d); //이로써 searchResults는 선별되어진 docs 들로 구성된 list이다
      }
    }

    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.fromLTRB(15, 5, 13, 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5, //수평 Padding
            crossAxisSpacing: 1,
            childAspectRatio: 0.5
            ),
        itemCount: searchResults.length, //이거 exhibition.length로 바꿔도 ㄱㅊ나 봐보기
        itemBuilder: (BuildContext context, int i) {
          //itembuilder의 대상은 list이다. 리스트 1부터 차례대로 아래에 들어가는 거다. 다만 Exhibition의 리스트여야 한다.
          //이 exhibition은 Exhibition 타입이다. 즉 나는 searchResult라는 리스트를 exhibitions라는 이름을 가진 Exhibition타입의 리스트로 바꿔주어야 한다

          List<Exhibition> exhibitions = searchResults
              .map((data) => Exhibition.fromSnapshot(data))
              .toList();
          //  List<Exhibition> exhibitions = snapshot.map((data) => Exhibition.fromSnapshot(data)).toList();
          // //exhibitions 라는 리스트는 들어온 snapshot이라는 list 안의 map들을 Exhibition화 시켜준 리스트이다.
          // final exhibition = Exhibition.fromSnapshot(data);

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
                  width: 180,
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
        },
      ),
    );
  }

  /***
      Gridview.count(
      children:
      searchResults.map((data) => _buildListItem(context, data)).toList(),
      searchResults의 아이들을 각각 하나의 data로 취급하고 이를 _buildlistitem에 넣겠다. 그러면
      각각의 data들은 그곳에서 Exhibition모델에 들어가 제대로 map 처리 돼서 ( justdata가 아닌 mapdata가 되고 ) to.list를 구성한다.
      이렇게 map화된 아이들로 구성된 searchResults 리스트로 gridview를 작성한다. (그리드 뷰의 확실한 자식임)

      Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
      final exhibition = Exhibition.fromSnapshot(data);
      return InkWell(
      child: Image.network(exhibition.poster),
      onTap: () {
      Navigator.of(context).push(MaterialPageRoute<Null>(
      builder: (BuildContext context) {
      return DetailScreen(exhibition: exhibition);
      }));
      },
      );
      }
   ***/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 5, 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    // * 검색 입력 필드 만들기
                    child: TextField(
                      focusNode: focusNode,
                      style: TextStyle(fontSize: 15),
                      autofocus: false,
                      controller: _filter,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: '지역, 장소, 장르 등 키워드를 검색해 보세요!',
                        labelStyle: TextStyle(color: Colors.black),
                        // * 검색창 디자인
                        filled: true,
                        fillColor: Colors.white54,
                        // * 좌측 아이콘 추가
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black38,
                          size: 20,
                        ),
                        // * 우측 아이콘 추가
                        suffixIcon: focusNode.hasFocus
                            ? IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.black38,
                                  size: 20,
                                ),
                                // * cancle 아이콘 누르면 _filter와 _searchText 초기화
                                onPressed: () {
                                  setState(() {
                                    _filter.clear();
                                    _searchText = "";
                                  });
                                },
                              )
                            : Container(),

                        // * 검색창 디자인(테두리, 테두리 색상 등)
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                  ),
                  // * 검색바 클릭시 취소 버튼 생겼다가 취소 누르면 없어지게 만들기
                  focusNode.hasFocus
                      ? Expanded(
                          child: TextButton(
                            child: Text(
                              "취소",
                              style: TextStyle(color: Colors.black38),
                            ),
                            onPressed: () {
                              setState(() {
                                _filter.clear();
                                _searchText = "";
                                focusNode.unfocus();
                              });
                            },
                          ),
                        )
                      : Expanded(
                          flex: 0,
                          child: Container(),
                        )
                ],
              ),
            ),
            _buildBody(context)
          ],
        ),
      ),
    );
  }
}
