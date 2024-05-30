


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookin/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<UserModel> getUsernameDetails()async{
  User activeUser = _auth.currentUser!;
  DocumentSnapshot snap = await _firestore.collection("users").doc(activeUser.uid).get();
  return UserModel.fromSnap(snap);
}


  Future<String>signUser({
    required String email,
    required String password,
    required String username,
  })async{
     String res = "Error Found";
     try{

      if(email.isNotEmpty|| password.isNotEmpty|| username.isNotEmpty){
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
     
      print(userCred.user);

      // String photoUrl = await StorageSevices().uploadImageToStorage('ProfilePics', file, false);

      UserModel userModel = UserModel(
        email: email, 
        uid: userCred.user!.uid, 
        username: 
        username, 
        photoUrl: '',
        //photoUrl,
         bio: '',
         //bio, 
        );
       //add user to database
       await _firestore.collection('users').doc(userCred.user!.uid).set(userModel.toJson());
        res = "Success";
      }
      else{
        res = "Please enter all fields";
      }
    }
     
     catch(e){
      res = e.toString();
     }
     return res;
  }

  //logging user
  Future<String>loginUser({
    required String email,
    required String password
  }) async{
    String res = "Error Found";
    try{
      if(email.isNotEmpty || password.isNotEmpty){
       await _auth.signInWithEmailAndPassword(email: email, password: password);
       res = "Success";
      }
      else{
        res = "Please enter all fields";
      }
    }
    catch(err){
      res = err.toString();

    }
   return res;
  }

//name fetch
  
  Future<String?> getUsername(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(uid).get();
      return snapshot.data()?['username'];
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}