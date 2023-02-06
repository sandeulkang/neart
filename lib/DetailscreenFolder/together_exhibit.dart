import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Model/model_exhibitions.dart';
import 'exhibition_detail_screen.dart';

class TogetherExhibit extends StatelessWidget {
  final String place;

  TogetherExhibit({required this.place});

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('exhibition')
            .where('place', isEqualTo: place)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const LinearProgressIndicator(color: Colors.black38,);
          return SizedBox(
              height: 460,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  children: snapshot.data!.docs
                      .map((data) => _buildListItem(context, data))
                      .toList()));
        });
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: SizedBox(
              height: 350,
              width: 262,
              child: Image.network(
                data['poster'],
                fit: BoxFit.fitHeight,
              ),
            ),
            onTap: () async {
              final exhibition = await Exhibition.fromSnapshot(data);
              Navigator.of(context).push(
                  MaterialPageRoute<Null>(builder: (BuildContext context) {
                // * 클릭한 영화의 DetailScreen 출력
                return ExhibitionDetailScreen(exhibition: exhibition);
              }));
            },
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SizedBox(
              width: 257,
              child: Text(
                  data['title'],
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                ),),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  data['place'],
                ),
                const SizedBox(height: 2),
                Text(data['date']),
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
