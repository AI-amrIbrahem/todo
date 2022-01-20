class TaskModel{
  int id;
  String title;
  String date;
  String time;
  String status;

  TaskModel({
    this.id=0,
    required this.title,
    required this.date,
    required this.time,
     this.status = "still",
  });

  Map<String, Object?> get toMap => {"title":title,"date":date,"time":time,"status":status};

  static List<TaskModel> fromMap(List<Map<String,dynamic>> s){
    return s.map((e) => TaskModel(title: e['title'], date: e['date'], time: e['time'],id: e['id'],status: e['status'])).toList();
  }

  static List<TaskModel> fromMapWhereStatus(List<Map<String,dynamic>> s,String status){
    List<TaskModel> x = [];
     s.map((e)async{
      if ( e['status'].toString() == status ){
         x.add( TaskModel(title: e['title'], date: e['date'], time: e['time'],id: e['id'],status: e['status']));
      }
    }).toString();
    return x;
  }

}