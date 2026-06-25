import 'package:flutter/material.dart';
import 'package:my_life_assistant/models/task_model.dart';
import 'package:my_life_assistant/widgets/custom_button.dart';
import 'package:intl/intl.dart';


class TaskDetailPage extends StatelessWidget {
  final Task task;

  const TaskDetailPage({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('任务详情'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero 动画共享标题
            Hero(
              tag: 'task_${task.id}',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  task.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text('描述: ${task.description}'),
            SizedBox(height: 8),
            Text('状态: ${task.isCompleted ? "已完成" : "未完成"}'),
            SizedBox(height: 8),
            Text('优先级: ${task.priority}'),
            SizedBox(height: 8),
            Text('创建时间: ${DateFormat('yyyy-MM-dd HH:mm').format(task.createdAt)}'),
            if (task.dueDate != null) Text('截止日期: ${DateFormat('yyyy-MM-dd').format(task.dueDate!)}'),
            Spacer(),
            CustomButton(
              label: '返回',
              icon: Icons.arrow_back,
              onPressed: () => Navigator.pop(context),
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}