class Task {
  final String id;          // 唯一标识
  String title;
  String description;
  bool isCompleted;
  DateTime createdAt;
  DateTime? dueDate;        // 截止日期（可选）
  String priority;          // 'high', 'medium', 'low'

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
    this.dueDate,
    this.priority = 'medium',
  });

  // 转为 Map 用于存储
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'isCompleted': isCompleted,
    'createdAt': createdAt.toIso8601String(),
    'dueDate': dueDate?.toIso8601String(),
    'priority': priority,
  };

  // 从 Map 创建 Task
  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    description: json['description'] ?? '',
    isCompleted: json['isCompleted'] ?? false,
    createdAt: DateTime.parse(json['createdAt']),
    dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    priority: json['priority'] ?? 'medium',
  );
}