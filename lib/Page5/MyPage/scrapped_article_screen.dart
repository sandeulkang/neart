import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ScrapeScreen extends StatefulWidget {
  const ScrapeScreen({Key? key}) : super(key: key);

  @override
  State<ScrapeScreen> createState() => _ScrapeScreenState();
}

class _ScrapeScreenState extends State<ScrapeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '스크랩한 칼럼',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
          future: bringBookmarkDocs(),
          builder: (context, refList) {
            if (!refList.hasData) {
              return const LinearProgressIndicator();
            }
            return refList.data!.isEmpty
                ? const Center(child: Text('아직 스크랩한 칼럼이 없어요!'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                    itemCount: refList.data!.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: InkWell(
                          onTap: () async {
                            final url = Uri.parse(
                              refList.data![i]['url'],
                            );
                            if (await canLaunchUrl(url)) {
                              launchUrl(url,
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                          child: Row(
                            children: [
                              Image.network(
                                refList.data![i]['poster'],
                                height: 70,
                                width: 110,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      refList.data![i]['title'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(refList.data![i]['content'],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(fontSize: 11)),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                child: SvgPicture.asset('assets/onscrap.svg',
                                    width: 30, height: 30, color: Colors.black),
                                onTap: () {
                                  setState(() {
                                    FirebaseFirestore
                                        .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                                        .collection('member')
                                        .doc(FirebaseAuth
                                            .instance.currentUser?.email)
                                        .collection('bookmark')
                                        .doc(refList.data![i]['title'])
                                        .delete();
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
          }),
    );
  }

  Future<List<DocumentSnapshot>> bringBookmarkDocs() async {
    final docRef = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('bookmark')
        .orderBy('time', descending: true);
    final docSnapshot = await docRef.get();

    List<DocumentSnapshot> refList = [];

    for (QueryDocumentSnapshot d in docSnapshot.docs) {
      final data = await d.data() as Map<String, dynamic>;
      var ref = await data['ref'];

      await ref.get().then(
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
