import 'package:cloud_firestore/cloud_firestore.dart';


class Exhibition {
  final String title;
  final String keyword;
  final String place;
  final String date;
  final String explanation;
  final String placeinfo;
  final bool bookmark;
  final String poster;
  final DocumentReference? reference;


  Exhibition.fromMap(Map<String, dynamic> map, {this.reference})
      : title = map['title'],
        keyword = map['keyword'],
        place = map['place'],
  explanation = map['explanation'],
        date = map['date'],
        bookmark = map['bookmark'],
        poster = map['poster'],
  placeinfo = map['placeinfo'];

  Exhibition.fromSnapshot(DocumentSnapshot snapshot)
  : this.fromMap(snapshot.data() as Map<String, dynamic>, reference: snapshot.reference);


  @override
  String toString() => "Exhibition<$title:$keyword>";
}
