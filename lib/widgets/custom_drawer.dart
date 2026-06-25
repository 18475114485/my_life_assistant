import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:my_life_assistant/models/app_state_model.dart';
import 'package:my_life_assistant/pages/home_page.dart';
import 'package:my_life_assistant/pages/task_list_page.dart';
import 'package:my_life_assistant/pages/settings_page.dart';
import 'package:my_life_assistant/pages/profile_page.dart';

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
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
                SizedBox(height: 8),
                Text('我的生活助理', style: TextStyle(color: Colors.white, fontSize: 20)),
                Text('v1.0.0', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('首页'),
            onTap: () => _navigateTo(context, HomePage()),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('任务列表'),
            onTap: () => _navigateTo(context, TaskListPage()),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('个人中心'),
            onTap: () => _navigateTo(context, ProfilePage()),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('设置'),
            onTap: () => _navigateTo(context, SettingsPage()),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('关于'),
            onTap: () {
              Navigator.pop(scaffoldContext);
              showAboutDialog(
                context: context,
                applicationName: '我的生活助理',
                applicationVersion: '1.0.0',
                children: [
                  Text('一个展示Flutter基础组件的完整示例。'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}