import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/moduls/archieved_tasks/archieved_tasks_screen.dart';
import 'package:todo/moduls/done_tasks/done_tasks_screen.dart';
import 'package:todo/moduls/new_tasks/new_tasks_screen.dart';
import 'package:todo/shared/db_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {

  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of<HomeCubit>(context);

  var currentIndex=0;

  var isShowBottom= false;

  void bottomShow(){
    if (isShowBottom== false) {
      isShowBottom= true;
      emit(showBottom());
    } else {
      isShowBottom= false;
      emit(closeBotttom());
    }
  }

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchievedTasksScreen(),
  ];

  List<String> titles = [
    "New Tasks",
    "Done Tasks",
    "Archieved Tasks"
  ];

  void changeBottomIndex(index){
    currentIndex = index;
    if (index==0)
    emit(ChangeIndexState0());
    else if (index==1)
      emit(ChangeIndexState1());
    else if (index==2)
      emit(ChangeIndexState2());
  }

  getCurrenScreen() {
    return screens[currentIndex];
  }

  getTitle() {
    return titles[currentIndex];
  }

  DbHelper db = DbHelper();

  Future<List<TaskModel>> getAllTasks(String status)async{
    db.getAllTasks().then((value) {
      print (TaskModel.fromMapWhereStatus(value,status));
    });
    return TaskModel.fromMapWhereStatus(await db.getAllTasks(),status);
  }

  void changeStatus(String status,int id){
    db.updateTask(id: id, status: status).then((value){
      emit(statusChange());
    });
  }

  void deletTask(int id){
    db.deleteTask(id: id).then((value){
      emit(statusChange());
    });
  }

}
