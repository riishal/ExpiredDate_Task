import 'package:app_task/providers/task_home_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';

class ViewScreen extends StatelessWidget {
  const ViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskHomeProvider>(builder: (context, getdata, child) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.purple.shade100,
            title: Text('View'),
          ),
          body: StreamBuilder(
              stream: FirebaseFirestore.instance.collection(taskDb).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot<Map<String, dynamic>> task =
                            snapshot.data!.docs[index];
                        DateTime taskDate =
                            (task['start_date'] as Timestamp).toDate();
                        DateTime expiredDate =
                            (task['expired_date'] as Timestamp).toDate();

                        return SizedBox(
                            height: 100,
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        task['title'],
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      //     task['task_state'] != 'expired'
                                      //         ? Switch(
                                      //             value: taskHomeProvider
                                      //                         .selectedIndex ==
                                      //                     index
                                      //                 ? taskHomeProvider.switchState
                                      //                 : false,
                                      //             onChanged: (value) {
                                      //               taskHomeProvider
                                      //                   .onChangedSwitchState(index,
                                      //                       value, task, taskState);
                                      //             })
                                      //         : Container(),
                                      //   ],
                                      // ),
                                      // task['task_state'] == 'expired'
                                      //     ? Column(
                                      //         children: [
                                      //           SizedBox(height: 30),
                                      //           Row(
                                      //             mainAxisAlignment:
                                      //                 MainAxisAlignment
                                      //                     .spaceBetween,
                                      //             children: [
                                      //               Text(
                                      //                 'Date: ${DateFormat('MMM dd, yyyy').format(taskDate)}',
                                      //                 style: TextStyle(
                                      //                     color: Color
                                      //                         .fromARGB(
                                      //                             255,
                                      //                             96,
                                      //                             96,
                                      //                             96),
                                      //                     fontSize: 12),
                                      //               ),
                                      //               Text(
                                      //                 'Expired',
                                      //                 style: TextStyle(
                                      //                     color:
                                      //                         Colors.red),
                                      //               ),
                                      //             ],
                                      //           ),
                                      //         ],
                                      //       )
                                      //     :

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Date: ${DateFormat('MMM dd, yyyy').format(taskDate)}',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 96, 96, 96),
                                                fontSize: 12),
                                          ),
                                          Text(
                                            'Exp.Date : ${DateFormat('MMM dd, yyyy').format(expiredDate)}',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 1,
                                      ),
                                    ]),
                              ),
                            ));
                      });
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }));
    });
  }
}
