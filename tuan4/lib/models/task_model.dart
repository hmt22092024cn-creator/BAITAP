class SubTask {
  final String title;
  bool done;

  SubTask({required this.title, required this.done});

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      title: json['title'] ?? '',
      done: json['done'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'done': done,
    };
  }
}

class TaskModel {
  final int id;
  final String title;
  final String note;
  final String category;
  final String date;
  final String time;
  final String priority;
  final bool remind;
  bool done;
  final List<SubTask> subtasks;

  TaskModel({
    required this.id,
    required this.title,
    required this.note,
    required this.category,
    required this.date,
    required this.time,
    required this.priority,
    required this.remind,
    required this.done,
    required this.subtasks,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    var subtasksList = (json['subtasks'] as List?)
            ?.map((item) => SubTask.fromJson(item))
            .toList() ??
        [];

    return TaskModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      note: json['note'] ?? '',
      category: json['category'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      priority: json['priority'] ?? 'medium',
      remind: json['remind'] ?? false,
      done: json['done'] ?? false,
      subtasks: subtasksList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'category': category,
      'date': date,
      'time': time,
      'priority': priority,
      'remind': remind,
      'done': done,
      'subtasks': subtasks.map((s) => s.toJson()).toList(),
    };
  }
}
