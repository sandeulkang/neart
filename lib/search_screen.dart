import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neart/Lab/model_exhibitions.dart';
import 'package:neart/Lab/detail_screen.dart';

class SearchScreen extends StatefulWidget {
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // *검색 위젯을 컨트롤 하는 위젯 선언
  final TextEditingController _filter = TextEditingController();

  // *현재 검색 위젯에 커서가 있는지에 대한 상태 등을 가지고 있는 위젯
  FocusNode focusNode = FocusNode();

  // 현재 검색값을 가지고 있는 _searchText 선언
  String _searchText = "";

  // * 검색 위젯을 컨트롤하는 _filter가 변화를 감지하여 _searchText의 상태를 변화시키는 코드
  _SearchScreenState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  // * _buildBody를 통해 스트림데이터를 가져와 _buildList 호출
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
      if (d.data().toString().contains(_searchText)) {
        searchResults.add(d);
      }
    }
    // * GridView 생성
    return Expanded(
      child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1.5,
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
    return InkWell(
      child: Image.network(exhibition.poster),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute<Null>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              // * 클릭한 영화의 DetailScreen 출력
              return DetailScreen(exhibition: exhibition);
            }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 검색창 만들기
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    // * 검색 입력 필드 만들기
                    child: TextField(
                      focusNode: focusNode,
                      style: TextStyle(fontSize: 15),
                      autofocus: true,
                      controller: _filter,
                      decoration: InputDecoration(
                        // * 검색창 디자인
                        filled: true,
                        fillColor: Colors.white12,
                        // * 좌측 아이콘 추가
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white60,
                          size: 20,
                        ),
                        // * 우측 아이콘 추가
                        suffixIcon: focusNode.hasFocus
                            ? IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.white60,
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
                        // *힌트 텍스트 출력
                        hintText: "검색",
                        labelStyle: TextStyle(color: Colors.white),
                        // * 검색창 디자인(테두리, 테두리 색상 등)
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                  ),
                  // * 검색바 클릭시 취소 버튼 생겼다가 취소 누르면 없어지게 만들기
                  focusNode.hasFocus
                      ? Expanded(
                          child: TextButton(
                            child: Text(
                              "취소",
                              style: TextStyle(color: Colors.white60),
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
