import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:primeiro_projeto/services/auth_services.dart';

class Menu extends StatelessWidget {
  ///usaremos o uer que vem do firebase
  final User user;
  final AuthServices _authServices = AuthServices();

  ///no construtor temos q por required pois diz ao flutter q não será null
  Menu({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    ///começaremos com o menu, aqui no flutter é o construtor do MENU é drawer();
    return Drawer(
      child: ListView(
        children: [
          ///ou uma ou outra
          ///  UserAccountsDrawerHeader(accountName: Text((localuser.displayName != null) ? localuser.displayName! : ''), accountEmail: Text(localuser.email!))
          UserAccountsDrawerHeader(
            ///cria um radiobox
            currentAccountPicture: const CircleAvatar(
              ///  backgroundImage: NetworkImage('https://pt.vecteezy.com/arte-vetorial/11209565-avatar-do-perfil-do-usuario'),
              /// colocaremos um fundo branco
              backgroundColor: Colors.white,

              ///temos q criar um child para por o icone
              child: Icon(
                ///isto é um boneco redondo é o radiobox
                Icons.manage_accounts_rounded,
                size: 48,
              ),
            ),
            accountName: Text(user.displayName ?? ''),
            accountEmail: Text(user.email!),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Quit'),

            /// aqui no evento de click teremos a função  de saida
            onTap: () {
              _authServices.signOut();
            },
          ),
        ],
      ),
    );
  }
}
