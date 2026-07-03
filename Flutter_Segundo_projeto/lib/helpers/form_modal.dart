import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:primeiro_projeto/helpers/hour_helpers.dart';
import 'package:primeiro_projeto/models/hours.dart';
import 'package:uuid/uuid.dart';

class FormModalHelper {
  FormModalHelper({required this.model, required this.context});

  final Hours? model;
  final BuildContext context;

  ///este metodo será usado para cadastrar e para editar
  String _title = "Add";
  final String _confirmationButton = "Save";
  final String _skipButton = "Cancel";

  ///usaremos os controladores e temos q instalar este plugins
  /// flutter pub add mask_text_input_formatter

  /// começaremos fazendo o form
  final TextEditingController _dataController = TextEditingController();

  ///criaremos a primeira mascara
  final dataMaskFormatter = MaskTextInputFormatter(mask: '##/##/####');

  final TextEditingController _minutesController = TextEditingController();

  ///criando a segunda mascara
  final minutesMaskFormatter = MaskTextInputFormatter(mask: '##/##');

  final TextEditingController _descricaoController = TextEditingController();

  // @override
  // Widget build(BuildContext context) {
  //   return const Placeholder();
  // }
///Metodo ShowFormModel
  void showFormModal() {
    ///faremos as verificações
    if (model != null) {
      _title = "Edit";
      _dataController.text = model!.data;
      _minutesController.text = HourHelpers.minutesToHours(model!.minutos);

      ///apesar de fazer a verificação mesmo assim temos que usar "!"
      if (model!.descricao != null) {
        _descricaoController.text = model!.descricao!;
      }
      // _confirmationButton = "Update";
      // _skipButton = "Quit";
    }

    ///nosso modal com borderRadio Circular
    ///sempre temos que adicionar o contexto que é contexto que diz onde tem que mostrar o item o item na tela.
    ///aqui verificaremos o tamnho da tela e devolveremos um Container()
    /// o contexto vai buscar todas as informação da tela , ex tamanho, espaço etc.
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        ///verificaremos o tamanho da telea por isto temos o container.
        return Container(
          ///of(context) pega o tamnho da tela com base no contexto
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(32),

          ///temos criar um child onde startarmos o ListView onde formataremos e mostraremos como deve ser digitado pelo user no form
          child: ListView(
            children: [
              ///aqui termos uma lista de campos
              ///teremos o texto com tilulo e  contexto e tamnho do texto
              Text(_title, style: Theme.of(context).textTheme.headlineSmall),

              ///aqui teremos os outros campos do form
              TextFormField(
                ///um controlador que ja traz a data aplicada
                controller: _dataController,

                ///um formatador de data para ajuda com o teclado
                keyboardType: TextInputType.datetime,

                /// é uma decoração do texto que devemos digitar, é um exemplo visual
                decoration: InputDecoration(
                  hintText: '01/01/2000',
                  labelText: 'Date',
                ),

                ///logo apos temos que ter o formador de imput, e aplica o formatador, a variavel que fizemos para formatar.
                inputFormatters: [dataMaskFormatter],
              ),

              ///daremos um espaço na linha
              const SizedBox(height: 16),

              ///e terremos outro textForm com outros campos
              TextFormField(
                ///um controlador que ja traz a minuto aplicado
                controller: _minutesController,

                ///um formatador de data para ajuda com o teclado
                keyboardType: TextInputType.number,

                /// é uma decoração do texto que devemos digitar, é um exemplo visual
                decoration: InputDecoration(
                  hintText: '00:00',
                  labelText: 'Works Hours',
                ),
                inputFormatters: [minutesMaskFormatter],
              ),

              ///daremos um espaço na linha
              const SizedBox(height: 16),

              ///e terremos outro textForm com outros campos
              TextFormField(
                controller: _descricaoController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Tell us what you made durring the workdays',
                  labelText: 'Workday descriptions',
                ),
              ),
              const SizedBox(height: 16),

              ///adicionaremos uma linha, de dentro da linah temos varias coia, por isto do children[]
              Row(
                children: [
                  /// 1º um botão com ação de cancelar ou skipbutton
                  TextButton(
                    onPressed: () {
                      ///como é um modal isto ficará na frente da tela então não temos rota da tela
                      ///usaremos um popup de navegação, para usuario voltar
                      Navigator.pop(context);
                    },

                    ///aqui daremos nome ao botão
                    child: Text(_skipButton),
                  ),

                  ///teremos um espaço agora na largura e não na altura pois estamos dentro de uma linha
                  const SizedBox(width: 16),

                  ///temos nosso botão de salvar
                  ElevatedButton(
                    onPressed: () {
                      ///criaremos a instacia de horas, usamos Uuid() gerar uma ID nã repedito,temos q intalar um pacote
                      /// passa o data controle e converter de oras para minutos
                      Hours hours = Hours(
                        id: const Uuid().v1(),
                        data: _dataController.text,
                        minutos: HourHelpers.hoursToMinutos(
                          _minutesController.text,
                        ),
                      );
                    },
                    child: Text(_confirmationButton),
                  ),
                ],
              ),

              ///so lembrando que isto ficará dentro de um coluna no componente principal
              const SizedBox(height: 180),
            ],
          ),
        );
      },
    );
  }

  
}
