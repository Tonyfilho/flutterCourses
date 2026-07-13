import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:primeiro_projeto/screens/roteador_telas.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///temos  por para funcionar firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GoogleSignIn.instance.initialize(
    clientId: '42155495380-3foaroa8i9k19ba60afmght57o5ngjl0.apps.googleusercontent.com',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '1º Projeto Horas V3',

      ///  theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),

      ///Outra forma de definir cores
      ///vamos mudar agora usaremos o firebase q direcionará qual tela devemos usar.
      ///com isto vamos criar um gerenciador de telas no lugar do LoginScren();
      ///Criaremos ums Stateless
      /// home: LoginScreen(),
      home: RouterScreen(),
    );
  }
}
