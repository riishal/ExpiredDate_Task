import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:uuid/uuid.dart';

import '../core/constants.dart';
import '../models/add_task_model.dart';

class AddTaskService {
  final db = FirebaseFirestore.instance;
  addTask(
      {String? title,
      String? uid,
      String? tenMinutes,
      String? oneDayBefore,
      String? taskState,
      DateTime? startDate,
      DateTime? expiredDate}) async {
    String uid = const Uuid().v1();
    AddTaskModel addTaskModel = AddTaskModel(
        title: title!,
        uid: uid,
        startDate: startDate!,
        expiredDate: expiredDate!,
        tenMinutes: tenMinutes!,
        oneDayBefore: oneDayBefore!,
        taskState: taskState!);
    await FirebaseFirestore.instance
        .collection(taskDb)
        .doc(uid)
        .set(addTaskModelToJson(addTaskModel))
        .then((value) async {
      Fluttertoast.showToast(
          msg: 'Task added successfully',
          backgroundColor: Colors.purple,
          textColor: Colors.white);
      print('////////////////// successful');
    }).catchError((err) {
      Fluttertoast.showToast(
          msg: 'Could not add your Task',
          backgroundColor: Colors.purple,
          textColor: Colors.white);
      print('Error occured: $err');
    });
  }

  updateTask(AddTaskModel taskModel, String taskState) async {
    taskModel.taskState = taskState;
    print('//// taskState: $taskState');
    await FirebaseFirestore.instance
        .collection(taskDb)
        .doc(taskModel.uid)
        .set(addTaskModelToJson(taskModel))
        .then((value) async {
      Fluttertoast.showToast(
          msg: 'Task updated successfully',
          backgroundColor: Colors.purple,
          textColor: Colors.white);
      print('////////////////// successful');
    }).catchError((err) {
      Fluttertoast.showToast(
          msg: 'Could not update task',
          backgroundColor: Colors.purple,
          textColor: Colors.white);
      print('Error occured: $err');
    });
  }
}
