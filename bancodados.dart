// @dart=2.9

//foi necessaario inserir a linha acima para o coodigo funcionar.

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


//Criar Conexao com banco de dados
//Adicionar  sqflite: logo abaixo de  cupertino_icons: ^1.0.2 no pubspec.yaml proximo da linha 35
//Adicionar os imports
//import 'package:sqflite/sqflite.dart';
//import 'package:path/path.dart';


void main() => runApp(
    MaterialApp(
      home: Home(),
    )
);

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _nome = TextEditingController();
  TextEditingController _sobrenome = TextEditingController();
  TextEditingController _ra = TextEditingController();

  //async determina que um metodo sera assincrono, nao retornara algo imediato
  //await serve para mostrar que o app deve esperar uma resposta antes de continuar.
  //Future determina que uma funcao ira retornar algo no futuro. Levara um tempo para ser executada.

  _recuperarBancoDados() async {

    final caminhoBancoDados = await getDatabasesPath(); //recupera o caminho do banco no celular do usuario
    final localBancoDados = join(caminhoBancoDados, "meubanco.db"); // nome do banco de dados a ser recuperado/utilizado

    var bd = await openDatabase(
        localBancoDados, // Banco de dados utilizado
        version: 1, //Eu crio a versao de acordo com meu APP
        onCreate: (db, dbVersaoRecente){ //db permite manipular o banco
          String sql = "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, sobrenome VARCHAR, ra VARCHAR) ";
          db.execute(sql);
        }
    );
    return bd;
    //print("aberto: " + bd.isOpen.toString() );
  }

  Future _salvar() async {

    Database bd = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      "nome" : _nome.text,
      "sobrenome": _sobrenome.text,
      "ra": _ra.text
    };
    print(dadosUsuario);
    String sql = "insert into usuarios (nome, sobrenome, ra) values (?,?,?)";
    // int id = await bd.insert("usuarios", dadosUsuario);
    int id2 = await bd.rawInsert(sql, [dadosUsuario['nome'], dadosUsuario['sobrenome'], dadosUsuario['ra']]);
    print(id2);
    _listarUsuarios();

  }

  Future _listarUsuarios() async {

    Database bd = await _recuperarBancoDados();

    //String sql = "SELECT * FROM usuarios WHERE id = 5 ";
    //String sql = "SELECT * FROM usuarios WHERE idade >= 30 AND idade <= 58";
    //String sql = "SELECT * FROM usuarios WHERE idade BETWEEN 18 AND 46 ";
    //String sql = "SELECT * FROM usuarios WHERE idade IN (18,30) ";
    //String filtro = "an";
    //String sql = "SELECT * FROM usuarios WHERE nome LIKE '%" + filtro + "%' ";
    //String sql = "SELECT *, UPPER(nome) as nomeMaiu FROM usuarios WHERE 1=1 ORDER BY UPPER(nome) DESC ";//ASC, DESC
    //String sql = "SELECT *, UPPER(nome) as nomeMaiu FROM usuarios WHERE 1=1 ORDER BY idade DESC LIMIT 3";//ASC, DESC
    String sql = "SELECT * FROM usuarios ";//ASC, DESC
    List usuarios = await bd.rawQuery(sql);

    for( var usuario in usuarios ){
      print(
          "item id: " + usuario['id'].toString() +
              " nome: " + usuario['nome'] +
              " sobrenome: " + usuario['sobrenome'] +
              " ra: " + usuario['ra']
      );
    }

    //print("usuarios: " + usuarios.toString() );

  }

  Future _listarUsuarioPeloId(int id) async {

    Database bd = await _recuperarBancoDados();

    //CRUD -> Create, Read, Update and Delete
    List usuarios = await bd.query(
        "usuarios",
        columns: ["id", "nome", "sobrenome", "ra"],
        where: "id = ?",
        whereArgs: [id]
    );

    for( var usuario in usuarios ){
      print(
          "item id: " + usuario['id'].toString() +
              " nome: " + usuario['nome'] +
              " sobrenome: " + usuario['sobrenome'] +
              " ra: " + usuario['ra']
      );
    }

  }

  Future _excluir(int id) async {

    Database bd = await _recuperarBancoDados();

    int retorno = await bd.delete(
        "usuarios",
        /*where: "id = ?",
      whereArgs: [id]*/
        where: " nome = ? AND idade = ?",
        whereArgs: ["Pedro Eavangelista", 40]
    );

    print("item qtde removida: $retorno");

  }

  Future _listar(int id) async {

    Database bd = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      "nome" : "Mariana Almeida",
      "idade" : 18
    };
    int retorno = await bd.update(
        "usuarios",
        dadosUsuario,
        where: "id = ?",
        whereArgs: [id]
    );

    print("item qtde atualizada: $retorno");

  }

  @override
  Widget build(BuildContext context) {

    _salvar();
    //_excluirUsuario(2);
    //_atualizarUsuario(3);
    _listarUsuarios();
    //_listarUsuarioPeloId(2);

    return Scaffold(
        appBar: AppBar(
        title: Text("MyForm"),
        backgroundColor: Colors.red,
      ),

      body: SingleChildScrollView(
        child: Column(
            children: <Widget>[
              Padding(
              padding: EdgeInsets.only(top: 35, bottom: 20),
              child: Text(
                "Form DB",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.red
                ),
              ),
            ),

              TextField(
                keyboardType: TextInputType.text,//caixa de número somente com .
                decoration: InputDecoration(
                    labelText: "Nome:"//texto padrão do campo
                ),
                style: TextStyle(
                    fontSize: 22
                ),
                controller: _nome,//pegando valor do campo gasolina
              ),

              TextField(
                keyboardType: TextInputType.text,//caixa de número somente com .
                decoration: InputDecoration(
                    labelText: "Sobrenome:"//texto padrão do campo
                ),
                style: TextStyle(
                    fontSize: 22
                ),
                controller: _sobrenome,//pegando valor do campo gasolina
              ),

              TextField(
                keyboardType: TextInputType.number,//caixa de número somente com .
                decoration: InputDecoration(
                    labelText: "RA:"//texto padrão do campo
                ),
                style: TextStyle(
                    fontSize: 22
                ),
                controller: _ra,//pegando valor do campo gasolina
              ),

              Padding(
                  padding: EdgeInsets.only(top: 10),//espaçamento superior
                  child:
                  ElevatedButton(
                      child: Text('Salvar'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal,
                        onPrimary: Colors.white,
                        shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      onPressed: _salvar
                  )
              ),
          ]
        ),
      )
    );
  }
}

