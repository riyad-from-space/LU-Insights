import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insights/features/auth/model/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String userName,
    required String email,
    required String password,
    required int studentId,
  }) async {
    try {
      //creatae user in firebase auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user == null) {
        throw Exception('User registration failed');
      }

      if (!userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
      }

      //create user

      final user = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        userName: userName,
        password: password,
        studentId: studentId,
      );

      await _firestore.collection('users').doc(user.uid).set(user.toMap());

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //login user

  Future<UserModel> login(
      {required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user == null) {
        throw Exception('User login failed');
      }
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      if (!userDoc.exists) {
        throw Exception('User not found');
      }
      return UserModel.fromMap(userDoc.data()!);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //logout user

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  //get current user

  Future<UserModel> getCurrentUser() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }
      final userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      if (!userDoc.exists) {
        throw Exception('User not found');
      } else {
        return UserModel.fromMap(userDoc.data()!);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
