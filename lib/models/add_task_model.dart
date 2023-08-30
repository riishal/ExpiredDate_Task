AddTaskModel addTaskModelFromJson(Map<String, dynamic> str) =>
    AddTaskModel.fromMap(str);

Map<String, dynamic> addTaskModelToJson(AddTaskModel data) => data.toMap();

class AddTaskModel {
  String uid;
  String title;
  DateTime startDate;
  DateTime expiredDate;
  String tenMinutes;
  String oneDayBefore;
  String taskState;

  AddTaskModel({
    required this.uid,
    required this.title,
    required this.startDate,
    required this.expiredDate,
    required this.tenMinutes,
    required this.oneDayBefore,
    required this.taskState,
  });

  factory AddTaskModel.fromMap(Map<String, dynamic> json) => AddTaskModel(
        title: json["title"],
        uid: json["uid"],
        startDate: json["start_date"].toDate(),
        expiredDate: json["expired_date"].toDate(),
        tenMinutes: json["ten_minutes"],
        oneDayBefore: json["one_day_before"],
        taskState: json["task_state"],
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "uid": uid,
        "start_date": startDate,
        "expired_date": expiredDate,
        "ten_minutes": tenMinutes,
        "one_day_before": oneDayBefore,
        "task_state": taskState,
      };
}
