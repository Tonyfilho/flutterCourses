import 'package:firebase_auth/firebase_auth.dart';

///Não precisamos do importe do Materia, somente do importe do firebase onde usaremos as authenticações do mesmo

/// *
/// teremos cadastra user,
/// redefinir senha
/// deslogar
/// excluir conta
class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // ignore: unintended_html_in_doc_comment
  ///<String?> tipagem de retorno string ou nula
  Future<String?> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          return "User Not Found";
        case "wrong-password":
          return "Ops.. Something Wrong with Password";
      }
      return e.code;
    }

    ///Retorno null aqui é porque caso esteja correto a autenficação somente execulta
    return null;
  }

  ///cadastraremos um user
  ///Aqui neste metodo receberemos o retorno em uma variavel local com dados do usuário.
  ///Apos receber iremos atualizar o nome dele no Firebase.
  Future<String?> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential userCredencial = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      ///atualizando nome. e User não pode ser nulo , usaremos ! no lugar de ?
      await userCredencial.user!.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "weak-password":
          return "Change The Password is WEAK!";
        case "email-already-in-use":
          return "User Already Registed. Recouver User !";
      }
      return e.code;
    }
    return null;
  }

  ///reset password
  Future<String?> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          return "user not exist";
      }
      return e.code;
    }
    return null;
  }

  ///logout
  Future<String?> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return null;
  }

  /// excluded
  Future<String?> deleteAccount({required String password}) async {
    try {
      ///acabei de logar
      await _firebaseAuth.signInWithEmailAndPassword(
        email: _firebaseAuth.currentUser!.email!,
        password: password,
      );

      /// ja tenho o email e vou fazer a exclusão
      await _firebaseAuth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          return "User does not exist";
      }
      return e.code;
    }
    return null;
  }
} //* end class
