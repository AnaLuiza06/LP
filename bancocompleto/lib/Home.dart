import 'package:flutter/material.dart';
import 'package:bancocompleto/helper/AnotacaoHelper.dart';
import 'package:bancocompleto/model/Anotacao.dart';
import 'package:intl/intl.dart';//import de data
import 'package:intl/date_symbol_data_local.dart';//local ou origem de onde utilizaremos o padrao de data

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _tituloController = TextEditingController(); //variaveis da tela
  TextEditingController _descricaoController = TextEditingController(); //variaveis da tela
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = <Anotacao>[];
  _exibirTelaCadastro( {Anotacao? anotacao} ){ //exibe tela de cadastro/edicao

    String textoSalvarAtualizar = "";
    if( anotacao == null ){//salvando
      _tituloController.text = "";
      _descricaoController.text = "";
      textoSalvarAtualizar = "Salvar";
    }else{//atualizar
      _tituloController.text = anotacao.titulo;
      _descricaoController.text = anotacao.descricao;
      textoSalvarAtualizar = "Atualizar";
    }

    showDialog( // janelinha de cadastro
        context: context,
      builder: (context){
          return AlertDialog(
            title: Text("$textoSalvarAtualizar anotação"),
            content: Column(
              mainAxisSize: MainAxisSize.min,//min ocupa o espaco minimo da tela / max ocupa o maximo da tela
              children: <Widget>[
                TextField(//primeiro campo de texto (titulo)
                  controller: _tituloController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Título",
                    hintText: "Digite título..."
                  ),
                ),
                TextField( //segundo campo de texto (descricao)
                  controller: _descricaoController,
                  decoration: InputDecoration(
                      labelText: "Descrição",
                      hintText: "Digite descrição..."
                  ),
                )
              ],
            ),
            actions: <Widget>[//botoes da tela criada para insercao dos dados
              FlatButton(
                  onPressed: () => Navigator.pop(context),//comando para fechar a tela/janela
                  child: Text("Cancelar")
              ),
              FlatButton(
                  onPressed: (){
                    //salvar
                    _salvarAtualizarAnotacao(anotacaoSelecionada: anotacao);
                    Navigator.pop(context);
                  },
                  child: Text(textoSalvarAtualizar)//
              )
            ],
          );
      }
    );
  }

  _recuperarAnotacoes() async {
    List anotacoesRecuperadas = await _db.recuperarAnotacoes();//chama o metodo recuperar anotacoes do helper
    List<Anotacao> listaTemporaria = <Anotacao>[];//cria uma lista
    for( var item in anotacoesRecuperadas ){//corre toda a lista de cadastros
      //Anotacao anotacao = Anotacao.fromMap( item );//converte map em objeto
      Anotacao anotacao = Anotacao(item["titulo"], item["descricao"], item["data"], id: item["id"]);
      listaTemporaria.add( anotacao );//adiciona todos objetos na lista temporaria
    }

    setState(() {
      _anotacoes = listaTemporaria;//atualiza a tela
    });
    //listaTemporaria=null;
  }

  _salvarAtualizarAnotacao( {Anotacao? anotacaoSelecionada} ) async {

    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    if( anotacaoSelecionada == null ){//salvar
      Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString() );
      int resultado = await _db.salvarAnotacao( anotacao );
    }else{//atualizar
      anotacaoSelecionada.titulo    = titulo;
      anotacaoSelecionada.descricao = descricao;
      anotacaoSelecionada.data      = DateTime.now().toString();//recupera a data atual//converte a data no formato string
      int resultado = await _db.atualizarAnotacao( anotacaoSelecionada );
    }

    _tituloController.clear();//limpa o campo apos salvar/atualizar
    _descricaoController.clear();//limpa o campo apos salvar/atualizar
    _recuperarAnotacoes();//atualizar tela e todos cadastros
  }

  _formatarData(String data){
    //Intl (Padrao de datas)
    //atualizar pubspec intl: ^0.15.8
    initializeDateFormatting("pt_BR");//pais de onde quer trabalhar com formatacao de data //Brasil

    //Year -> y month-> M Day -> d
    //Hour -> H minute -> m second -> s
    //var formatador = DateFormat("d/MMMM/y H:m:s");//podemos usar como esta logo abaixo
    var formatador = DateFormat.yMd("pt_BR");//construtor dateformated

    DateTime dataConvertida = DateTime.parse( data );//converte String em datatime
    String dataFormatada = formatador.format( dataConvertida );//conclui a formatacao
    return dataFormatada;
  }

  _removerAnotacao(int? id) async {
    if( id == null ){
      print("Id nulo para exclusao");
    }else {
      await _db.removerAnotacao(id);
      _recuperarAnotacoes();
    }
  }

  @override
  void initState() {//recupera os dados antes de construir a tela
    super.initState();
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas anotações"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: <Widget>[
          Expanded(//nossa lista ocupa todo espacamento disponivel
              child: ListView.builder(
                  itemCount: _anotacoes.length,//exibi'c~ao configurada de acordo com a quantidade de anotacoes
                  itemBuilder: (context, index){//
                    final anotacao = _anotacoes[index];//recuperando uma anotacao
                    return Card(//widget que cria um efeito de cartao na interface grafica
                      child: ListTile(//lista de itens do banco de dados
                        title: Text( anotacao.titulo ),//pega o titulo da anotacao recuperada logo acima
                        subtitle: Text("${_formatarData(anotacao.data)} - ${anotacao.descricao}") ,//pega data e descricao da anotacao recuperada
                        trailing: Row(//trailing configura parte direita da tela atualizar/excluir gesturedetector
                          mainAxisSize: MainAxisSize.min,//utiliza o espaco minimo da tela
                          children: <Widget>[
                            GestureDetector(//botao ou componente de atualizacao
                              onTap: (){
                                _exibirTelaCadastro(anotacao: anotacao);//se passo anotacao estou atualizando
                              },
                              child: Padding(
                                  padding: EdgeInsets.only(right: 16),//espacamento entre icones atualizar e excluir
                                child: Icon(
                                  Icons.edit,//icone editar
                                  color: Colors.green,//cor do componente
                                ),
                              ),
                            ),
                            GestureDetector(//botao ou componente de remocao
                              onTap: (){
                                _removerAnotacao( anotacao.id );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 0),
                                child: Icon(
                                  Icons.remove_circle,//icone remover
                                  color: Colors.red,//cor do item
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );

                  }
              )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(//botao na barra inferior da tela
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: (){
            //se nao passo anotacao estou cadastrando
            _exibirTelaCadastro();//chama funcao de cadastro ou edicao
          }
      ),
    );
  }
}
