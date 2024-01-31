import 'dart:convert';

import 'package:esquece_nao/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoRepository{

  late SharedPreferences sharedPreferences;

  String todoListKey = 'todo_list';

  saveTodoList(List<Todo> todos){
    final String jsonString =  json.encode(todos);
    sharedPreferences.setString('todo_list', jsonString);
  }
  
  
  Future<List<Todo>> getTodoList() async{
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Todo.fromJson(e)).toList();
  }

}