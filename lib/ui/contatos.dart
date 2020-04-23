import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:agenda_contatos/helpers/contatos_helper.dart';
import 'package:flutter/material.dart';

class PaginaContato extends StatefulWidget {
  final Contato contato;

  PaginaContato({this.contato});

  @override
  _PaginaContatoState createState() => _PaginaContatoState();
}

class _PaginaContatoState extends State<PaginaContato> {
  Contato _editarContato;
  bool _editou = false;
  final _nomeController = TextEditingController();
  final _nomeFoco = FocusNode();
  final _emailController = TextEditingController();
  final _telController = TextEditingController();
  @override
  void initState() {
    super.initState();

    if (widget.contato == null) {
      _editarContato = Contato();
    } else {
      _editarContato = Contato.fromMap(widget.contato.toMap());
      _nomeController.text = _editarContato.nome;
      _emailController.text = _editarContato.email;
      _telController.text = _editarContato.telefone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editarContato.nome ?? "Novo contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.group_add),
          backgroundColor: Colors.redAccent,
          onPressed: () {
            if (_editarContato.nome != null &&
                _nomeController.text.isNotEmpty) {
              _editarContato.id = UniqueKey().toString();
              Navigator.pop(context, _editarContato);
            } else {
              FocusScope.of(context).requestFocus(_nomeFoco);
            }
          },
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _editarContato.img != null
                          ? FileImage(
                              File(_editarContato.img),
                            )
                          : AssetImage("images/contato.png"),
                          fit: BoxFit.scaleDown 
                    ),
                  ),
                ),
                onTap: () {
                  ImagePicker.pickImage(source: ImageSource.gallery).then(
                    (image) {
                      if (image == null)
                        return null;
                      else
                        _editarContato.img = image.path;
                    },
                  );
                },
              ),
              TextField(
                focusNode: _nomeFoco,
                decoration: InputDecoration(
                  labelText: "Nome",
                  labelStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: TextStyle(
                  fontSize: 18,
                ),
                onChanged: (text) {
                  _editou = true;
                  setState(() {
                    _editarContato.nome = text;
                  });
                },
                keyboardType: TextInputType.text,
                controller: _nomeController,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: TextStyle(
                  fontSize: 18,
                ),
                onChanged: (text) {
                  _editou = true;
                  setState(() {
                    _editarContato.email = text;
                  });
                },
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Telefone",
                  labelStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: TextStyle(
                  fontSize: 18,
                ),
                onChanged: (text) {
                  _editou = true;
                  setState(() {
                    _editarContato.telefone = text;
                  });
                },
                keyboardType: TextInputType.phone,
                controller: _telController,
              ),
            ],
          ),
        ),
      ),
      onWillPop: _pop,
    );
  }

  Future<bool> _pop() {
    if (_editou) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Descartar alterações?"),
            content: Text(
                "Suas alterações serão descartadas, certeza que deseja continuar?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Não"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Sim"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
