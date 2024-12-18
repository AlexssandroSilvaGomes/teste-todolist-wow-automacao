import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ToDo {
  String? id;
  String? todoText;
  String? todoDesc;
  late bool isDone;

  ToDo({required this.id, required this.todoText, required this.todoDesc, this.isDone = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todoText': todoText,
      'todoDesc': todoDesc,
      'isDone': isDone,
    };
  }

  factory ToDo.fromMap(Map<String, dynamic> map) {
    return ToDo(
      id: map['id'],
      todoText: map['todoText'],
      todoDesc: map['todoDesc'],
      isDone: map['isDone'],
    );
  }

  static Future<void> saveToDoList(List<ToDo> todoList) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> todoListJson = todoList.map((todo) => jsonEncode(todo.toMap())).toList();
    prefs.setStringList('todoList', todoListJson);
  }

  static Future<List<ToDo>> getToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? todoListJson = prefs.getStringList('todoList');

    if (todoListJson != null) {
      return todoListJson
          .map((todoJson) => ToDo.fromMap(jsonDecode(todoJson)))
          .toList();
    }
    return []; 
  }
}
