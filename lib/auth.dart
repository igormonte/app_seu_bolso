import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';



class AuthProvider {
  final FirebaseAuth _auth =  FirebaseAuth.instance;


  Future<bool> loginWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = new GoogleSignIn();
      GoogleSignInAccount account = await googleSignIn.signIn();  
      
      if(account == null)
        return false;
      UserCredential res = await _auth.signInWithCredential(GoogleAuthProvider.credential(
        idToken: (await account.authentication).idToken,
        accessToken: (await account.authentication).accessToken,
      ));
      if(res.user == null)
        return false;
      return true;      
    } catch (e) {
        print("Can'not sign in with Google");
        return false;
      
    }
  }

}