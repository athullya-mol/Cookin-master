

import 'package:cloud_firestore/cloud_firestore.dart';


class UserModel {
  final String email;
  final String uid;
  final String username;
  final String photoUrl;
  final String bio;
 
  UserModel(
      {required this.email,
      required this.uid,
      required this.username,
      required this.photoUrl,
      required this.bio,
     });

  Map<String,dynamic> toJson() => {
    'uid': uid,
        'username' : username,
        'email': email,
        'bio':bio,
        'photoUrl':photoUrl,
  };
  static UserModel fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      email:snapshot['email'], 
      uid:snapshot['uid'], 
      username: snapshot['username'], 
      photoUrl: snapshot['photoUrl'], 
      bio: snapshot['bio'], 
      );
  }

   UserModel copyWith({
    String? email,
    String? uid,
    String? username,
    String? photoUrl,
    String? bio,
  }) {
    return UserModel(
      email: email ?? this.email,
      uid: uid ?? this.uid,
      username: username ?? this.username,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
    );
  }
}