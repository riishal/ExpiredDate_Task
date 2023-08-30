import 'package:app_task/providers/add_task_provider.dart';
import 'package:app_task/views/task_home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  late AddTaskProvider addTaskProvider;

  @override
  void initState() {
    addTaskProvider = Provider.of<AddTaskProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple.shade100,
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Consumer<AddTaskProvider>(builder: (context, task, child) {
          return ListView(children: [
            TextField(
              controller: addTaskProvider.titleController,
              decoration: InputDecoration(
                  hintText: 'Enter Title',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(width: 1.5, color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(width: 1.5, color: Colors.grey))),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                // taskDate('Start Date', (value) {
                //   if (value == null) {
                //     return;
                //   }
                //   addTaskProvider.selectStartDate(value);
                // }, DateFormat.yMMMd().format(addTaskProvider.startInitialDate)),
                // const SizedBox(
                //   width: 5,
                // ),
                taskDate('Expired Date', (value) {
                  if (value == null) {
                    return;
                  }
                  addTaskProvider.selectExpiredDate(value);
                },
                    DateFormat.yMMMd()
                        .format(addTaskProvider.expiredInitialDate)),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            otherTaskFields('10 minutes', addTaskProvider.isTenMinutesChecked,
                (value) => addTaskProvider.onCheckedTenMinutes(value)),
            const SizedBox(
              height: 5,
            ),
            otherTaskFields(
                'One day before',
                addTaskProvider.isOneDayBeforeChecked,
                (value) => addTaskProvider.onCheckedOneDayBefore(value)),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    addTaskProvider.addTask();
                    Navigator.pop(context);
                    // Navigator.of(context).pushReplacement(
                    //     MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade300,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )),
            )
          ]);
        }),
      ),
    );
  }

  Widget otherTaskFields(String text, bool value, Function(bool?)? onChanged) =>
      Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Colors.grey),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Checkbox(
                activeColor: Colors.grey, value: value, onChanged: onChanged)
          ],
        ),
      );

  Widget taskDate(String text, Function(DateTime?) onValue, String date) =>
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: Row(children: [
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1990),
                          lastDate: DateTime(2100),
                          builder: (context, child) => Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: Colors.purple.shade300,
                                colorScheme: ColorScheme.light(
                                    primary: Colors.purple.shade300),
                                buttonTheme: const ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary),
                              ),
                              child: child!)).then(onValue);
                    },
                    icon: const Icon(
                      Icons.calendar_month,
                      size: 28,
                    ),
                    color: Colors.purple.shade300,
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    date,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ]),
            ),
          ],
        ),
      );
}
