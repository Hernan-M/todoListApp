import 'package:esquece_nao/models/todo.dart';
import 'package:esquece_nao/repositories/todo_repository.dart';
import 'package:esquece_nao/widgets/todo_list_item.dart';
import 'package:flutter/material.dart';


class TodoListPage extends StatefulWidget {
  TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController task = TextEditingController();

  final TodoRepository todoRepository = TodoRepository();

  List<Todo> tasks = [];
  int tasksQtd = 0;

  @override
  void initState(){
    super.initState();

    todoRepository.getTodoList().then((value) => (
      setState(() {
        tasks = value;
      })
    ));
  }

  void addTask() {
    DateTime createdAt = DateTime.now();
    String text = task.text;
    if(text != '' && createdAt != null) {
      setState(() {
        Todo newTask = Todo(title: text, dateTask: createdAt);
        tasks.add(newTask);
        tasksQtd = tasks.length;
        task.clear();
        todoRepository.saveTodoList(tasks);
      });
    }else{
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Insira uma tarefa válida',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey[50],
        duration: const Duration(seconds: 2),
      ));
    }
  }

  void clearAll() {
    setState(() {
      tasks.clear();
      tasksQtd = 0;
    });
    todoRepository.saveTodoList(tasks);
  }

  void showDeleteConfirmDialog(){
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Limpar tudo?'),
      content: Text('Tem certeza que deseja apagar todas as tarefas?'),
      actions: [
        TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text('Cancelar')),
        TextButton(onPressed: (){
          clearAll();
          Navigator.of(context).pop();
          }, child: Text('Confirmar', style: TextStyle(color: Colors.red),))
      ],
    ));
  }

  void onDelete(Todo todo) {
    int deletedTodoPos = tasks.indexOf(todo);

    setState(() {
      tasks.remove(todo);
    });
    todoRepository.saveTodoList(tasks);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'A tarefa ${todo.title} foi removida com sucesso!',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.grey[50],
      action: SnackBarAction(
          textColor: Color(0xff00d7f3),
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              tasks.insert(deletedTodoPos, todo);
            });
            todoRepository.saveTodoList(tasks);
          }),
      duration: const Duration(seconds: 3),
    ));

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Lista de Tarefas',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: task,
                        decoration: InputDecoration(
                          labelText: 'Adicione uma tarefa',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff00d7f3),
                        padding: EdgeInsets.all(16),
                      ),
                      onPressed: addTask,
                      child: Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in tasks)
                        TodoListItem(task: todo, onDelete: onDelete)
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Você possui $tasksQtd tarefas pendentes',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepOrange[400],
                        padding: EdgeInsets.all(16),
                      ),
                      onPressed: showDeleteConfirmDialog,
                      child: Text(
                        'Limpar tudo',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
