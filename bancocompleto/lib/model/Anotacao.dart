import 'package:bancocompleto/helper/AnotacaoHelper.dart';

class Anotacao{

  int? id;
  String titulo;
  String descricao;
  String data;

  Anotacao(this.titulo, this.descricao, this.data, {this.id});

  /*Anotacao.fromMap(Map map){ //retorna um objeto //converte um map em objeto

    this.id = map["id"];
    this.titulo = map["titulo"];
    this.descricao = map["descricao"];
    this.data = map["data"];
    //nao preciso inserir o retorno. ja estou convertendo direto

  }*/

  Map toMap(){//retorna um map // converte um objeto em map
    Map<String, dynamic> map = {
      "titulo" : this.titulo,
      "descricao" : this.descricao,
      "data" : this.data,
    };

    if( this.id != null ){ //so retorna com id se ele existir
      map["id"] = this.id;
    }

    return map;

  }

}