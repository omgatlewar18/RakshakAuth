import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'landingpage.dart';
import 'database_service.dart';

class Screens {
  String? name;
  bool create;
  bool read;
  bool update;
  bool delete;

  Screens({
    this.name,
    this.create = false,
    this.read = false,
    this.update = false,
    this.delete = false,
  }
      );

  Map<String, dynamic> toJson() {
    return {
      "ScreenName": name,
      "create": create,
      "read": read,
      "update": update,
      "delete": delete,
    };
  }

  factory Screens.fromJson(Map<String, dynamic> json) {
    return Screens(
      name: json["ScreenName"],
      create: json["create"] ?? false,
      read: json["read"] ?? false,
      update: json["update"] ?? false,
      delete: json["delete"] ?? false,
    );
  }
}

class AppUser {
  String? username;
  String? password;
  String? email;
  String? uid;
  Map<String, Screens>? screens;

  AppUser({this.username, this.password, this.email, this.uid, this.screens});

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "email": email,
      "uid": uid,
      "screens": screens?.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json, String uid) {
    final screensData = json["screens"] as Map<String, dynamic>?;
    Map<String, Screens>? screens;
    if (screensData != null) {
      screens = screensData.map((key, value) => MapEntry(key, Screens.fromJson(value)));
    }

    return AppUser(
      username: json["username"],
      password: json["password"],
      email: json["email"],
      uid: uid,
      screens: screens,
    );
  }
}

class LoginProvider extends ChangeNotifier {
  AppUser? currentuser;
  bool get isAdmin => currentuser?.email == 'arg07work@gmail.com';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();



  Future<bool> signInWithGoogle(BuildContext context) async {

    try {
      final GoogleSignInAccount? silentUser = await _googleSignIn.signInSilently();
      if (silentUser != null) {
        await _googleSignIn.disconnect();
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      currentuser = AppUser(
        username: userCredential.user?.displayName,
        email: userCredential.user?.email,
        uid: userCredential.user?.uid,
      );

      await _dbRef.child("users/${currentuser!.uid}").set(currentuser!.toJson());

      notifyListeners();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LandingPage()),
      );

      return true;
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      return false;
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } catch (_) {}

    if (await _googleSignIn.isSignedIn()) {
      try {
        await _googleSignIn.disconnect();
      } catch (_) {}
    }

    await _googleSignIn.signOut();

    currentuser = null;
    notifyListeners();
  }

  Future<void> addUser(AppUser user) async {
    await _dbRef.child("users/${user.uid}").set(user.toJson());
    notifyListeners();
  }

  Future<void> deleteUser(String uid) async {
    await _dbRef.child("users/$uid").remove();
    notifyListeners();
  }

  Future<void> editUser(AppUser updatedUser) async {
    await _dbRef.child("users/${updatedUser.uid}").update(updatedUser.toJson());
    notifyListeners();
  }

  Future<List<AppUser>> listUsers() async {
    DataSnapshot snapshot = await _dbRef.child("users").get();

    if (snapshot.exists) {
      Map<dynamic, dynamic> usersData = snapshot.value as Map<dynamic, dynamic>;
      return usersData.entries.map((entry) {
        return AppUser.fromJson(Map<String, dynamic>.from(entry.value), entry.key);
      }).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> screens(String uid) async {
    DataSnapshot snapshot = await _dbRef.child("users/$uid/screens").get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }
    return {};
  }
}