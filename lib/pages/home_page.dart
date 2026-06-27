import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:my_life_assistant/models/app_state_model.dart';
import 'package:my_life_assistant/widgets/custom_drawer.dart';
import 'package:my_life_assistant/widgets/nav_bar.dart';
import 'package:my_life_assistant/widgets/home_button.dart';
import 'package:my_life_assistant/pages/task_list_page.dart';
import 'package:my_life_assistant/pages/profile_page.dart';
import 'package:my_life_assistant/pages/statistics_page.dart';
import 'package:my_life_assistant/pages/settings_page.dart';
import 'package:my_life_assistant/utils/navigation_utils.dart';


class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('首页'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      drawer: CustomDrawer(scaffoldContext: context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 标题横幅
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    '我的生活助理',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '让生活更有序，让成长更可见',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            // 轮播图
            CarouselSlider(
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
              ),
              items: [
                'https://picsum.photos/seed/1/800/400',
                'https://picsum.photos/seed/2/800/400',
                'https://picsum.photos/seed/3/800/400',
              ].map((url) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(url, fit: BoxFit.cover, width: double.infinity),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            // 快捷入口（GridView）
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.1,
                children: [
                  _buildGridItem(Icons.task, '任务', Colors.orange, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => TaskListPage()));
                  }),
                  _buildGridItem(Icons.person, '个人', Colors.blue, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
                  }),
                  _buildGridItem(Icons.bar_chart, '统计', Colors.green, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => StatisticsPage()));
                  }),
                  _buildGridItem(Icons.info, '关于', Colors.purple, () {
                    showDialog(
                      context: context,
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
                  }),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: const BackToHomeButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: buildBottomNavBar(context),
    );
  }

  Widget _buildGridItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text('$count', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}