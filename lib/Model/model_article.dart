import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String title;
  final List keyword;
  final String url;
  final String content;
  final DocumentReference? reference;
  final String poster;

  Article.fromMap(Map<String, dynamic> map, {this.reference})
      : title = map['title'],
        keyword = map['keyword'],
        url = map['url'],
  poster = map['poster'],
        content = map['content'];

  Article.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
      reference: snapshot.reference);

  @override
  String toString() => "Article<$title:$keyword>";
}
