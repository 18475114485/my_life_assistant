import 'package:flutter/material.dart';
import 'package:my_life_assistant/utils/navigation_utils.dart';
import 'package:my_life_assistant/pages/home_page.dart';
import 'package:my_life_assistant/pages/task_list_page.dart';
import 'package:my_life_assistant/pages/profile_page.dart';
import 'package:my_life_assistant/pages/statistics_page.dart';
import 'package:my_life_assistant/constants/my_icons.dart';


Widget buildBottomNavBar(BuildContext context) {
  // 获取视口高度
  final viewportHeight = MediaQuery.of(context).size.height;

  // 当视口高度小于导航栏最小所需高度时，直接隐藏
  // 这里设 550 作为安全阈值（导航栏完整显示约需 60~70px，但提前隐藏更安全）
  if (viewportHeight < 70) {
    return const SizedBox.shrink();
  }
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue, Colors.purple],
      ),
    ),
    child: BottomAppBar(
      height: 70,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(context, '首页', MyIcons.home, HomePage()),
            _navItem(context, '任务', MyIcons.task, TaskListPage()),
            _navItem(context, '统计', Icons.bar_chart, StatisticsPage()),
            _navItem(context, '个人', MyIcons.person, ProfilePage()),
          ],
        ),
      ),
    ),
  );
}

Widget _navItem(BuildContext context, String label, IconData icon, Widget page) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => NavigationUtils.navigateTo(context, page, label),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 24.0),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
      ],
    ),
  );
}