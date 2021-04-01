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
    
    return CheckboxListTile(
      title: Text(item["title"]),
      value: item["ok"],
      secondary: CircleAvatar(
        child: Icon(item["ok"] ? Icons.check : Icons.error)
      ),
      onChanged: (ok) {
        setState(() {
          item["ok"] = ok;          
        });
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