import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:warehouse/services/auth_service.dart';

class AuthBloc {
  final authService = AuthService();
  final googleSignin = GoogleSignIn(scopes: ['email']);

  Stream<User?> get currentUser => authService.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException {
      // print(e.message);
      rethrow;
    }
    return null;
  }

  // loginGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await googleSignin.signIn();
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser!.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //         idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

  //     //Firebase Sign in
  //     final result = await authService.signInWithCredential(credential);

  //     // ignore: avoid_print
  //     print('${result.user!.displayName}');
  //   } catch (error) {
  //     return (error);
  //   }
  // }

  logout() {
    authService.logout();
  }
}
