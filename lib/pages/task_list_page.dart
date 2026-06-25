import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:my_life_assistant/models/app_state_model.dart';
import 'package:my_life_assistant/models/task_model.dart';
import 'package:my_life_assistant/pages/task_detail_page.dart';
import 'package:my_life_assistant/widgets/custom_drawer.dart';
import 'package:my_life_assistant/widgets/custom_button.dart';
import 'package:intl/intl.dart';


class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String _searchKeyword = '';
  bool? _filterCompleted; // null: 显示全部, true: 已完成, false: 未完成
  String _sortBy = 'createdAt'; // 'createdAt', 'dueDate', 'priority'

  String _timeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 365) return '${(difference.inDays / 365).floor()}年前';
    if (difference.inDays > 30) return '${(difference.inDays / 30).floor()}月前';
    if (difference.inDays > 0) return '${difference.inDays}天前';
    if (difference.inHours > 0) return '${difference.inHours}小时前';
    if (difference.inMinutes > 0) return '${difference.inMinutes}分钟前';
    return '刚刚';
  }

  // 用于显示搜索结果/排序后的列表
  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    DateTime? dueDate;
    String priority = 'medium';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('新增任务'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: '任务标题'),
                ),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(labelText: '描述'),
                ),
                ListTile(
                  title: Text('截止日期'),
                  trailing: Text(
                    dueDate != null ? DateFormat('yyyy-MM-dd').format(dueDate!) : '未设置',
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      dueDate = picked;
                      // 刷新对话框（简单处理：关闭重新打开）
                    }
                  },
                ),
                DropdownButtonFormField<String>(
                  value: priority,
                  items: ['high', 'medium', 'low'].map((p) {
                    return DropdownMenuItem(value: p, child: Text(p));
                  }).toList(),
                  onChanged: (val) => priority = val!,
                  decoration: InputDecoration(labelText: '优先级'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('取消')),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final model = ScopedModel.of<AppStateModel>(context, rebuildOnChange: false);
                  model.addTask(
                    titleController.text,
                    description: descController.text,
                    dueDate: dueDate,
                    priority: priority,
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('任务已添加')),
                  );
                }
              },
              child: Text('添加'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('任务列表'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddTaskDialog(context),
          ),
        ],
      ),
      drawer: CustomDrawer(scaffoldContext: context),
      body: ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          // 每次数据变化时更新显示列表
          List<Task> displayTasks = model.tasks;
          if (_searchKeyword.isNotEmpty) {
            displayTasks = model.searchTasks(_searchKeyword);
          }
          if (_filterCompleted != null) {
            displayTasks = displayTasks.where((t) => t.isCompleted == _filterCompleted).toList();
          }
          return Column(
            children: [
              // 搜索、筛选、排序工具栏
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: '搜索任务...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                        onChanged: (value) {
                          _searchKeyword = value;
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: () {
                        // 显示筛选选项
                        showModalBottomSheet(
                          context: context,
                          builder: (ctx) {
                            return StatefulBuilder(
                              builder: (ctx, setStateSheet) {
                                return Container(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('筛选状态', style: TextStyle(fontSize: 18)),
                                      RadioListTile<bool?>(
                                        title: Text('全部'),
                                        value: null,
                                        groupValue: _filterCompleted,
                                        onChanged: (val) {
                                          setStateSheet(() {
                                            _filterCompleted = val;
                                          });
                                          Navigator.pop(ctx);
                                        },
                                      ),
                                      RadioListTile<bool?>(
                                        title: Text('已完成'),
                                        value: true,
                                        groupValue: _filterCompleted,
                                        onChanged: (val) {
                                          setStateSheet(() {
                                            _filterCompleted = val;
                                          });
                                          Navigator.pop(ctx);
                                        },
                                      ),
                                      RadioListTile<bool?>(
                                        title: Text('未完成'),
                                        value: false,
                                        groupValue: _filterCompleted,
                                        onChanged: (val) {
                                          setStateSheet(() {
                                            _filterCompleted = val;
                                          });
                                          Navigator.pop(ctx);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.sort),
                      onSelected: (value) {
                        _sortBy = value;
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem(value: 'createdAt', child: Text('按创建时间')),
                        PopupMenuItem(value: 'dueDate', child: Text('按截止日期')),
                        PopupMenuItem(value: 'priority', child: Text('按优先级')),
                      ],
                    ),
                  ],
                ),
              ),
              // 任务列表
              Expanded(
                child: displayTasks.isEmpty
                    ? Center(child: Text('暂无任务'))
                    : ListView.builder(
                  itemCount: displayTasks.length,
                  itemBuilder: (ctx, index) {
                    final task = displayTasks[index];
                    return Dismissible(
                      key: Key(task.id),
                      background: Container(color: Colors.red, alignment: Alignment.centerRight, child: Icon(Icons.delete, color: Colors.white)),
                      onDismissed: (direction) {
                        model.deleteTask(task.id);
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          SnackBar(content: Text('已删除: ${task.title}')),
                        );
                      },
                      child: ListTile(
                        leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (_) {
                            model.toggleCompleted(task.id);
                          },
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Text(
                          '${task.description} · ${_timeAgo(task.createdAt)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              task.priority == 'high' ? Icons.flag : (task.priority == 'medium' ? Icons.flag_outlined : Icons.flag),
                              color: task.priority == 'high' ? Colors.red : (task.priority == 'medium' ? Colors.orange : Colors.grey),
                            ),
                            SizedBox(width: 8),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _showEditTaskDialog(ctx, task, model),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Hero 动画跳转到详情
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TaskDetailPage(task: task),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task, AppStateModel model) {
    final titleController = TextEditingController(text: task.title);
    final descController = TextEditingController(text: task.description);
    String priority = task.priority;
    DateTime? dueDate = task.dueDate;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('编辑任务'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: '标题'),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: '描述'),
              ),
              ListTile(
                title: Text('截止日期'),
                trailing: Text(dueDate != null ? DateFormat('yyyy-MM-dd HH:mm').format(task.createdAt) : '未设置'),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: dueDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    dueDate = picked;
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: priority,
                items: ['high', 'medium', 'low'].map((p) {
                  return DropdownMenuItem(value: p, child: Text(p));
                }).toList(),
                onChanged: (val) => priority = val!,
                decoration: InputDecoration(labelText: '优先级'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('取消')),
            ElevatedButton(
              onPressed: () {
                final updatedTask = Task(
                  id: task.id,
                  title: titleController.text,
                  description: descController.text,
                  isCompleted: task.isCompleted,
                  createdAt: task.createdAt,
                  dueDate: dueDate,
                  priority: priority,
                );
                model.updateTask(updatedTask);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content: Text('任务已更新')),
                );
              },
              child: Text('保存'),
            ),
          ],
        );
      },
    );
  }
}