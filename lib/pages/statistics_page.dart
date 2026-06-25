import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:my_life_assistant/models/app_state_model.dart';

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
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
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
                        Text(
                          '${(rate * 100).toStringAsFixed(1)}%',
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        LinearProgressIndicator(
                          value: rate,
                          minHeight: 8,
                        ),
                        Text('$completed / $total 已完成'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // 状态统计
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statCard('已完成', completed, Colors.green),
                    _statCard('未完成', inProgress, Colors.orange),
                  ],
                ),
                SizedBox(height: 16),
                // 任务列表
                Expanded(
                  child: ListView.builder(
                    itemCount: model.tasks.length,
                    itemBuilder: (ctx, index) {
                      final task = model.tasks[index];
                      return ListTile(
                        leading: Icon(
                          task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
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
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(context, '首页', Icons.home, 0, HomePage()),
              _navItem(context, '任务', Icons.list, 1, TaskListPage()),
              _navItem(context, '个人', Icons.person, 2, ProfilePage()),
              _navItem(context, '统计', Icons.bar_chart, 3, StatisticsPage()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String label, int count, Color color) {
    return Card(
      child: Container(
        width: 100,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(label),
            Text('$count', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}