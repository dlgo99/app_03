import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'PaginaListaDeCompras.dart';

class PaginaLogin extends StatefulWidget {
  @override
  _PaginaLoginState createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  TextEditingController _controllerLogin = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Compras"),
      ),
      body: Form( //consegue armazenar o estado dos campos de texto e além disso, fazer a validação
        key: _formKey, //estado do formulário
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  labelText: "Login:",
                  hintText: "Digite o login"
              ),
              controller: _controllerLogin,
              validator: (String text){
                if(text.isEmpty){
                  return "Digite o texto";
                }
                return null;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  labelText: "Senha:",
                  hintText: "Digite a senha"
              ),
              obscureText: true,
              controller: _controllerSenha,
              validator: (String text){
                if(text.isEmpty){
                  return "Digite a senha ";
                }
                if(text.length < 4){
                  return "A senha tem pelo menos 4 dígitos";
                }
                return null;
              },
            ),
            SizedBox(height: 20,),
            Container(
              height: 46,
              child: ElevatedButton(
                  child: Text("Login",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),),
                  onPressed: (){
                    bool formOk = _formKey.currentState.validate();
                    if(! formOk){
                      return;
                    }
                    else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaginaListaDeCompras()
                        ),
                      );
                    }
                    print("Login "+_controllerLogin.text);
                    print("Senha "+_controllerSenha.text);
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
