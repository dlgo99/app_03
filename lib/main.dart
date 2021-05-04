import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Home(),
    )
);

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // VARIAVEIS
  var validado = 0;
  var listaContas = "Vazio";

_img(var imagem){
    return Image.asset(
     imagem,
  //    width: 100,
     // height: 100,
      fit: BoxFit.fill,
    );
  }

  // Widget text
  _textInfo() {
    //_listarContas();
    return Text(
      listaContas,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.black, fontSize: 18.0),
    );
  }

  _recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco9.bd");
    String sql;
    var bd = await openDatabase(
        localBancoDados,
        version: 1,
        onCreate: (db, dbVersaoRecente){
          sql = "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, login VARCHAR, senha VARCHAR)";
          db.execute(sql);
          sql = "CREATE TABLE contas (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, preco VARCHAR, validade VARCHAR)";
          db.execute(sql);
        }
    );
    return bd;
    //print("aberto: " + bd.isOpen.toString() );
  }

  //usuario
  _salvarDados(String login, String senha) async {
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      "login" : login,
      "senha" : senha
    };
    int id = await bd.insert("usuarios", dadosUsuario);
    //print("Adicionado login ($login) e senha ($senha)");
    print("Salvo: $id " );
  }

  _salvarDadosConta(String nome, String preco, String validade) async {
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosConta = {
      "nome" : nome,
      "preco" : preco,
      "validade" : validade,
    };
    int id = await bd.insert("contas", dadosConta);
    //print("Adicionado login ($login) e senha ($senha)");
    print("Salvo: $id " );
  }

  _listarUsuarios() async{
    Database bd = await _recuperarBancoDados();
    String sql = "SELECT * FROM usuarios";
    //String sql = "SELECT * FROM usuarios WHERE senha=58";
    //String sql = "SELECT * FROM usuarios WHERE senha >=30 AND senha <=58";
    //String sql = "SELECT * FROM usuarios WHERE senha BETWEEN 18 AND 58";
    //String sql = "SELECT * FROM usuarios WHERE login='Maria Silva'";
    List usuarios = await bd.rawQuery(sql); //conseguimos escrever a query que quisermos
    for(var usu in usuarios){
      print(" id: "+usu['id'].toString() +
          " login: "+usu['login']+
          " senha: "+usu['senha']);
    }
  }

_listarContas() async{
    Database bd = await _recuperarBancoDados();
    String sql = "SELECT * FROM contas";
    listaContas = "";

    List contas = await bd.rawQuery(sql); //conseguimos escrever a query que quisermos
    for(var usu in contas){
      listaContas+=(" id: "+usu['id'].toString() +
      " nome: "+usu['nome']+
          " preco: "+usu['preco']+
          " validade: "+usu['validade']+"\n");
    }
    print(listaContas);
  }

  _listarUmUsuario(int id) async{
    Database bd = await _recuperarBancoDados();
    List usuarios = await bd.query(
        "usuarios",
        columns: ["id", "login", "senha"],
        where: "id = ?",
        whereArgs: [id]
    );
    for(var usu in usuarios){
      print(" id: "+usu['id'].toString() +
          " login: "+usu['login']+
          " senha: "+usu['senha']);
    }
  }

  /*_excluirUsuario(int id) async{
    Database bd = await _recuperarBancoDados();
    int retorno = await bd.delete(
        "usuarios",
        where: "id = ?",  //caracter curinga
        whereArgs: [id]
    );
    print("Itens excluidos: "+retorno.toString());
  }*/

  _excluirUsuario() async{
    Database bd = await _recuperarBancoDados();
    int retorno = await bd.delete(
        "usuarios",
        where: "login = ? AND senha = ?",  //caracter curinga
        whereArgs: ["Raquel Ribeiro", 26]
    );
    print("Itens excluidos: "+retorno.toString());
  }

  _excluirConta(String nome, String preco, String validade) async{
    Database bd = await _recuperarBancoDados();
    int retorno = await bd.delete(
        "contas",
        where: "nome = ? AND preco = ? AND validade = ?",  //caracter curinga
        whereArgs: [nome, preco, validade]
    );
    print("Itens excluidos: "+retorno.toString());
  }

  _atualizarUsuario(int id) async{
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      "login" : "Antonio Pedro",
      "senha" : 35,
    };
    int retorno = await bd.update(
        "usuarios", dadosUsuario,
        where: "id = ?",  //caracter curinga
        whereArgs: [id]
    );
    print("Itens atualizados: "+ retorno.toString());
  }

  _editarConta(String antigonome, String antigopreco, String antigovalidade,
               String novonome, String novopreco, String novovalidade) async{
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosConta = {
      "nome" : novonome, "preco" : novopreco, "validade" : novovalidade,
    };
    int retorno = await bd.update(
        "contas", dadosConta,
        where: "nome = ? AND preco = ? AND validade = ?",  //caracter curinga
        whereArgs: [antigonome, antigopreco, antigovalidade]
    );
    print("Itens atualizados: "+ retorno.toString());
  }

