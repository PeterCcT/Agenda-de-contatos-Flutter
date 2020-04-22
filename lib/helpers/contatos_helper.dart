import 'package:path/path.dart';
import 'dart:async';
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

  Future<Database> get db async {
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

  Future<Contato> salvarContato(Contato contato) async {
    Database bdContato = await db;
    contato.id = await bdContato.insert(nomeBd, contato.toMap());
    return contato;
  }

  Future<Contato> obterContato(int id) async {
    Database bdContato = await db;
    List<Map> map = await bdContato.query(
      nomeBd,
      columns: [idBd, nomeBd, emailBd, telBd, imgBd],
      where: "$idBd = ?",
      whereArgs: [id],
    );
    if (map.length > 0) {
      return Contato.fromMap(map.first);
    } else {
      return null;
    }
  }

  Future<int> deletarContato(int id) async {
    Database bdContato = await db;
    return await bdContato.delete(nomeBd, where: "$idBd = ?", whereArgs: [id]);
  }

  editarContato(Contato contato) async {
    Database bdContato = await db;
    bdContato.update(
      nomeBd,
      contato.toMap(),
      where: "$idBd = ?",
      whereArgs: [contato.id],
    );
  }

  Future<List> listarContatos() async {
    Database bdContato = await db;
    List listMap = await bdContato.rawQuery("select * from $nomeBd");
    List<Contato> listaContatos = List();
    for (Map map in listMap) {
      listaContatos.add(Contato.fromMap(map));
    }
    return listaContatos;
  }

  Future<int> quantNumeros() async {
    Database bdContato = await db;
    return Sqflite.firstIntValue(
      await bdContato.rawQuery("select count(*) from $nomeBd"),
    );
  }

  close() async {
    Database bdContato = await db;
    bdContato.close();
  }
}

class Contato {
  //atributos
  int id;
  String nome;
  String email;
  String telefone;
  String img;
  
  Contato.fromMap(Map map) {
    id = map[idBd];
    nome = map[nomeBd];
    email = map[emailBd];
    telefone = map[telBd];
    img = map[imgBd];
  }

  Contato();

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
