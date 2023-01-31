import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Model/model_exhibitions.dart';
import '../DetailscreenFolder/exhibition_detail_screen.dart';

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode(); // *현재 검색 위젯에 커서가 있는지에 대한 상태 등을 가지고 있는 위젯
  String _searchText = ""; //searchText가 null이 아닌 빈 값을 가져서 모든 전시가 다 나올 수 있는 것

  _Page2State() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  //처음에 모든 전시 불러오기
  Widget _buildBody(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('exhibition')
          .orderBy('time', descending: true)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  //사용자의 검색어를 keyword필드에 가지고 있는 doc들로 구성된 리스트 형성
  Widget _buildList(
      BuildContext context, List<QueryDocumentSnapshot> snapshot) {
    List<QueryDocumentSnapshot> searchResults = [];
    for (QueryDocumentSnapshot d in snapshot) {
      if ((d.data()! as Map)['keyword'].toString().contains(_searchText)|(d.data()! as Map)['title'].toString().contains(_searchText)|(d.data()! as Map)['place'].toString().contains(_searchText)) {
        searchResults.add(d);
      }
    }

    // 그 리스트로 그리드뷰 만들기
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(15, 5, 13, 0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5, //수평 Padding
            crossAxisSpacing: 1,
            childAspectRatio: 0.5),
        itemCount: searchResults.length,
        itemBuilder: (BuildContext context, int i) {
          List<Exhibition> exhibitions = searchResults
              .map((data) => Exhibition.fromSnapshot(data))
              .toList();
          // 전시별 디테일 스크린으로 갈 때 futurebuilder로 전시를 또 불러오는 일 없게
          // 기존에 만들어둔 모델 클래스로 Map화하여 데이터 읽기비용을 아낀다

          // 전시 모듈 ui
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ExhibitionDetailScreen(exhibition: exhibitions[i])),
                  );
                },
                child: SizedBox(
                  height: 250,
                  width: MediaQuery.of(context).size.width*0.45,
                  child: Image.network(
                    exhibitions[i].poster,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 8, 0, 0),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
            child: Row(
              children: [
                //검색바
                Expanded(
                  flex: 6,
                  child: TextField(
                    focusNode: focusNode,
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                    autofocus: false,
                    controller: _filter,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: '지역, 장소, 장르 등 키워드를 검색해 보세요!',
                      labelStyle: const TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white54,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black38,
                        size: 20,
                      ),
                      // 검색창 클릭 감지하여 우측 아이콘 추가
                      suffixIcon: focusNode.hasFocus
                          ? IconButton(
                              icon: const Icon(
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
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                    ),
                  ),
                ),
                // 검색바 클릭시 취소 버튼 생겼다가 취소 누르면 없어지게 만들기
                focusNode.hasFocus
                    ? Expanded(
                        child: TextButton(
                          child: const Text(
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
    );
  }
}
