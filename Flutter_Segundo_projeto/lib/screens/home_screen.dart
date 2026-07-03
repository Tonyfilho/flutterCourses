import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:primeiro_projeto/components/menu.dart';
import 'package:primeiro_projeto/helpers/hour_helpers.dart';
import 'package:primeiro_projeto/models/hours.dart';
import 'package:uuid/uuid.dart';

///esta tela será com dados mutáveis, por isto q temos que por StateFull
class HomeScreen extends StatefulWidget {
  final User? user;

  ///No construtor não precisa por o "=" e nem "{}"
  HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ///teremos uma lista uma lista de Horas que virá do firebase
  List<Hours> listHours = [];

  ///teremos a instancia do firebase store
  FirebaseFirestore db = FirebaseFirestore.instance;

  ///teremos um @verride no metodo initState para depois mudar o comportamento do InitState
  /// é o contrutor como do angular. o OnInit();
  @override
  void initState() {
    super.initState();
    reFresh();

    ///temos q criar um setup do firebase aqui antes e depois
  }

  @override
  Widget build(BuildContext context) {
    ///aqui será a parte do User q vem do firebase
    return Scaffold(
      ///teremos um drawer que recebe um menu
      drawer: Menu(user: widget.user!),
      appBar: AppBar(title: Text("1º App de  Horas")),

      ///teremos o botão
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /***Temos que criar a função do botão e mostrar o formulário*/
          showFormModal();
        },

        ///colocaaremos um icone de adcionar
        child: Icon(Icons.add),
      ),

