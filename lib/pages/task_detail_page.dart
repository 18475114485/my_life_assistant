import 'package:flutter/material.dart';
import 'package:my_life_assistant/models/task_model.dart';
import 'package:my_life_assistant/widgets/home_button.dart';
import 'package:intl/intl.dart';
import 'package:my_life_assistant/constants/my_icons.dart';


class TaskDetailPage extends StatelessWidget {
  final Task task;

  const TaskDetailPage({required this.task});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = Theme.of(context).cardColor;
    final statusColor = task.isCompleted ? Colors.green : Colors.orange;
    final statusBg = statusColor.withOpacity(0.15);

    return Scaffold(
      appBar: AppBar(
        title: const Text('任务详情'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: cardBg,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 网络图片
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://picsum.photos/seed/${task.id.hashCode}/200/200',
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 140,
                        height: 140,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // 内容
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 任务名（Hero 动画）
                            Expanded(
                              child: Hero(
                                tag: 'task_${task.id}',
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    task.title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // 状态标签
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                task.isCompleted ? '已完成' : '未完成',
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 描述
                            Expanded(
                              child: Text(
                                task.description.isNotEmpty
                                    ? task.description
                                    : '暂无描述',
                                style: const TextStyle(fontSize: 14),
                                softWrap: true,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // 优先级
                            Row(
                              children: [
                                Icon(
                                  _getPriorityIcon(task.priority),
                                  color: _getPriorityColor(task.priority),
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _getPriorityLabel(task.priority),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: _getPriorityColor(task.priority),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(height: 24, thickness: 1),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 创建时间
                            Text(
                              '创建: ${DateFormat('yyyy-MM-dd HH:mm').format(task.createdAt)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                            // 截止时间
                            if (task.dueDate != null)
                              Text(
                                '截止: ${DateFormat('yyyy-MM-dd').format(task.dueDate!)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                              )
                            else
                              Text(
                                '无截止日期',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // 首页按钮
      floatingActionButton: const BackToHomeButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // 优先级图标
  IconData _getPriorityIcon(String priority) {
    switch (priority) {
      case 'high':
        return MyIcons.flag;
      case 'medium':
        return MyIcons.flag;
      default:
        return MyIcons.flag;
    }
  }

  // 优先级颜色
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // 优先级显示
  String _getPriorityLabel(String priority) {
    switch (priority) {
      case 'high':
        return '高';
      case 'medium':
        return '中';
      default:
        return '低';
    }
  }
}