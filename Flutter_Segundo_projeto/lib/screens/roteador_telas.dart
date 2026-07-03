import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:primeiro_projeto/screens/home_screen.dart';
import 'package:primeiro_projeto/screens/loggin_screen.dart';

class RouterScreen extends StatelessWidget {
  const RouterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ///ao inves de ter Scarffold que é o default teremos STREAMBUILDER
    /// O 1º Paramentro. O StreamBuider receberá algo para vigiar em nosso caso o FirebaseAuth onde ficaremos com as mudanças de User.
    /// Ou seja caso haja, ele nos retornará.
    /// o Segundo parametro é para construir algo, ou Builder onde recebe mais 2 paramentros, nosso contexto e depois snapshot
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        ///verificaremos se temos conexão do firebase com snapshot
        if (snapshot.connectionState == ConnectionState.waiting) {
          /// si tevermos aguardando temos q retornar algo , então vamos por spinner
          return const Center(child: CircularProgressIndicator());
        }
        ///si temos User
        else {
          if (snapshot.hasData) {
            ///se temos vamos para tela de Home ja com dados do User logado
            return HomeScreen(user: snapshot.data);
          } else {
            ///se não temos vamos para tela de Login()
            return LoginScreen();
          }
        }
      },
    );
  }
}
