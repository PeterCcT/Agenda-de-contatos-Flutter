import 'package:path/path.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:sqflite/sqflite.dart';

//colunas do database
final nomeTabela = "contatos";
final idBd = "idCol";
final nomeBd = "nomeCol";
final emailBd = "emailCol";
final telBd = "telefoneCol";
final imgBd = "imgCol";

class HelperContato {
  //singleton
  static final HelperContato _instance = HelperContato.internal();
  factory HelperContato() => _instance;
  HelperContato.internal();

  Database _db;

  Future<Database>get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  //inicializando banco de dados
  Future<Database> initDb() async {
    final localBd = await getDatabasesPath();
    final caminhoBd = join(localBd, "contatos.db");

    return await openDatabase(
      caminhoBd,
      version: 1,
      onCreate: (Database db, int vRecente) async {
        await db
            .execute("create table $nomeBd($idBd int primary key,$nomeBd text"
                ",$emailBd text,$telBd text, $imgBd text)");
      },
    );
  }
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
