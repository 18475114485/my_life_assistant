import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:my_life_assistant/pages/home_page.dart';
import 'package:my_life_assistant/pages/profile_page.dart';
import 'package:my_life_assistant/pages/task_list_page.dart';
import 'package:my_life_assistant/models/app_state_model.dart';
import 'package:my_life_assistant/utils/navigation_utils.dart';
import 'package:my_life_assistant/widgets/nav_bar.dart';
import 'package:my_life_assistant/widgets/custom_drawer.dart';
import 'package:my_life_assistant/widgets/home_button.dart';
import 'package:my_life_assistant/constants/my_icons.dart';
import 'package:my_life_assistant/constants/app_colors.dart';


// 统计页
class StatisticsPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('统计'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
            ),
          ),
        ),
      ),
      // 抽屉
      drawer: CustomDrawer(scaffoldContext: context),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ScopedModelDescendant<AppStateModel>(
                builder: (context, child, model) {
                  // 主要为解决溢出问题
                  final total = model.tasks.length;
                  final completed = model.tasks.where((t) => t.isCompleted).length;
                  final inProgress = model.tasks.where((t) => !t.isCompleted).length;
                  final rate = total > 0 ? completed / total : 0.0;

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // 完成率卡片
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text('完成率', style: TextStyle(fontSize: 18)),
                                SizedBox(height: 8),
                                Text(
                                  '${(rate * 100).toStringAsFixed(1)}%',
                                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: rate,
                                    minHeight: 14,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text('$completed / $total 已完成'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        // 状态统计
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.0,
                            children: [
                                _statCard(context, MyIcons.task, total, '任务数', Colors.blue),
                                _statCard(context, MyIcons.checkCircle, completed, '已完成', Colors.green),
                                _statCard(context, MyIcons.radioButtonUnchecked, inProgress, '未完成', Colors.orange),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        // 任务明细列表
                        Text('任务明细', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: model.tasks.length,
                          itemBuilder: (ctx, index) {
                            final task = model.tasks[index];
                            return ListTile(
                              leading: Icon(
                                task.isCompleted ? MyIcons.checkCircle : MyIcons.radioButtonUnchecked,
                                color: task.isCompleted ? Colors.green : Colors.grey,
                              ),
                              title: Text(task.title),
                              subtitle: Text(task.description),
                              trailing: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: task.isCompleted ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  task.isCompleted ? '已完成' : '未完成',
                                  style: TextStyle(
                                    color: task.isCompleted ? Colors.green : Colors.orange,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      // 首页按钮
      floatingActionButton: const BackToHomeButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // 底部导航栏
      bottomNavigationBar: buildBottomNavBar(context),
    );
  }

  // 状态卡片：三种状态复用
  Widget _statCard(BuildContext context, IconData icon, int count, String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(height: 4),
          Text(
            '$count',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}