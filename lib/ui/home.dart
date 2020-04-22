import 'dart:io';

import 'package:flutter/material.dart';
import 'package:agenda_contatos/helpers/contatos_helper.dart';

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
    helper.listarContatos().then(
      (lista) {
        setState(() {
          contatos = lista;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agenda de contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        splashColor: Colors.greenAccent,
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: contatos.length,
        itemBuilder: (context, index) {
          return _cards(context,index);
        },
      ),
    );
  }

  Widget _cards(BuildContext context, int index) {
    return GestureDetector(
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
}