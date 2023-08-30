import 'package:app_task/models/add_task_model.dart';
import 'package:app_task/services/add_task_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../core/constants.dart';

class TaskHomeProvider extends ChangeNotifier {
  AddTaskService addTaskService = AddTaskService();
  int selectedIndex = 0;
  bool switchState = false;
  List taskList = [];

  String changeTaskState(String taskState) {
    switchState = false;
    if (taskState == 'upcoming') return 'renewed';
    if (taskState == 'renewed') return 'upcoming';
    return '';
  }

  checkTaskConditions(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshots,
    TaskState taskState,
  ) {
    if (taskState == TaskState.upcoming) {
      taskList = snapshots.where((element) {
        DateTime startDate = element['expired_date'].toDate();
        return startDate.isAfter(DateTime.now());
      }).toList();
      print('///////////////// upcoming tasks: ${taskList.length}');
    } else if (taskState == TaskState.renewed) {
      taskList = snapshots;
      print('///////////////// renewed tasks: ${taskList.length}');
    } else if (taskState == TaskState.expired) {
      taskList = snapshots.where((element) {
        DateTime expiredDate = element['expired_date'].toDate();
        return expiredDate.isBefore(DateTime.now());
      }).toList();
      print('///////////////// expired tasks: ${taskList.length}');
    }
  }

  onChangedSwitchState(int index, bool value,
      QueryDocumentSnapshot<Map<String, dynamic>> task, String taskState) {
    print('///// index $index, $value');

    selectedIndex = index;
    switchState = value;
    var newTaskState = changeTaskState(taskState);
    print('//// taskStateON.: $newTaskState');
    Map<String, dynamic> taskMap = task.data();
    AddTaskModel taskModel = addTaskModelFromJson(taskMap);
    addTaskService.updateTask(taskModel, newTaskState);

    notifyListeners();
  }
}
