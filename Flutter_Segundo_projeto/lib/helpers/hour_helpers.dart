class HourHelpers {
  ///faremos um metodo para ajudar a transforma a string do firebase em data funcional , onde passaremos as Horas
  static int hoursToMinutos(String hours) {
    ///pegaremos as parte das horas
    List<String> parts = hours.split(':');

    ///pegaremos as horas
    int h = int.parse(parts[0]);

    ///pegaremos os minutos
    int m = int.parse(parts[1]);

    /// retornaremos agora a hora formatada
    return h * 60 + m;
  }

  static String minutesToHours(int minutes) {
    int h = minutes ~/ 60;

    /// ~/ é o operador de divisão inteira (quociente) Exemplo: 130 minutos ~/ 60 = 2 horas
    int m = minutes % 60;

    /// % é o operador módulo (resto da divisão) Exemplo: 130 % 60 = 10 minutos
    ///padLeft(2, '0') - garante que o número tenha pelo menos 2 dígitos, preenchendo com zeros 
    ///à esquerda quando necessário Exemplo: 2 vira "02", 10 vira "10"
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }
}
