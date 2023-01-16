import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../DetailscreenFolder/exhibition_detail_screen.dart';
import '../../Model/model_exhibitions.dart';


//내가 다녀온 전시 스크린
class CcheckedScreen1 extends StatelessWidget {
  const CcheckedScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('member')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection('havebeen')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LinearProgressIndicator();
          }
          return _buildUi(context, snapshot.data!.docs);
        });
  }

  Widget _buildUi(context, snapshot) {
    return FutureBuilder<List<Exhibition>>(
        future: _buildList(context, snapshot),
        builder: (context, exhibitionsList) {
          if (!exhibitionsList.hasData) {
            return const LinearProgressIndicator();
          }
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 3, //수평 Padding
                crossAxisSpacing: 0,
                childAspectRatio: 0.42),
            itemCount: exhibitionsList.data!.length,
            itemBuilder: (BuildContext context, int i) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExhibitionDetailScreen(
                                exhibition: exhibitionsList.data![i])),
                        //즉 Exhibition 타입의 아이를 넘기는 거임
                      );
                    },
                    child: SizedBox(
                      height: 180,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Image.network(
                        exhibitionsList.data![i].poster,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exhibitionsList.data![i].title,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(exhibitionsList.data![i].place),
                        const SizedBox(height: 2),
                        Text(exhibitionsList.data![i].date),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

  Future<List<Exhibition>> _buildList(BuildContext context, List<QueryDocumentSnapshot> snapshot) async {
    List<Exhibition> exhibitionsList = [];

    for (QueryDocumentSnapshot d in snapshot) {
      await (d.data() as Map<String, dynamic>)['ref'].get().then( //documentreference가 완전히 그 document로 이동할 때까지 기다려야 한다
              (DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) { //document로 이동이 됐다면
              final exhibition = Exhibition.fromSnapshot(documentSnapshot); //그 documentsnapshot을 내가 만들어둔 타입 Exhibition으로 바꾼다
              exhibitionsList.add(exhibition);//그것을 exhibitionList라는 변수에 저장한다
            }}
      );
    }
    return exhibitionsList;
  }
}