_validate(String login, String senha) async{
  Database bd = await _recuperarBancoDados();
  int resp = 0;

  List usuarios = await bd.query(
    "usuarios",
    columns: ["id", "login", "senha"],
    where: "login = ? AND senha = ?",
    whereArgs: [login,senha]
  );
    for(var usu in usuarios){
      print(" id: "+usu['id'].toString() +
          " login: "+usu['login']+
          " senha: "+usu['senha']);

      resp = 1;
    }
      if (resp == 1)
        await validar();
      else
        await invalidar();
      print(validado);

      bd = await _recuperarBancoDados();
  }

    String _validate2(String login, String senha) {
    if (login.isEmpty || senha.isEmpty) {
      String infoText = "Digite o Login e a senha";
      return infoText;
    }
    return null;
  }

  bool isEmpty(String a, String b, String c) {
    bool tmp = false; // não validado
    if (a.isEmpty || b.isEmpty || c.isEmpty) {
      tmp = true;
    }
    return tmp;
  }

  validar() async{
    validado = 1;
  }

  invalidar() async{
    validado = 0;
  }

  listarButton(BuildContext context) {
    return Container(
        child: ElevatedButton(
        child:
        Text(
          "Listar Contas",
        ),
        onPressed: () async {
              //for (int i = 0; i < 20; i++)
              await _listarContas();
              //_textInfo();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => menuLista()
                ),
              );
        },
      ),
    );
  }

  menuLista() {
    return Scaffold(
          appBar: AppBar(
            title: Text("Lista"),
            centerTitle: true,
            actions: <Widget>[
            ],
          ),
          body: Center(
            child: Column(
                children: <Widget>[
                  //_listarContas(),
                  _textInfo(),
          ],
            ),
          ),
        );
  }

  menuEditar(String antigonome, String antigopreco, String antigovalidade, BuildContext context){
    TextEditingController _controllernome = TextEditingController();
    TextEditingController _controllerpreco = TextEditingController();
    TextEditingController _controllervalidade = TextEditingController();
    return Scaffold(
          appBar: AppBar(
            title: Text("Editar Conta"),
            centerTitle: true,
            actions: <Widget>[
            ],
          ),
          body: Center(
            child: Column(
                children: <Widget>[
                  TextField(
              decoration: InputDecoration(
                labelText: "Digite o nome: ",
              ),
              controller: _controllernome,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Digite o preco: ",
              ),
              controller: _controllerpreco,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Digite a validade: ",
              ),
              controller: _controllervalidade,
            ),
            SizedBox(height: 20,),
                ElevatedButton(
                    child: Text("Editar"),
                    onPressed: (){
                      if (isEmpty(_controllernome.text, _controllerpreco.text, _controllervalidade.text)){
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context){
                            return AlertDialog(
                              content: Text("Preencha todos os campos!"),
                              actions: <Widget>[
                                RaisedButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    print("OK");
                                  }
                                )
                              ],
                            );
                          },
                        );   
                      }
                      else{
                        print("-> Conta Editada");
                        _editarConta(antigonome, antigopreco, antigovalidade, 
                        _controllernome.text, _controllerpreco.text, _controllervalidade.text);
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context){
                            return AlertDialog(
                              content: Text("Conta Editada"),
                              actions: <Widget>[
                                RaisedButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    print("OK");
                                  }
                                )
                              ],
                            );
                          },
                        );   
                      }
                    }
                ),
          ],
            ),
          ),
        );
  }

  menuRegistro(BuildContext context){
    TextEditingController _controllerlogin = TextEditingController();
    TextEditingController _controllersenha = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro"),
        centerTitle: true,
        actions: <Widget>[
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _img ('assets/images/newuser.png'),
            TextField(
              decoration: InputDecoration(
                labelText: "Digite o login: ",
              ),
              controller: _controllerlogin,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Digite a senha: ",
              ),
              obscureText: true,
              controller: _controllersenha,
            ),
            SizedBox(height: 20,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    child: Text("Registrar"),
                    onPressed: (){
                      if (_validate2(_controllerlogin.text, _controllersenha.text) == null){
                        _salvarDados(_controllerlogin.text, _controllersenha.text);
                        print("Conta registrada");  
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context){
                            return AlertDialog(
                              content: Text("Conta Criada!"),
                              actions: <Widget>[
                                RaisedButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    print("OK");
                                  }
                                )
                              ],
                            );
                          },
                        );                     
                      }
                      else {
                        print("Login ou senha não podem ficar vazios");
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context){
                            return AlertDialog(
                              content: Text("Login ou senha não podem ficar vazios"),
                              actions: <Widget>[
                                RaisedButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    print("OK");
                                  }
                                )
                              ],
                            );
                          },
                        );  
                      }
                    }
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }

  menuLogado(BuildContext context){
    TextEditingController _controllernome = TextEditingController();
    TextEditingController _controllerpreco = TextEditingController();
    TextEditingController _controllervalidade = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Controle de Contas Mensal"),
        centerTitle: true,
        actions: <Widget>[
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          children: <Widget>[
            _img ('assets/images/logado.png'),
            TextField(
              decoration: InputDecoration(
                labelText: "Digite o nome: ",
              ),
              controller: _controllernome,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Digite o preco: ",
              ),
              controller: _controllerpreco,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Digite a validade: ",
              ),
              controller: _controllervalidade,
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    child: Text("Inserir"),
                    onPressed: () async{
                      if (isEmpty(_controllernome.text, _controllerpreco.text, _controllervalidade.text)){
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context){
                            return AlertDialog(
                              content: Text("Preencha todos os campos!"),
                              actions: <Widget>[
                                RaisedButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    print("OK");
                                  }
                                )
                              ],
                            );
                          },
                        );   
                      }
                      else {
                        await _salvarDadosConta(_controllernome.text, _controllerpreco.text, _controllervalidade.text);
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context){
                              return AlertDialog(
                                content: Text("Conta Inserida"),
                                actions: <Widget>[
                                  RaisedButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      print("OK");
                                    }
                                  )
                                ],
                              );
                            },
                          );
                      }
                    }
                ),
                ElevatedButton(
                    child: Text("Deletar"),
                    onPressed: () async {
                      await _excluirConta(_controllernome.text, _controllerpreco.text, _controllervalidade.text);
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context){
                            return AlertDialog(
                              content: Text("Conta com esses dados deletada"),
                              actions: <Widget>[
                                RaisedButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    print("OK");
                                  }
                                )
                              ],
                            );
                          },
                        );
                    }
                ),
                ElevatedButton(
                    child: Text("Editar"),
                    onPressed: (){
                      if (isEmpty(_controllernome.text, _controllerpreco.text, _controllervalidade.text)){
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context){
                            return AlertDialog(
                              content: Text("Preencha todos os campos!"),
                              actions: <Widget>[
                                RaisedButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    print("OK");
                                  }
                                )
                              ],
                            );
                          },
                        );   
                      }
                      else{
                        print("-> Menu Editar");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => menuEditar(_controllernome.text, _controllerpreco.text, _controllervalidade.text, context)
                          ),
                        );
                      }
                    }
                ),
                /*ElevatedButton(
                    child: Text("Listar Contas"),
                    onPressed: (){
                      setState(() {
                      _listarContas();
                    });
                    }
                ),
                */
                listarButton(context),
              ],
            ),
                    //_textInfo(),
          ],
        ),
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controllerlogin = TextEditingController();
    TextEditingController _controllersenha = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Controle de Contas Mensal"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _img ('assets/images/list.png'),
            TextField(
              decoration: InputDecoration(
                labelText: "Digite o login: ",
              ),
              controller: _controllerlogin,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Digite a senha: ",
              ),
              obscureText: true,
              controller: _controllersenha,
            ),
            SizedBox(height: 20,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    child: Text("Logar"),
                    onPressed: () async{
                      await _validate(_controllerlogin.text, _controllersenha.text);
                      print("validado na main $validado");
                      if(validado == 1){
                        print("-> Menu Logado");
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => menuLogado(context)
                            ),
                          );
                    });       
                      }

                      else{
                        print("Conta não existe");
                      }
                    }
                ),
                ElevatedButton(
                    child: Text("Registrar"),
                    onPressed: (){
                      setState(() {
                      print("-> Menu Registro");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => menuRegistro(context)
                            ),
                          );
                    });
                    }
                ),
               /* ElevatedButton(
                    child: Text("Listar Usuarios"),
                    onPressed: (){
                      _listarUsuarios();
                    }
                ),*/
              ],
            ),
          ],
        ),
      ),
    );
  }
}