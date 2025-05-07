import 'package:firebase_auth/firebase_auth.dart';

class AuthResult {
  final User? user;
  final String? error;
  AuthResult({this.user, this.error});
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email & password
  Future<AuthResult> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult(user: userCredential.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: _getMessageFromCode(e.code));
    } catch (e) {
      return AuthResult(error: 'An unknown error occurred.');
    }
  }

  // Sign up with email & password
  Future<AuthResult> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return AuthResult(user: userCredential.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: _getMessageFromCode(e.code));
    } catch (e) {
      return AuthResult(error: 'An unknown error occurred.');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  String _getMessageFromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'The email is already in use.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'operation-not-allowed':
        return 'Operation not allowed.';
      default:
        return 'Authentication error: $code';
    }
  }
}
