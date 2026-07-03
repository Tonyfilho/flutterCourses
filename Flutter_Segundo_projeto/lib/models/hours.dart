class Hours {
  String id;
  String data;
  int minutos;
  String? descricao;

  Hours({required this.id, required this.data, required this.minutos});
/// converte o padrão da classe para padrão firebase
  Map<String, dynamic> toMap() {
    return {'id': id, 'data': data, 'minutos': minutos, 'descricao': descricao};
  }
///converte os dados do firebase no padrão da classe

  Hours.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      data = map['data'],
      minutos = map['minutos'],
      descricao = map['descricao'];
}