      ///temos umas uma propriedade  que e o corpo BODY onde passaremos a lista
      ///usaremos um ternario, para tela e ja faremos o css do texto.
      body: (listHours.isEmpty)
          ? const Center(
              child: Text(
                "Do not have Data\n.Lets register our Datatime",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView(
              padding: EdgeInsets.only(left: 4, right: 4),

              ///dentro desta lista temos  filhos, que recebem uma list do tipo generate e tamanho da list
              children: List.generate(listHours.length, (i) {
                Hours model = listHours[i];

                ///fazer com que quando passe o dedo e arraste exclui
                ///a chave vamos pegar do Horas
                ///Uma direção de exlusão do final para começo
                ///um background container para ficar no fundo do icone, quando estivermos exluindo algo, o fundo será este container
                return Dismissible(
                  key: ValueKey<Hours>(model),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    ///aqui temos um alinhamento
                    alignment: Alignment.centerRight,

                    ///adcionaremos um padding
                    padding: const EdgeInsets.only(right: 12),

                    ///teremos uma cor
                    color: Colors.red,

                    /// teremos um child onde colocaremos  icone de uma delete
                    child: Icon(Icons.delete, color: Colors.white),
                  ),

                  ///em nosso ondismissed termos q por uma direção
                  onDismissed: (direction) {
                    ///remove será um função criada para remover do firestorage
                    remove(model);
                  },

                  ///este child será um cards
                  child: Card(
                    elevation: 2,

                    ///o filho será uma coluna
                    child: Column(
                      ///aqui dentro teremos varios filho, varias linhas ou campos
                      ///quando temos um card temos algumas propriedades
                      children: [
                        ListTile(
                          ///uma das propriedades é LONGPRESS , quando ficarmos precionado teremos um EVENTO de click
                          onLongPress: () {
                            ///neste caso vamos mostrar uns itens
                            ///criaremos uma função para destar algo na tela
                            showFormModal();
                          },

                          ///teremos outro evento de clicar na TELA e na lista
                          onTap: () {},

                          ///leading é para ficcar algo ao lado da coluna, como se fosse um icone
                          leading: Icon(Icons.list_alt_rounded, size: 56),

                          ///colocaremos um texto no meu do card
                          ///com data e hora usando a classe helpers
                          title: Text(
                            "Date: ${model.data} Hours: ${HourHelpers.minutesToHours(model.minutos)}",
                          ),

                          ///aqui na parte de baixo teremos o Subtitle
                          subtitle: Text(model.descricao ?? 'Not Data'),
                        ),
                      ],
                    ),
                  ),
                );

                ///temos o Ondimissible
              }),
            ),
    );
  }

  void showFormModal({Hours? model}) {
    ///este metodo será usado para cadastrar e para editar
    ///este metodo será usado para cadastrar e para editar
    String title = "Add";
    final String confirmationButton = "Save";
    final String skipButton = "Cancel";

    ///usaremos os controladores e temos q instalar este plugins
    /// flutter pub add mask_text_input_formatter

    /// começaremos fazendo o form
    final TextEditingController dataController = TextEditingController();

    ///criaremos a primeira mascara
    final dataMaskFormatter = MaskTextInputFormatter(mask: '##/##/####');

    final TextEditingController minutesController = TextEditingController();

    ///criando a segunda mascara
    final minutesMaskFormatter = MaskTextInputFormatter(mask: '##:##');

    final TextEditingController descricaoController = TextEditingController();
    if (model != null) {
      title = "Edit";
      dataController.text = model.data;
      minutesController.text = HourHelpers.minutesToHours(model.minutos);

      ///apesar de fazer a verificação mesmo assim temos que usar "!"
      if (model.descricao != null) {
        descricaoController.text = model.descricao!;
      }
      // _confirmationButton = "Update";
      // _skipButton = "Quit";
    }

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

          ///temos criar um child onde startarmos o ListView onde formataremos e mostraremos como
          ///deve ser digitado pelo user no form
          child: ListView(
            children: [
              ///aqui termos uma lista de campos
              ///teremos o texto com tilulo e  contexto e tamnho do texto
              Text(title, style: Theme.of(context).textTheme.headlineSmall),

              ///aqui teremos os outros campos do form
              TextFormField(
                ///um controlador que ja traz a data aplicada
                controller: dataController,

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
              TextFormField(
                ///um controlador que ja traz a minuto aplicado
                controller: minutesController,

                ///um formatador de data para ajuda com o teclado
                keyboardType: TextInputType.number,

                /// é uma decoração do texto que devemos digitar, é um exemplo visual
                decoration: InputDecoration(
                  hintText: '00:00',
                  labelText: 'Hours',
                ),
                inputFormatters: [minutesMaskFormatter],
              ),

              ///daremos um espaço na linha
              const SizedBox(height: 16),

              ///e terremos outro textForm com outros campos
              TextFormField(
                controller: descricaoController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Tell us what you made durring the workdays',
                  labelText: 'Workday descriptions',
                ),
              ),

              ///daremos um espaço na linha
              const SizedBox(height: 16),

              ///adicionaremos uma linha, de dentro da linah temos varias coia, por isto do children[]
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      ///como é um modal isto ficará na frente da tela então não temos rota da tela
                      ///usaremos um popup de navegação, para usuario voltar
                      Navigator.pop(context);
                    },

                    ///aqui daremos nome ao botão
                    child: Text(skipButton),
                  ),

                  ///teremos um espaço agora na largura e não na altura pois estamos dentro de uma linha
                  const SizedBox(width: 16),

                  ///temos nosso botão de salvar no firebase, e para isto temos q criar uma instancia de horas, e passar os dados do form para o firebase
                  ElevatedButton(
                    onPressed: () {
                      ///criaremos a instacia de horas, usamos Uuid() gerar uma ID nã repedito,temos q intalar um pacote
                      /// passa o data controle e converter de oras para minutos
                      Hours hours = Hours(
                        id: const Uuid().v1(),
                        data: dataController.text,
                        minutos: HourHelpers.hoursToMinutos(
                          minutesController.text,
                        ),
                      );
                      if (descricaoController.text.isNotEmpty) {
                        ///lembrandro que a descrição é opcional, por isto temos q fazer uma verificação se o campo esta vazio ou não
                        hours.descricao = descricaoController.text;
                      }
                      if (model != null) {
                        ///se o model for diferente de nulo, então é uma edição, e temos q passar o id do model para o hours q ja existe no firebase, para não criar um novo registro e sim atualizar o existente
                        hours.id = model.id;
                      }

                      ///salvando no firestore
                      db
                          .collection(widget.user!.uid)
                          .doc(hours.id)
                          .set(hours.toMap());

                      ///visualizar o retorno do firebase, para ver se esta salvando corretamente
                      ///criaremos um metodo para mostrar o retorno do firebase, e depois chamaremos este metodo aqui
                      reFresh();

                      Navigator.pop(context);
                    },
                    child: Text(confirmationButton),
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

  void remove(Hours model) {
    ///falta implementar o firestorage aqui no remove
    db.collection(widget.user!.uid).doc(model.id).delete();
    reFresh();
  }

  void reFresh() {
    double total = 0;
    List<Hours> temp = [];
    db.collection(widget.user!.uid).get().then((value) {
      for (var doc in value.docs) {
        Hours hours = Hours.fromMap(doc.data());
        temp.add(hours);
        total += hours.minutos;
      }

      setState(() {
        listHours = temp;
      });
    });
  }

  void reFreshComThen() {
    double total = 0;
    List<Hours> temp = [];
    Future<QuerySnapshot<Map<String, dynamic>>> future = db
        .collection(widget.user!.uid)
        .get();

    future.then(
      (onValue) => {
        onValue.docs.forEach((doc) {
          Hours hours = Hours.fromMap(doc.data());
          temp.add(hours);
          total += hours.minutos;
        }),
        setState(() {
          listHours = temp;
        }),
      },
    );
  }

  Future<void> reFreshComAsync() async {
    double total = 0;
    List<Hours> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot = await db
        .collection(widget.user!.uid)
        .get();
     for (var doc in snapshot.docs) {
        Hours hours = Hours.fromMap(doc.data());
        temp.add(hours);
        total += hours.minutos;
      };
    setState(() {
      listHours = temp;
    });
  }
}
