import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../DetailscreenFolder/exhibition_detail_screen.dart';
import '../../Model/model_exhibitions.dart';

//내가 다녀온 전시 스크린
class CheckedScreen1 extends StatelessWidget {
  const CheckedScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
        future: bringCheckDocs(),
        builder: (context, refList) {
          if (!refList.hasData) {
            return const LinearProgressIndicator();
          }
          return refList.data!.isEmpty
              ? const Center(child: Text('아직 보고 온 전시가 없어요!'))
              : GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 3, //수평 Padding
                      crossAxisSpacing: 0,
                      childAspectRatio: 0.42),
                  itemCount: refList.data!.length,
                  itemBuilder: (BuildContext context, int i) {
                    List<Exhibition> exhibitions = refList.data!
                        .map((data) => Exhibition.fromSnapshot(data))
                        .toList();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ExhibitionDetailScreen(
                                      exhibition: exhibitions[i])),
                              //즉 Exhibition 타입의 아이를 넘기는 거임
                            );
                          },
                          child: SizedBox(
                            height: 180,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Image.network(
                              exhibitions[i].poster,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exhibitions[i].title,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600),
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
                );
        });
  }

  //사용자가 다녀온 전시로 이동하는 reference를 모아줄 것이다
  Future<List<DocumentSnapshot>> bringCheckDocs() async {
    //사용자가 다녀온 전시 데이터를 불러옴
    final docRef = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('havebeen')
        .orderBy('time', descending: true);
    final docSnapshot = await docRef.get();

    List<DocumentSnapshot> refList = [];
    //불러온 데이터의 ref라는 필드에 있는 documentReference를 documentSnapshot 형태로 가져온 뒤 모아줄 리스트

    for (QueryDocumentSnapshot d in docSnapshot.docs) {
      await (d.data() as Map<String, dynamic>)['ref'].get().then(
        (DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            refList.add(documentSnapshot);
          }
        },
      );
    }
    return refList;
  }
}
