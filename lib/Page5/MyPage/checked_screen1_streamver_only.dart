import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../DetailscreenFolder/exhibition_detail_screen.dart';
import '../../Model/model_exhibitions.dart';
import '../../endExhibitDialog.dart';


//내가 다녀온 전시 스크린
class CcheckedScreen1only extends StatelessWidget {

  var ref;

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
            return const LinearProgressIndicator(color: Colors.black38,);
          }
          return _buildUi(context, snapshot.data!.docs);
        });
  }

  Widget _buildUi(context, exhibitionsList) {
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 3, //수평 Padding
                crossAxisSpacing: 0,
                childAspectRatio: 0.42),
            itemCount: exhibitionsList.length,
            itemBuilder: (BuildContext context, int i) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      ref = await exhibitionsList[i]['ref'];
                      await ref.get().then((DocumentSnapshot docu) async {
                        if (docu.exists) {
                          final exhibition = Exhibition.fromSnapshot(docu);
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExhibitionDetailScreen(
                                    exhibition: exhibition)),
                          );
                        }
                        else{endExhibitDialog(context);}
                      });
                    },
                    child: SizedBox(
                      height: 180,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Image.network(
                        exhibitionsList[i]['poster'],
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
                          exhibitionsList[i]['title'],
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(exhibitionsList[i]['place']),
                        const SizedBox(height: 2),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
  }
}
