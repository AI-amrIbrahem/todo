import 'package:flutter/material.dart';
import 'package:todo/logic_state/home_cubit/home_cubit.dart';
import 'package:todo/models/task_model.dart';

Widget getItemTaskList(List<TaskModel> list,int index, HomeCubit homeCubit){
  return Dismissible(
    key: Key('${list[index].id}'),
    onDismissed: (direction) {
      homeCubit.deletTask(list[index].id);
    },
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
                list[index].time
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(list[index].title,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                ),
                Text(list[index].date,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          IconButton(onPressed: (){
            homeCubit.changeStatus("done",list[index].id);
          }, icon: Icon(Icons.check_circle_outline,color: Colors.green,)),
          IconButton(onPressed: (){
            homeCubit.changeStatus("archieved",list[index].id);
          }, icon: Icon(Icons.archive_outlined,color: Colors.grey)),
        ],
      ),
    ),
  );
}