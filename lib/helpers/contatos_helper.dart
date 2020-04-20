import 'package:flutter/rendering.dart';
import 'package:sqflite/sqflite.dart';

//colunas do database
final idBd = "idCol";
final nomeBd = "nomeCol";
final emailBd = "emailCol";
final telBd = "telefoneCol";
final imgBd = "imgCol";

class HelperContato {
  //atributos
}

class Contato {
  //atributos
  int id;
  String nome;
  String email;
  String telefone;
  String img;
  //construtor
  Contato.fromMap(Map map) {
    id = map[idBd];
    nome = map[nomeBd];
    email = map[emailBd];
    telefone = map[telBd];
    img = map[imgBd];
  }

  //métodos
  Map toMap() {
    Map<String, dynamic> map = {
      nomeBd: nome,
      emailBd: email,
      telBd: telefone,
      imgBd: img
    };
    if (id != null) {
      map[idBd] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contato(id: $id, nome: $nome, email: $email, telefone: $telefone, img: $img)";
  }
}
