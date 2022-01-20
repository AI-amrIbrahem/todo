import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/logic_state/home_cubit/home_cubit.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/resources/app_strings.dart';
import 'package:todo/shared/db_helper.dart';
import 'package:todo/widgets/input_text_widget.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var floatIcon = Icons.edit;

    var scaffoldKey = GlobalKey<ScaffoldState>();
    var formKey = GlobalKey<FormState>();
    var titlecontroller = TextEditingController();
    var timeController = TextEditingController();
    var dateController = TextEditingController();

    DbHelper dbHelper = DbHelper();

    return BlocProvider(
  create: (context) => HomeCubit(),
  child: BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) {
        if (previous.toString() != current.toString()){
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            title: Text(HomeCubit.get(context).getTitle()),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(floatIcon),
            onPressed: () {
              if (HomeCubit.get(context).isShowBottom && Navigator.canPop(context)) {
                if (formKey.currentState != null) {
                  if (formKey.currentState!.validate()) {
                    dbHelper
                        .insertToTasks(TaskModel(
                            title: titlecontroller.text.toString(),
                            date: dateController.text.toString(),
                            time: timeController.text.toString()))
                        .then((value) {
                      Navigator.pop(context);
                      floatIcon = Icons.edit;
                      HomeCubit.get(context).bottomShow();
                    });
                  }
                }
              } else {

                scaffoldKey.currentState!
                    .showBottomSheet((context) => Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    getTextFormField(
                                      prefIcon: Icons.title,
                                      labelText: AppStrings.taskTitle,
                                      controller: titlecontroller,
                                      myKeyboardtype: TextInputType.text,
                                      validFun: (value) {
                                        if (value.toString().isEmpty)
                                          return "empty !";
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    getTextFormField(
                                        prefIcon: Icons.timer,
                                        labelText: AppStrings.taskTime,
                                        controller: timeController,
                                        myKeyboardtype: TextInputType.datetime,
                                        validFun: (value) {
                                          if (value.toString().isEmpty)
                                            return "select first";
                                          return null;
                                        },
                                        onTap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) {
                                            if (value != null) {
                                              timeController.text = value
                                                  .format(context)
                                                  .toString();
                                            }
                                          });
                                        }),
                                    SizedBox(height: 10),
                                    getTextFormField(
                                      prefIcon: Icons.date_range,
                                      labelText: AppStrings.date,
                                      controller: dateController,
                                      myKeyboardtype: TextInputType.datetime,
                                      validFun: (value) {
                                        if (value.toString().isEmpty)
                                          return "select first";
                                        return null;
                                      },
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    '2023-05-03'))
                                            .then((value) {
                                          if (value != null) {
                                            dateController.text =
                                                "${value.year} ${value.month} ${value.day}";
                                            print(
                                                "${value.year} ${value.month} ${value.day}");
                                          }
                                        });
                                      },
                                    )
                                  ]),
                            ),
                          ),
                        )))
                    .closed
                    .then((_) {

                  floatIcon = Icons.edit;
                  HomeCubit.get(context).bottomShow();
                });
                floatIcon = Icons.add;
                HomeCubit.get(context).bottomShow();
              }
            },
          ),
          body: HomeCubit.get(context).getCurrenScreen(),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: HomeCubit.get(context).currentIndex,
            onTap: (index) {
              HomeCubit.get(context).changeBottomIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.add), label: AppStrings.tasks),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: AppStrings.done),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: AppStrings.archived),
            ],
          ),
        );
      },
    ),
);
  }
}
