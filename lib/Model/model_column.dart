import 'package:cloud_firestore/cloud_firestore.dart';

class Column {
  final String title;
  final String keyword;
  final String url;
  final String picture;
  final String content;
  final DocumentReference? reference;

  Column.fromMap(Map<String, dynamic> map, {this.reference})
      : title = map['title'],
        keyword = map['keyword'],
        url = map['url'],
        picture = map['picture'],
        content = map['content'];

  Column.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
      reference: snapshot.reference);

  @override
  String toString() => "Column<$title:$keyword>";
}
