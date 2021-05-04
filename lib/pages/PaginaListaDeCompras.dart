import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class PaginaListaDeCompras extends StatefulWidget {
  @override
  _PaginaListaDeComprasState createState() => _PaginaListaDeComprasState();
}

class _PaginaListaDeComprasState extends State<PaginaListaDeCompras> {
  List _listaCompras = ["Pão", "Leite", "Manteiga"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Compras"),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked, //usar com o BottomNavigationBar
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightGreen,
          elevation: 6,
          child: Icon(Icons.add),
          //mini:true,
          //floatingActionButton: FloatingActionButton.extended(
          //icon: Icon(Icons.shopping_cart),
          //label: Text("Adicionar"),
          /*shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(6)
          ),*/
          onPressed: (){
            print("Botão pressionado!");
            showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: Text("Adicionar item: "),
                    content: TextField(
                      decoration: InputDecoration(
                          labelText: "Digite seu item"
                      ),
                      onChanged: (text){

                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: Text("Cancelar")
                      ),
                      TextButton(
                          onPressed: (){},
                          child: Text("Salvar")
                      ),
                    ],

                  );
                }
            );
          }
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: _listaCompras.length,
                itemBuilder: (context, index){
                  return ListTile(
                    title: Text(_listaCompras[index]),
                  );
                }
            ),
          ),
        ],
      ),


      /*bottomNavigationBar: BottomAppBar(
        //shape: CircularNotchedRectangle(),
        child: Row(
          children: <Widget>[
            IconButton(
                icon:Icon(Icons.add) ,
                onPressed: (){
                }
            ),
          ],
        ),

      ),*/
    );
  }
}
