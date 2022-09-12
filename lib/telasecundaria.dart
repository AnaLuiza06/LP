import 'package:flutter/material.dart';

class TelaSecundaria extends StatefulWidget {
  dynamic? valor; //preciso criar a variável

  TelaSecundaria(
      {this.valor}); //preciso criar este construtor //Quando coloco entre { } é um parâmetro opcional. Pode ou não ser passado.

  @override
  _TelaSecundariaState createState() => _TelaSecundariaState();
}

class _TelaSecundariaState extends State<TelaSecundaria> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela Secundaria"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            Text(
                "Segunda tela! valor passado: ${widget.valor} ")
            //não consigo acessar as variáveis de forma direta. Preciso utilizar o widget. ou this.widget.
          ],
        ),
      ),
    );
  }
}