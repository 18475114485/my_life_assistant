import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:my_life_assistant/models/app_state_model.dart';
import 'package:my_life_assistant/pages/home_page.dart';
import 'package:my_life_assistant/pages/task_list_page.dart';
import 'package:my_life_assistant/pages/settings_page.dart';
import 'package:my_life_assistant/pages/profile_page.dart';
import 'package:my_life_assistant/pages/statistics_page.dart';
import 'package:my_life_assistant/utils/navigation_utils.dart';

class CustomDrawer extends StatelessWidget {
  final BuildContext scaffoldContext;

  const CustomDrawer({required this.scaffoldContext});

  void _navigateTo(BuildContext context, Widget page, {bool isCurrent = false}) {
    Navigator.pop(scaffoldContext); // 关闭抽屉
    if (!isCurrent) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('您已在当前页面')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage('https://q1.qlogo.cn/g?b=qq&nk=3031648024&s=100'),
                    ),
                    SizedBox(height: 8),
                    Text(
                      model.nickname.isNotEmpty ? model.nickname : '未设置昵称',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      model.email.isNotEmpty ? model.email : '未设置邮箱',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('首页'),
                onTap: () {
                  NavigationUtils.navigateTo(context, HomePage(), '首页');
                },
              ),
              ListTile(
                leading: Icon(Icons.list),
                title: Text('任务列表'),
                  onTap: () {
                    NavigationUtils.navigateTo(context, TaskListPage(), '任务列表');
                  },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('个人中心'),
                onTap: () {
                  NavigationUtils.navigateTo(context, ProfilePage(), '个人中心');
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('设置'),
                onTap: () {
                  NavigationUtils.navigateTo(context, StatisticsPage(), '设置');
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('关于'),
                onTap: () {
                  Navigator.pop(scaffoldContext);
                  showDialog(
                    context: scaffoldContext,
                    builder: (ctx) => AlertDialog(
                      title: Text('关于「我的生活助理」'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('版本: 1.0.0'),
                          SizedBox(height: 8),
                          Text('这是一个个人向生活助理App。'),
                          Text('- 个性化定制日常活动！'),
                          Text('- 工作、学习、放松、玩乐！'),
                          Text('- 随时安排新任务！'),
                          SizedBox(height: 8),
                          Text('来定制属于自己的每日任务吧。'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text('关闭'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}