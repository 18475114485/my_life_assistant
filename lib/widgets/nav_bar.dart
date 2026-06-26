import 'package:flutter/material.dart';
import 'package:my_life_assistant/utils/navigation_utils.dart';
import 'package:my_life_assistant/pages/home_page.dart';
import 'package:my_life_assistant/pages/task_list_page.dart';
import 'package:my_life_assistant/pages/profile_page.dart';
import 'package:my_life_assistant/pages/statistics_page.dart';

Widget buildBottomNavBar(BuildContext context) {
  return BottomAppBar(
    color: Colors.blue,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, '首页', Icons.home, HomePage()),
          _navItem(context, '任务', Icons.list, TaskListPage()),
          _navItem(context, '个人', Icons.person, ProfilePage()),
          _navItem(context, '统计', Icons.bar_chart, StatisticsPage()),
        ],
      ),
    ),
  );
}

Widget _navItem(BuildContext context, String label, IconData icon, Widget page) {
  return GestureDetector(
    onTap: () => NavigationUtils.navigateTo(context, page, label),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
      ],
    ),
  );
}