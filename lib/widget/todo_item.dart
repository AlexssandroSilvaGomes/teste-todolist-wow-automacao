import 'package:flutter/material.dart';
import 'package:todolist_wowautomacao/model/todo.dart';

class TodoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoChanged;
  final onDeleteItem;

  const TodoItem(
      {super.key,
      required this.todo,
      required this.onToDoChanged,
      required this.onDeleteItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        onTap: () {
          onToDoChanged(todo);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Colors.white,
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank_rounded,
          color: Colors.blue,
        ),
        title: Text(
          todo.todoText!,
          style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              decoration: todo.isDone ? TextDecoration.lineThrough : null),
        ),
        subtitle: Text(
          todo.todoDesc!,
          style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              decoration: todo.isDone ? TextDecoration.lineThrough : null),
        ),
        trailing: IconButton(
            onPressed: () {
              onDeleteItem(todo.id);
            },
            color: Colors.red,
            iconSize: 28,
            icon: Icon(Icons.delete)),
      ),
    );
  }
}
