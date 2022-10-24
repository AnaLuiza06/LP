import 'package:bancocompleto/model/Anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper {

  static final String nomeTabela = "anotacao";//nome te uma tabela fixo

  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();
  Database? _db;
  //padrao Singleton
  factory AnotacaoHelper(){//chama o construtor
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal(){//construtor
  }

  get db async {//verifica se ja existe uma instancia do banco de dados

    if( _db != null ){
      return _db; //ja existe
    }else{
      _db = await inicializarDB(); //inicia um banco
      return _db;
    }

  }

  _onCreate(Database db, int version) async {

    /*
    id titulo descricao data
    01 teste  teste     02/10/2020
    * */
    String sql = "CREATE TABLE $nomeTabela ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "titulo VARCHAR, "
        "descricao TEXT, "
        "data DATETIME)";
    await db.execute(sql);
  }

  inicializarDB() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco_minhas_anotacoes.db");
    var db = await openDatabase(localBancoDados, version: 1, onCreate: _onCreate );//chama funcao para criacao do banco de dados
    return db;
  }

  Future<int> salvarAnotacao(Anotacao anotacao) async {//chama a classse anotacao
    var bancoDados = await db;//configura banco de dados
    int resultado = await bancoDados.insert(nomeTabela, anotacao.toMap() );
    return resultado;
  }

  recuperarAnotacoes() async {
    var bancoDados = await db;//configura banco de dados
    String sql = "SELECT * FROM $nomeTabela ORDER BY data DESC ";//sql de consulta no banco de dado
    List anotacoes = await bancoDados.rawQuery( sql );//executa a sql criada
    return anotacoes;//retorna as anotacoes encontradas
  }

  Future<int> atualizarAnotacao(Anotacao anotacao) async {
    var bancoDados = await db;
    return await bancoDados.update(
      nomeTabela,
      anotacao.toMap(),
      where: "id = ?",
      whereArgs: [anotacao.id]
    );
  }

  Future<int> removerAnotacao( int id ) async {
    var bancoDados = await db;
    return await bancoDados.delete(
      nomeTabela,
      where: "id = ?",
      whereArgs: [id]
    );
  }


}

/*

class Normal {

  Normal(){

  }

}

class Singleton {

  static final Singleton _singleton = Singleton._internal();

  	factory Singleton(){
      print("Singleton");
      return _singleton;
    }

    Singleton._internal(){
    	print("_internal");
  	}

}

void main() {

  var i1 = Singleton();
  print("***");
  var i2 = Singleton();

  print( i1 == i2 );

}


* */