import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/user_model.dart';

/// Thin abstraction over Firebase Authentication + Firestore user profiles.
/// All UI code talks to this repository, never directly to Firebase SDKs.
class AuthRepository {
  AuthRepository({
    fb_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _auth = firebaseAuth ?? fb_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final fb_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  Stream<fb_auth.User?> get authStateChanges => _auth.authStateChanges();

  fb_auth.User? get currentUser => _auth.currentUser;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  /// Email + password sign up. Creates the Firestore profile document.
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = credential.user!.uid;
    await credential.user!.updateDisplayName(name);

    final profile = UserModel(uid: uid, email: email, name: name);
    await _usersCollection.doc(uid).set(profile.toMap());
    return profile;
  }

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _fetchOrCreateProfile(credential.user!);
  }

  Future<UserModel> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw fb_auth.FirebaseAuthException(
        code: 'sign-in-cancelled',
        message: 'Google sign-in was cancelled.',
      );
    }
    final googleAuth = await googleUser.authentication;
    final credential = fb_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await _auth.signInWithCredential(credential);
    return _fetchOrCreateProfile(userCredential.user!);
  }

  /// Sends an OTP-style sign-in link / verification code to [phoneNumber].
  /// [onCodeSent] receives the verificationId needed for [verifyOtp].
  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(fb_auth.FirebaseAuthException e) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (_) {},
      verificationFailed: onError,
      codeSent: (verificationId, _) => onCodeSent(verificationId),
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<UserModel> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = fb_auth.PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final userCredential = await _auth.signInWithCredential(credential);
    return _fetchOrCreateProfile(userCredential.user!);
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
  }

  Future<UserModel> _fetchOrCreateProfile(fb_auth.User user) async {
    final doc = await _usersCollection.doc(user.uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!, user.uid);
    }
    final profile = UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName,
      photoUrl: user.photoURL,
    );
    await _usersCollection.doc(user.uid).set(profile.toMap());
    return profile;
  }

  Future<void> updateProfile(UserModel user) {
    return _usersCollection.doc(user.uid).update(user.toMap());
  }
}
