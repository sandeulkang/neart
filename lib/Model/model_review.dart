import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String content;
  final String useremail;
  final String exhibitiontitle;
  final String username;
  final DocumentReference? reference;

  Review.fromMap(Map<String, dynamic> map, {this.reference})
      : content = map['content'],
  useremail = map['useremail'],
  username = map['username'],
  exhibitiontitle = map['exhibitiontitle'];

  Review.fromSnapshot(DocumentSnapshot snapshot) //Exhibition이라는 클래스에서 Exhibition.fromSnapshot이라는 메소드를 만들었다. snapshot이라는 객체를 받아들인다.
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
      reference: snapshot.reference);

}
