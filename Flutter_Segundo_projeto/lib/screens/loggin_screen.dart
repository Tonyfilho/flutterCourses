import 'package:flutter/material.dart';
import 'package:primeiro_projeto/screens/home_screen.dart';
import 'package:primeiro_projeto/screens/register_screen.dart';
import 'package:primeiro_projeto/services/auth_services.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  ///variavel do formulario de email
  final TextEditingController _emailController = TextEditingController();

  ///variavel do formulario de senha
  final TextEditingController _senhaController = TextEditingController();

  final AuthServices _authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    ///temos que passar tudo dentro do construtor do Scaffold para n teremos error
    return Scaffold(
      body: Container(
        ///cor de fundo
        color: Colors.blue,

        ///padding global
        padding: EdgeInsets.all(16),

        ///centraliando
        child: Center(
          ///criação de uma coluna do email e senha
          child: Column(
            /// centralizaremos o conteudo
            mainAxisAlignment: MainAxisAlignment.center,

            ///criaremos os Filhos do Child e seu container
            ///dentro do container colocaremos o o css
            children: [
              Container(
                ///um Padding
                padding: EdgeInsets.all(16),

                /// uma decoração
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  ///Criaremos uma outra coluna dentro do Children
                  children: [
                    ///colocaremos uma logo que a existe no sistema
                    FlutterLogo(size: 76),

                    ///daremos o tamanho
                    SizedBox(height: 16),

                    ///colocaremos um Forms e seu campo
                    TextField(
                      ///ja vem um controller por onde teremos acesso aos dados
                      controller: _emailController,

                      ///colocaremos uma decoração neste campo, como se fosse um placehold no html
                      decoration: InputDecoration(hintText: "email"),
                    ),

                    ///Criemosremo outro espaço para o outro campo
                    SizedBox(height: 16),

                    ///temos o textField mas com uma propriedade de esconder o que for digitado.
                    TextField(
                      ///esconderemos o texto.
                      obscureText: true,

                      ///nossa varial de senha denrto do controller
                      controller: _senhaController,

                      ///o decoration ou seja o placeholder
                      decoration: InputDecoration(hintText: "Password"),
                    ),

                    ///adicionaremos outro espaço
                    SizedBox(height: 16),

                    ///apos isto adcionaremos um botão, que temos de passar um função
                    ///OBS: O filho do Botão pode ser outro Widget, ou uma função neste caso um texto
                    ElevatedButton(
                      onPressed: () {
                        _authServices
                            .signInUser(
                              email: _emailController.text,
                              password: _senhaController.text,
                            )
                            .then((String? error) {
                              ///neste caso querremos os errors
                              if (error != null) {
                                final snackBar = SnackBar(
                                  content: Text(error),
                                  backgroundColor: Colors.red,
                                );
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(snackBar);
                              }
                            });
                      },
                      child: Text("Sign In"),
                    ),

                    ///colocaremos um 1 botão
                    ///temos que por o espaço para começar
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Sign In With Goggle"),
                    ),
                    SizedBox(height: 16),

                    ///criaremos Textbotton onde passaremos um link de cadastro
                    TextButton(
                      onPressed: () {
                        ///usaremos este construtor para mudar de rota e carregar a outra tela
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Text("If dont have account pls Sign Up"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
