import 'package:flutter/material.dart';
import 'package:primeiro_projeto/services/auth_services.dart';

class ResetPasswordModal extends StatefulWidget {
  const ResetPasswordModal({super.key});

  @override
  State<ResetPasswordModal> createState() => _ResetPasswordModalState();
}

class _ResetPasswordModalState extends State<ResetPasswordModal> {
  ///criaremos no nosso formulario um controller para o email
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  final AuthServices _authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    ///Obs: O Modelo AlertDialog Fim no meio da tela, e não no topo como o Scaffold, por isso não precisamos
    ///colocar um Scaffold dentro do AlertDialog
    return AlertDialog(
      title: Text("Reset Password"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: "Email",
            hintText: "Enter your email",
          ),

          ///pegaremos o valor fo formulario e colocaremos em uma função de validação
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your valid email account';
            }

            ///retornaremos NULL caso esta tudo correto, pois o validator precisa retornar uma String ou null
            return null;
          },
        ),
      ),

      ///teremos um array o actions Tipado
      actions: <TextButton>[
        ///1º botão de cancelar
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

        ///2º botão de resetar a senha
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              ///chamaremos a função de resetar a senha
              ///quando colocamos require na função temo que passar o paramentro como objeto
              _authServices.resetPassword(email: _emailController.text).then((
                String? error,
              ) {
                Navigator.of(context).pop();
                if (error != null) {
                  final snackBar = SnackBar(
                    content: Text(error),
                    backgroundColor: Colors.red,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  final snackBar = SnackBar(
                    content: Text("Password reset email sent to ${_emailController.value.text}"),
                    backgroundColor: Colors.green,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              });
            }
          },
          child: Text("Reset Password"),
        ),
      ],
    );
  }
}
