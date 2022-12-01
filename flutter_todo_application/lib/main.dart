import 'dart:ffi';

import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(backgroundColor: Colors.black),
        scaffoldBackgroundColor: Color.fromARGB(255, 22, 22, 22),
      ),
      debugShowCheckedModeBanner: false,
      home: const TodoList(title: 'Todolist'),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key, required this.title});
  final String title;

  @override
  State<TodoList> createState() => _TodoListState();
}

class Todo {
  Todo({required this.todoTitle, this.checked = false});
  final String todoTitle;
  bool checked = false;
}

class _TodoListState extends State<TodoList> {
  final List<Todo> _todos = <Todo>[];
  final TextEditingController _addTodoField = TextEditingController();

  void _addTodo(String todo) {
    setState(() {
      _todos.add(Todo(todoTitle: todo));
    });
    _addTodoField.clear();
  }

  void _deleteTodo(Todo removeTodo) {
    setState(() {
      _todos.removeWhere((todo) => todo.todoTitle == removeTodo.todoTitle);
    });
  }

  Widget _buildTodoItem(Todo todo) {
    return ListTile(
      title: Text(todo.todoTitle,
          style: TextStyle(
              decoration: todo.checked
                  ? TextDecoration.lineThrough
                  : TextDecoration.none)),
      leading: Checkbox(
        activeColor: Colors.orange.shade800,
        value: todo.checked,
        onChanged: (bool? newValue) {
          setState(() {
            todo.checked = newValue ?? false;
          });
        },
      ),
      trailing: TextButton(
        onPressed: () => _deleteTodo(todo),
        child: Icon(Icons.remove_circle),
        style: TextButton.styleFrom(foregroundColor: Colors.red),
      ),
    );
  }

  Future<void> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 22, 22, 22),
            title: const Text("Add todo"),
            content: TextField(
              controller: _addTodoField,
              decoration: const InputDecoration(hintText: "Buy milk"),
            ),
            actions: <Widget>[
              TextButton(
                child:
                    const Text("Cancel", style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: const Text("Add todo"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  _addTodo(_addTodoField.text);
                },
              ),
            ],
          );
        });
  }

  List<Widget> _getItems() {
    final List<Widget> _todoWidgets = <Widget>[];
    for (Todo todo in _todos) {
      _todoWidgets.add(_buildTodoItem(todo));
    }
    return _todoWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(children: _getItems()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context),
        tooltip: "Add todo",
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.orange.shade800,
      ),
    );
  }
}
