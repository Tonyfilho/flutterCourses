import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInWithGoogle {
  Future<UserCredential> signInWithGoogle() async {
    // Implement your Google sign-in logic here


    final GoogleSignIn googleSignIn = GoogleSignIn.instance;

// await googleSignIn.initialize(
//   clientId: '42155495380-3foaroa8i9k19ba60afmght57o5ngjl0.apps.googleusercontent.com',
// );
   // await googleSignIn.initialize();
    final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
