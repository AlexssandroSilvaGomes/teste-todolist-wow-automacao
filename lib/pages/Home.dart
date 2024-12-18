import 'package:flutter/material.dart';
import 'package:todolist_wowautomacao/model/todo.dart';
import 'package:todolist_wowautomacao/widget/todo_item.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<ToDo>> _todoListFuture;
  List<ToDo> _foundToDo = [];
  final todoTitleController = TextEditingController();
  final todoDescController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _todoListFuture = ToDo.getToDoList(); 
  }

  void _loadToDoList() async {
    List<ToDo> todoList = await ToDo.getToDoList();
    setState(() {
      _foundToDo = todoList;  
    });
  }

  void _handleToDoChange(ToDo todo) async {
    for (var item in _foundToDo) {
      if (item.id == todo.id) {
        setState(() {
          item.isDone = !item.isDone;
        });
        break;
      }
    }

    List<ToDo> todoList = await ToDo.getToDoList();
    for (var item in todoList) {
      if (item.id == todo.id) {
        item.isDone = todo.isDone;
        break;
      }
    }

    ToDo.saveToDoList(todoList);
  }

  void _deleteToDoItem(String id) async {
    setState(() {
      _foundToDo.removeWhere((item) => item.id == id);
    });

    List<ToDo> todoList = await ToDo.getToDoList();
    todoList.removeWhere((item) => item.id == id);
    ToDo.saveToDoList(todoList);
  }

  void _addToDoItem(String todoTitle, String todoDesc) async {
    if (todoTitle.isNotEmpty) {
      List<ToDo> todoList = await ToDo.getToDoList();
      ToDo newToDo = ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: todoTitle,
        todoDesc: todoDesc,
      );

      setState(() {
        _foundToDo.add(newToDo);  
      });

      todoList.add(newToDo);  
      ToDo.saveToDoList(todoList);

      Navigator.of(context).pop();
    } else {
      final snackBar = SnackBar(
        content: Text('Por favor, insira um título para a tarefa!'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    todoTitleController.clear();
    todoDescController.clear();
  }

  void _showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: Text('Criar nova tarefa', style: TextStyle(color: Colors.blue),),
          content:
              Text('Dê um nome para a nova tarefa. A descrição é opcional!'),
          actions: <Widget>[
            TextField(
              controller: todoTitleController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Título da tarefa',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            TextField(
              controller: todoDescController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Descrição da tarefa',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Fechar',
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _addToDoItem(
                        todoTitleController.text,
                        todoDescController.text,
                      );
                    },
                    child: Text('Criar Tarefa', style: TextStyle(fontSize: 18, color: Colors.blue)),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text('Todo List', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),),
      ),
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          FutureBuilder<List<ToDo>>(
            future: _todoListFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erro ao carregar tarefas'));
              } else if (snapshot.hasData) {
                _foundToDo = snapshot.data!;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 50, bottom: 20),
                              child: Text(
                                'Todas as Tarefas',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            for (ToDo todoo in _foundToDo.reversed)
                              TodoItem(
                                todo: todoo,
                                onToDoChanged: _handleToDoChange,
                                onDeleteItem: _deleteToDoItem,
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(child: Text('Nenhuma tarefa encontrada.'));
              }
            },
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              onPressed: () {
                _showModal(context);
              },
              child: Icon(Icons.add, color: Colors.blue,),
            ),
          ),
        ],
      ),
    );
  }
}
