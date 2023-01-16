import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../needLoginDialog.dart';
import 'certain_word_article.dart';
import '../Model/model_article.dart';

class Page4 extends StatefulWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  FirebaseFirestore fire = FirebaseFirestore.instance;
  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode(); // *현재 검색 위젯에 커서가 있는지에 대한 상태 등을 가지고 있는 위젯
  String _searchText = ""; //searchText가 null이 아닌 빈 값을 가져서 모든 칼럼 다 나올 수 있는 것
  var url;

  _Page4State() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  //처음에 모든 칼럼 불러오기
  Widget _buildBody(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('Column')
          .orderBy('time', descending: true)
          .get(), //QuerySnapshot 타입임
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
      if ((d.data()! as Map)['keyword'].toString().contains(_searchText)) {
        searchResults.add(d);
      }
    }

    // 그 리스트로 리스트뷰 만들기
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children:
          searchResults.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  //리스트뷰의 모듈
  Widget _buildListItem(BuildContext context, DocumentSnapshot article) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        onTap: () async {
          final url = Uri.parse(article['url']);
          if (await canLaunchUrl(url)) {
            launchUrl(url, mode: LaunchMode.externalApplication);
          }
        },
        child: Row(
          children: [
            Image.network(
              article['poster'],
              height: 70,
              width: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: 10,
            ),
            //아마 얘를 expanded 하려면 모든 데이터가 있는 상태여야 하는데... 뒤에 나오는 futurebuildeer의 ui는 그리는데 시간이 좀 걸려서?
            SizedBox(
              width: MediaQuery.of(context).size.width*0.55,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article['title'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(article['content'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 11)),
                ],
              ),
            ),
            FirebaseAuth.instance.currentUser == null
                ? GestureDetector(
                    child: SvgPicture.asset('assets/offscrap.svg',
                        width: 30, height: 30, color: Colors.black54),
                    onTap: () {
                      needLoginDialog(context);
                    })
                : Container(
                    width: 30, //얘 안하면 오류남
                    child: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('member')
                            .doc(FirebaseAuth.instance.currentUser!.email!)
                            .collection('bookmark')
                            .doc(article['title'])
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data!.exists
                                ? GestureDetector(
                                    child: SvgPicture.asset(
                                        'assets/onscrap.svg',
                                        width: 30,
                                        height: 30,
                                        color: Colors.black),
                                    onTap: () {
                                      setState(() {
                                        FirebaseFirestore
                                            .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                                            .collection('member')
                                            .doc(FirebaseAuth
                                                .instance.currentUser?.email)
                                            .collection('bookmark')
                                            .doc(article['title'])
                                            .delete();
                                      });
                                    },
                                  )
                                : GestureDetector(
                                    child: SvgPicture.asset(
                                        'assets/offscrap.svg',
                                        width: 30,
                                        height: 30,
                                        color: Colors.black54),
                                    onTap: () {
                                      setState(() {
                                        FirebaseFirestore
                                            .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                                            .collection('member')
                                            .doc(FirebaseAuth
                                                .instance.currentUser?.email)
                                            .collection('bookmark')
                                            .doc(article['title'])
                                            .set({
                                          'ref': FirebaseFirestore.instance
                                              .collection('Column')
                                              .doc(article['title']),
                                          'time': FieldValue.serverTimestamp(),
                                        });
                                      });
                                    },
                                  );
                          }
                          return const LinearProgressIndicator();
                        }),
                  )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '지금 조회수 높은 칼럼',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            CertainWordArticle(word: "인기"),

            //검색바
            Container(
              height: 60,
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 6, // 취소 떴을 때 검색칸과 취소의 비율
                    // * 검색 입력 필드 만들기
                    child: TextField(
                      focusNode: focusNode,
                      style: const TextStyle(fontSize: 15, color: Colors.black),
                      autofocus: false,
                      controller: _filter,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: '키워드를 검색해 보세요!',
                        labelStyle: const TextStyle(color: Colors.black),
                        // * 검색창 디자인
                        filled: true,
                        fillColor: Colors.white54,
                        // * 좌측 아이콘 추가
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.black38,
                          size: 20,
                        ),
                        // * 우측 아이콘 추가
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
                  // * 검색바 클릭시 취소 버튼 생겼다가 취소 누르면 없어지게 만들기
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
      ),
    );
  }
}
