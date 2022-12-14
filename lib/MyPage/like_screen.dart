import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../DetailscreenFolder/exhibition_detail_screen.dart';
import '../Model/model_exhibitions.dart';

class LikeScreen extends StatelessWidget {
  const LikeScreen({Key? key}) : super(key: key);

  Future<List<DocumentSnapshot>> bringHeartDocs() async {
    final docRef = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('heart').orderBy('time', descending: true);
    final docSnapshot = await docRef.get();
    //docSnapshot은 QuerySnapshot<Map<>>이다
    //이 뒤에 .docs를 해주어야 List가 나오는거 ㅇㅇ

    List<DocumentSnapshot> RefList = [];

    for (QueryDocumentSnapshot d in docSnapshot.docs) {
      final data = await d.data() as Map<String, dynamic>;
      var Ref = await data['ref'];

      await Ref.get().then(
            (DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            RefList.add(documentSnapshot);
          }
        },
      );
    }
    return RefList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '좋아요한 전시',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
          future: bringHeartDocs(),
          builder: (context, RefList) {
            if (!RefList.hasData) {
              return LinearProgressIndicator();
            }
            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5, //수평 Padding
                  crossAxisSpacing: 1,
                  childAspectRatio: 0.5),
              itemCount: RefList.data!.length,
              itemBuilder: (BuildContext context, int i) {
                List<Exhibition> exhibitions = RefList.data!
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
                        height: 280,
                        width: MediaQuery.of(context).size.width*0.45,
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
            );
          }),
    );
  }
}
