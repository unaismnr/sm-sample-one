import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static Future<bool> signUp(email, password, username) async {
    try {
      final userCred =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCred.user != null) {
        var data = {
          'username': username,
          'email': email,
          'createdAt': DateTime.now(),
        };
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCred.user!.uid)
            .set(data);
      }
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return false;
    } catch (e) {
      log('Auth Signup Catch: $e');
      return false;
    }
  }

  static Future<bool> login(email, password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        print('The password is wrong');
      } else if (e.code == 'user-not-found') {
        print('User not found');
      }
      return false;
    } catch (e) {
      log('Auth Login Catch: $e');
    }
    return false;
  }

  static Future<bool> signOut() async {
    try {
      FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      log('Auth Signout Catch: $e');
      return false;
    }
  }
}
