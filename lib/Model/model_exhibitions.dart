import 'package:cloud_firestore/cloud_firestore.dart';

class Exhibition {
  final String title;
  final String keyword;
  final String place;
  final String date;
  final String explanation;
  final bool heart;
  final String poster;
  final String admission;
  final bool havebeen;
  final DocumentReference? reference;

  Exhibition.fromMap(Map<String, dynamic> map, {this.reference})
      : title = map['title'],
        keyword = map['keyword'],
        place = map['place'],
        explanation = map['explanation'],
        date = map['date'],
        heart = map['heart'],
        poster = map['poster'],
        havebeen = map['havebeen'],
        admission = map['admission'];

  Exhibition.fromSnapshot(DocumentSnapshot snapshot) //Exhibition이라는 클래스에서 Exhibition.fromSnapshot이라는 메소드를 만들었다. snapshot이라는 객체를 받아들인다.
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
            reference: snapshot.reference);

  @override
  String toString() => "Exhibition<$title:$keyword>"; //toString이라는 메소드를 이용하면 ""라는 string타입의 값이 도출된다?
}
