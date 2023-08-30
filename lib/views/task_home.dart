import 'package:app_task/core/constants.dart';
import 'package:app_task/providers/task_home_provider.dart';
import 'package:app_task/views/add_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskHome extends StatefulWidget {
  const TaskHome({super.key});

  @override
  State<TaskHome> createState() => _TaskHomeState();
}

class _TaskHomeState extends State<TaskHome>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late TaskHomeProvider taskHomeProvider;
  List taskList = [];
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    taskHomeProvider = Provider.of<TaskHomeProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tasks'),
        backgroundColor: Colors.purple.shade100,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const AddTask()));
        },
        backgroundColor: Colors.purple.shade100,
        child: const Icon(Icons.add),
      ),
      body: Column(children: [
        TabBar(
          controller: tabController,
          labelColor: Colors.purple,
          unselectedLabelColor: Colors.purple.shade200,
          indicatorColor: Colors.purple,
          indicatorSize: TabBarIndicatorSize.tab,
          labelPadding: const EdgeInsets.symmetric(vertical: 8),
          tabs: const [Text('Upcoming'), Text('Renewed'), Text('Expired')],
        ),
        Expanded(
          child: TabBarView(controller: tabController, children: [
            taskTabContainer('upcoming', TaskState.upcoming),
            taskTabContainer('renewed', TaskState.renewed),
            taskTabContainer('upcoming', TaskState.expired)
          ]),
        ),
      ]),
    );
  }

  Widget taskTabContainer(String state, TaskState taskState) =>
      Consumer<TaskHomeProvider>(builder: (context, provider, child) {
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(taskDb)
                .where("task_state", isEqualTo: state)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                taskHomeProvider.checkTaskConditions(
                    snapshot.data!.docs, taskState);
                return ListView.builder(
                    itemCount: taskHomeProvider.taskList.length,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot<Map<String, dynamic>> task =
                          taskHomeProvider.taskList[index];
                      return SizedBox(
                        height: 100,
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 19),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      task['title'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    taskState != TaskState.expired
                                        ? Switch(
                                            value: taskHomeProvider
                                                        .selectedIndex ==
                                                    index
                                                ? taskHomeProvider.switchState
                                                : false,
                                            onChanged: (value) {
                                              taskHomeProvider
                                                  .onChangedSwitchState(index,
                                                      value, task, state);
                                            })
                                        : Container(),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Date: ${DateFormat.yMMMd().format(task['start_date'].toDate())}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      'Exp.Date: ${DateFormat.yMMMd().format(task['expired_date'].toDate())}',
                                      style: TextStyle(
                                        color: Colors.red.shade400,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
      });
}
