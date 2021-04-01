import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _toDoController = TextEditingController();
  var _toDoList = [];

  var _lastRemoved = {};
  var _lastRemovedPos = 0;

  void _addToDo() {
    setState(() {
      _toDoList.add({
        "title": _toDoController.text,
        "ok": false,
      });
    });
    _toDoController.text = "";
  }

  Widget _buildItem(context, index) {
    var item = _toDoList[index];
    
    return Dismissible(
      key: Key(index.toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 10.0),
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white)
      ),
      child: CheckboxListTile(
        title: Text(item["title"]),
        value: item["ok"],
        secondary: 
          CircleAvatar(child: Icon(item["ok"] ? Icons.check : Icons.error)),
        onChanged: (ok) {
          setState(() {
            item["ok"] = ok;          
          });
        },
      ),
      onDismissed: (direction) {
        //último removido
        _lastRemoved = Map.from(item);
        _lastRemovedPos = index;
        //remover
        _toDoList.remove(index);

        final snack = SnackBar(
          content: Text("Tarefa \"${_lastRemoved["title"]}\ removida!"),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: "Desfazer",
            onPressed: () {
              setState(() {
                _toDoList.insert(_lastRemovedPos, _lastRemoved);                
              });
            },
          ),
        );

        //limpar a pilha de SnackeBar
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        //mostrar SnackBar
        ScaffoldMessenger.of(context).showSnackBar(snack);
      },  
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Nova Tarefa",
                      labelStyle: TextStyle(color: Colors.blueAccent)
                    ),
                    controller: _toDoController,
                  )
                ),
                TextButton(
                  child: Text("ADD", style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent)
                  ),
                  onPressed: _addToDo,
                )
              ]
            )
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.0),
              itemCount: _toDoList.length,
              itemBuilder: _buildItem
            )
          )
        ],
      ));
  }
}