import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_cors_image/flutter_cors_image.dart';
import 'package:my_life_assistant/models/app_state_model.dart';
import 'package:my_life_assistant/pages/home_page.dart';
import 'package:my_life_assistant/pages/task_list_page.dart';
import 'package:my_life_assistant/pages/settings_page.dart';
import 'package:my_life_assistant/pages/profile_page.dart';
import 'package:my_life_assistant/pages/statistics_page.dart';
import 'package:my_life_assistant/utils/navigation_utils.dart';
import 'package:my_life_assistant/constants/my_icons.dart';


// 抽屉部件
class CustomDrawer extends StatelessWidget {
  final BuildContext scaffoldContext;

  const CustomDrawer({required this.scaffoldContext});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // 抽屉头
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ClipOval(
                      child: CustomNetworkImage(
                        url: 'https://q1.qlogo.cn/g?b=qq&nk=3031648024&s=100',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        // 加载失败时显示占位图标
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: Icon(MyIcons.person, size: 30, color: Colors.grey[600]),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    // 从设置页输入内容获取
                    Text(
                      model.nickname.isNotEmpty ? model.nickname : '未设置昵称',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    // 从设置页输入内容获取
                    Text(
                      model.email.isNotEmpty ? model.email : '未设置邮箱',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(MyIcons.home),
                title: Text('首页'),
                onTap: () {
                  Navigator.pop(scaffoldContext);
                  NavigationUtils.navigateTo(context, HomePage(), '首页');
                },
              ),
              ListTile(
                leading: Icon(MyIcons.task),
                title: Text('任务列表'),
                  onTap: () {
                    Navigator.pop(scaffoldContext);
                    NavigationUtils.navigateTo(context, TaskListPage(), '任务列表');
                  },
              ),
              ListTile(
                leading: Icon(MyIcons.person),
                title: Text('个人中心'),
                onTap: () {
                  Navigator.pop(scaffoldContext);
                  NavigationUtils.navigateTo(context, ProfilePage(), '个人中心');
                },
              ),
              ListTile(
                leading: Icon(Icons.bar_chart),
                title: Text('任务统计'),
                onTap: () {
                  Navigator.pop(scaffoldContext);
                  NavigationUtils.navigateTo(context, StatisticsPage(), '任务统计');
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('设置'),
                onTap: () {
                  Navigator.pop(scaffoldContext);
                  NavigationUtils.navigateTo(context, SettingsPage(), '设置', true);
                },
              ),
              Divider(),
              // 关于对话框
              ListTile(
                leading: Icon(MyIcons.info),
                title: Text('关于'),
                onTap: () {
                  Navigator.pop(scaffoldContext);
                  showDialog(
                    context: scaffoldContext,
                    builder: (ctx) => AlertDialog(
                      title: Text('关于「我的生活助理」'),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('版本: 1.0.0'),
                            const SizedBox(height: 8),
                            Text('这是一个个人向生活助理App。'),
                            Text('- 个性化定制日常活动！'),
                            Text('- 工作、学习、放松、玩乐！'),
                            Text('- 随时安排新任务！'),
                            const SizedBox(height: 8),
                            Text('来定制属于自己的每日任务吧。'),
                          ],
                        ),
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