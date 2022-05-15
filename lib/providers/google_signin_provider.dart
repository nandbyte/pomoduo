import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pomoduo/models/user.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  bool _isSignedIn = false;
  String? _documentID;
  List<String>? roomHistory;
  List<String>? joinHistory;
  // PomoduoUser? _currentUser;

  GoogleSignInAccount get user => _user!;
  bool get isSignedIn => _isSignedIn;
  String get documentId => _documentID.toString();
  // PomoduoUser get currentUser => _currentUser!;

  changeDocumentId(String _id) {
    _documentID = _id;
    print("Document id $_id");
    notifyListeners();
  }

  // changeCurrentUser(PomoduoUser _fetchedUser) {
  //   _currentUser = _fetchedUser;
  //   notifyListeners();
  // }

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return;
    } else {
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      _isSignedIn = true;
    }

    notifyListeners();
  }

// TODO: implement this
  googleLogout() async {
    await FirebaseAuth.instance.signOut().then((_) {
      _isSignedIn = false;
    });
    notifyListeners();
  }
}
