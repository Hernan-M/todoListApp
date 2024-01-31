class Todo{

  Todo({required this.title, required this.dateTask});

  String title;
  DateTime dateTask;

  Todo.fromJson(Map<String, dynamic> json) : title = json['title'], dateTask = DateTime.parse(json['dateTask']);

  Map <String, dynamic>toJson(){
    return{
      'title': title,
      'dateTime': dateTask.toIso8601String(),
    };
  }
}