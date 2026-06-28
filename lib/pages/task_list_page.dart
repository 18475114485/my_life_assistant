import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:my_life_assistant/pages/task_detail_page.dart';
import 'package:my_life_assistant/pages/home_page.dart';
import 'package:my_life_assistant/pages/profile_page.dart';
import 'package:my_life_assistant/pages/statistics_page.dart';
import 'package:my_life_assistant/models/app_state_model.dart';
import 'package:my_life_assistant/models/task_model.dart';
import 'package:my_life_assistant/widgets/custom_drawer.dart';
import 'package:my_life_assistant/widgets/custom_button.dart';
import 'package:my_life_assistant/widgets/nav_bar.dart';
import 'package:my_life_assistant/widgets/home_button.dart';
import 'package:intl/intl.dart';
import 'package:my_life_assistant/utils/navigation_utils.dart';
import 'package:my_life_assistant/constants/my_icons.dart';


class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _searchKeyword = '';
  bool? _filterCompleted;
  String _sortBy = 'createdAt';

  // 时间相对计算函数
  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 365) return '${(diff.inDays / 365).floor()}年前';
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()}月前';
    if (diff.inDays > 0) return '${diff.inDays}天前';
    if (diff.inHours > 0) return '${diff.inHours}小时前';
    if (diff.inMinutes > 0) return '${diff.inMinutes}分钟前';
    return '刚刚';
  }

  void _showAddTaskDialog(BuildContext context, AppStateModel model) {
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
                    }
                  },
                ),
                DropdownButtonFormField(
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
                  // 先关闭当前对话框
                  Navigator.pop(ctx);
                  // 再弹出确认对话框
                  showDialog(
                    context: context,
                    builder: (confirmCtx) => AlertDialog(
                      title: Text('确认新增'),
                      content: Text('确定要添加任务 "${titleController.text}" 吗？'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(confirmCtx),
                          child: Text('取消'),
                        ),
                        TextButton(
                          onPressed: () {
                            model.addTask(
                              titleController.text,
                              description: descController.text,
                              dueDate: dueDate,
                              priority: priority,
                            );
                            Navigator.pop(confirmCtx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('任务已添加')),
                            );
                          },
                          child: Text('添加'),
                        ),
                      ],
                    ),
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
                trailing: Text(
                  dueDate != null ? DateFormat('yyyy-MM-dd').format(dueDate!) : '未设置',
                ),
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
              DropdownButtonFormField(
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
                // 先关闭当前编辑对话框
                Navigator.pop(ctx);
                // 弹出确认对话框
                showDialog(
                  context: context,
                  builder: (confirmCtx) => AlertDialog(
                    title: Text('确认修改'),
                    content: Text('确定要修改任务 "${titleController.text}" 吗？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(confirmCtx),
                        child: Text('取消'),
                      ),
                      TextButton(
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
                          Navigator.pop(confirmCtx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('任务已更新')),
                          );
                        },
                        child: Text('保存'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('保存'),
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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(MyIcons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(MyIcons.add),
            onPressed: () => _showAddTaskDialog(context, ScopedModel.of(context)),
          ),
        ],
      ),
      drawer: CustomDrawer(scaffoldContext: context),
      body: Stack(
        children: [
          ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              // ================= 核心计算：搜索 + 筛选 + 排序 =================
              List displayTasks = List.from(model.tasks); // 复制一份，避免修改原始数据

              // 1. 搜索（标题或描述包含关键词）
              if (_searchKeyword.isNotEmpty) {
                final keyword = _searchKeyword.toLowerCase();
                displayTasks = displayTasks.where((task) =>
                task.title.toLowerCase().contains(keyword) ||
                    task.description.toLowerCase().contains(keyword)
                ).toList();
              }

              // 2. 筛选（已完成 / 未完成）
              if (_filterCompleted != null) {
                displayTasks = displayTasks.where((task) =>
                task.isCompleted == _filterCompleted
                ).toList();
              }

              // 3. 排序
              switch (_sortBy) {
                case 'dueDate':
                  displayTasks.sort((a, b) {
                    if (a.dueDate == null) return 1;
                    if (b.dueDate == null) return -1;
                    return a.dueDate!.compareTo(b.dueDate!);
                  });
                  break;
                case 'priority':
                  final priorityOrder = {'high': 0, 'medium': 1, 'low': 2};
                  displayTasks.sort((a, b) =>
                      priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!));
                  break;
                default: // 'createdAt'
                  displayTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
              }

              // 调试：打印当前显示的任务数量（运行后看终端）
              print('搜索词: "$_searchKeyword", 筛选: $_filterCompleted, 排序: $_sortBy, 显示任务数: ${displayTasks.length}');

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // ================= 工具栏 =================
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        alignment: WrapAlignment.start, // 居中排列
                        spacing: 8, // 水平间距
                        runSpacing: 8, // 垂直间距（换行后）
                        children: [
                          // 搜索框（占满一行）
                          SizedBox(
                            width: double.infinity, // 占满父容器宽度
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: '搜索任务...',
                                prefixIcon: Icon(MyIcons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _searchKeyword = value;
                                });
                                // 调试
                                print('搜索关键词更新: "$value"');
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(MyIcons.filter),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (ctx) {
                                  return StatefulBuilder(
                                    builder: (ctx, setSheetState) {
                                      return Container(
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('筛选状态', style: TextStyle(fontSize: 18)),
                                            RadioListTile(
                                              title: Text('全部'),
                                              value: null,
                                              groupValue: _filterCompleted,
                                              onChanged: (val) {
                                                setSheetState(() {
                                                  _filterCompleted = val;
                                                });
                                                setState(() {});
                                                Navigator.pop(ctx);
                                                print('筛选状态更新: $val');
                                              },
                                            ),
                                            RadioListTile(
                                              title: Text('已完成'),
                                              value: true,
                                              groupValue: _filterCompleted,
                                              onChanged: (val) {
                                                setSheetState(() {
                                                  _filterCompleted = val;
                                                });
                                                setState(() {});
                                                Navigator.pop(ctx);
                                                print('筛选状态更新: $val');
                                              },
                                            ),
                                            RadioListTile(
                                              title: Text('未完成'),
                                              value: false,
                                              groupValue: _filterCompleted,
                                              onChanged: (val) {
                                                setSheetState(() {
                                                  _filterCompleted = val;
                                                });
                                                setState(() {});
                                                Navigator.pop(ctx);
                                                print('筛选状态更新: $val');
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
                          PopupMenuButton(
                            icon: Icon(MyIcons.sort),
                            onSelected: (value) {
                              setState(() {
                                _sortBy = value;
                              });
                              print('排序方式更新: $value');
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
                    // ================= 任务列表 =================
                    displayTasks.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox, size: 60, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('暂无任务', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                      : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: displayTasks.length,
                        itemBuilder: (ctx, index) {
                          final task = displayTasks[index];
                          return Dismissible(
                            key: Key(task.id),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Icon(MyIcons.delete, color: Colors.white),
                              ),
                            ),
                            confirmDismiss: (direction) async { // 👈 添加确认
                              return await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('确认删除'),
                                  content: Text('确定要删除 "${task.title}" 吗？'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: Text('取消'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: Text('删除', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
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
                                    task.priority == 'high'
                                        ? MyIcons.flag
                                        : (task.priority == 'medium' ? MyIcons.flag : MyIcons.flag),
                                    color: task.priority == 'high'
                                        ? Colors.red
                                        : (task.priority == 'medium' ? Colors.orange : Colors.grey),
                                  ),
                                  SizedBox(width: 8),
                                  IconButton(
                                    icon: Icon(MyIcons.edit),
                                    onPressed: () => _showEditTaskDialog(ctx, task, model),
                                  ),
                                ],
                              ),
                              onTap: () {
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
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: const BackToHomeButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: buildBottomNavBar(context),
    );
  }
}