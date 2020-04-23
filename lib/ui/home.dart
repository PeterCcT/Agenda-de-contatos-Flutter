import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:agenda_contatos/ui/contatos.dart';
import 'package:flutter/material.dart';
import 'package:agenda_contatos/helpers/contatos_helper.dart';

enum Sort { sortAZ, sortZA }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HelperContato helper = HelperContato();

  List<Contato> contatos = List();
  @override
  void initState() {
    super.initState();
    print(helper.listarContatos());
    _obterContatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agenda de contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<Sort>(
            itemBuilder: (context) => <PopupMenuEntry<Sort>>[
              const PopupMenuItem<Sort>(
                child: Text("Ordenar de A-Z"),
                value: Sort.sortAZ,
              ),
              const PopupMenuItem<Sort>(
                child: Text("Ordenar de Z-A"),
                value: Sort.sortZA,
              ),
            ],
            onSelected: _sortList,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _paginaContato();
        },
        splashColor: Colors.greenAccent,
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: contatos.length,
        itemBuilder: (context, index) {
          return _cards(context, index);
        },
      ),
    );
  }

  Widget _cards(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _mostrarOpcoes(context, index);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contatos[index].img != null
                        ? FileImage(File(contatos[index].img))
                        : AssetImage("images/contato.png"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contatos[index].nome ?? "",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      contatos[index].email ?? "",
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      contatos[index].telefone ?? "",
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 1,
                      ),
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

  void _obterContatos() {
    helper.listarContatos().then(
      (lista) {
        setState(() {
          contatos = lista;
        });
      },
    );
  }

  void _paginaContato({Contato contato}) async {
    final recuperarContato = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaginaContato(
          contato: contato,
        ),
      ),
    );
    if (recuperarContato != null) {
      if (contato != null) {
        await helper.editarContato(recuperarContato);
        _obterContatos();
      } else {
        await helper.salvarContato(recuperarContato);
        _obterContatos();
      }
    }
  }

  void _sortList(Sort tipo) {
    switch (tipo) {
      case Sort.sortAZ:
        contatos.sort(
          (a, b) {
           return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
          },
        );
        break;
      case Sort.sortZA:
        contatos.sort(
          (a, b) {
           return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
          },
        );
        break;
    }
    setState(() {});
  }

  void _mostrarOpcoes(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        launch('tel:${contatos[index].telefone}');
                      },
                      child: Text(
                        'Ligar',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Divider(),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _paginaContato(contato: contatos[index]);
                      },
                      child: Text(
                        'Editar',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Divider(),
                    FlatButton(
                      onPressed: () {
                        helper.deletarContato(contatos[index].id);
                        setState(() {
                          contatos.removeAt(index);
                          Navigator.pop(context);
                        });
                      },
                      child: Text(
                        'Excluir',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      },
    );
  }
}
