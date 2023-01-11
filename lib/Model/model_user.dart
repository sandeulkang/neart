import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String photoUrl;

   final DocumentReference? reference;

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : email = map['email'],
        photoUrl = map['photoUrl'];



        User.fromSnapshot(DocumentSnapshot snapshot) //Exhibition이라는 클래스에서 Exhibition.fromSnapshot이라는 메소드를 만들었다. snapshot이라는 객체를 받아들인다.
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
      reference: snapshot.reference);

  @override
  String toString() => "User<$email:$photoUrl>";
}
