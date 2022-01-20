import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task_model.dart';

class DbHelper{
  final  _dbName="todoDB";
  final  vesionDB = 1;
  final tableName = "tasks";
  DbHelper.internal();
  static final instance = DbHelper.internal();
  factory DbHelper()=> instance;
  static Database? _db;
  createDataBase()async{
    _db = await openDatabase(_dbName,version: vesionDB,onCreate: (database,version)async{
        await database.execute("create table $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,date TEXT,time TEXT,status TEXT)");
    });
    return _db;
  }

  Future insertToTasks(TaskModel task)async{
    if (_db==null){
      await createDataBase();
    }
    return await _db!.insert(tableName, task.toMap);
  }

  Future<List<Map<String,dynamic>>> getAllTasks()async{
    if (_db==null){
      await createDataBase();
    }
    return _db!.query(tableName);
  }

  Future<int> updateTask({required int id, required String status})async{
    if (_db==null){
      await createDataBase();
    }
    return _db!.rawUpdate("update $tableName set status = ?  where id = ?",[status,id]);
  }


  Future<int> deleteTask({required int id})async{
    if (_db==null){
      await createDataBase();
    }
    return _db!.rawDelete("delete from $tableName  where id = ?",[id]);
  }

}