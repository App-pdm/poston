import 'package:validadores/Validador.dart';

class Validator {
  String validateName(String value) {
    return Validador()
        .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
        .minLength(3, msg: 'Nome precisa conter pelo menos 3 caracteres')
        .maxLength(20, msg: 'Nome pode conter até 20 caracteres')
        .valido(value, clearNoNumber: false);
  }

  String validatePassword(String value) {
    return Validador()
        .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
        .minLength(6, msg: 'Senha precisa conter pelo menos 3 caracteres')
        .maxLength(40, msg: 'Senha pode conter até 20 caracteres')
        .valido(value, clearNoNumber: false);
  }

  String emailValidate(String value) {
    if (value.isEmpty) {
      return "Campo email obrigatório";
    }
    if (!value.contains("@")) {
      return "Email inválido";
    }
    if (value.length < 6) {
      return "Email inválido";
    } else {
      return null;
    }
  }

  String validatePasswordConfirm(String value) {
    return Validador()
        .equals(value, msg: 'Senhas não coincidem')
        .valido(value, clearNoNumber: false);
  }
}
