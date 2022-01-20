import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/logic_state/home_cubit/home_cubit.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/widgets/item_list_task_widget.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => current is closeBotttom || current is statusChange ,
      builder: (context, state) {
        return FutureBuilder(future: HomeCubit.get(context).getAllTasks("done"),
          builder: (context, AsyncSnapshot<List<TaskModel>> snapshot) {
            if (snapshot.data != null) {
              return ListView.separated(itemBuilder: (context, index) {
                return getItemTaskList(snapshot.data!, index,HomeCubit.get(context));
              },
                  separatorBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey,
                    );
                  },
                  itemCount: snapshot.data!.length);
            } else {
              return CircularProgressIndicator();
            }
          },);
      },
    );
  }
}
