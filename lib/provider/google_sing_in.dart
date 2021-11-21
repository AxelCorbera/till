import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:till/pages/login.dart';
import 'package:till/scripts/cloud_firestore.dart';
import 'package:till/globals.dart' as globals;

class GoogleSignInProvider extends ChangeNotifier {
  final googleSingIn = GoogleSignIn();

  final firestoreInstance = FirebaseFirestore.instance;

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future<void> googleLogin() async {
    try {
      final googleUser = await googleSingIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      notifyListeners();

      globals.usuario!.id = _user!.id;
      globals.usuario!.nombre = _user!.displayName.toString();
      globals.usuario!.correo = _user!.email;
      print(_user!.photoUrl);
      globals.usuario!.foto = _user!.photoUrl;

      bool existe = false;

      firestoreInstance.collection("users").get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          print(result.get('uid') + '<google_sing>' + _user!.id);
          if (result.get('uid') == _user!.id) {
            existe = true;
            return;
          }
          print('exite usuario?' + existe.toString());
        });
        if (existe == false) {
          final addU = AddUser(_user!.id, _user!.displayName.toString(),
              _user!.email, _user!.serverAuthCode.toString());
          addU.addUser();
          print('usuario agregado');
        }else{

        }
      });
    } catch (Exception) {
      print(Exception.toString());
    }
  }

  Future logout() async {
    await googleSingIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
