import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:my_life_assistant/models/app_state_model.dart';
import 'package:my_life_assistant/widgets/custom_drawer.dart';
import 'package:my_life_assistant/pages/task_list_page.dart';
import 'package:my_life_assistant/pages/profile_page.dart';
import 'package:my_life_assistant/pages/settings_page.dart';


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
                  _buildGridItem(Icons.settings, '设置', Colors.green, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsPage()));
                  }),
                  _buildGridItem(Icons.info, '关于', Colors.purple, () {
                    showAboutDialog(
                      context: context,
                      applicationName: '我的生活助理',
                      applicationVersion: '1.0.0',
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: 16),
            // 统计卡片（显示任务数量）
            ScopedModelDescendant<AppStateModel>(
              builder: (context, child, model) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('总任务', model.totalTasks, Colors.blue),
                        _buildStatItem('已完成', model.completedTasks, Colors.green),
                        _buildStatItem('未完成', model.pendingTasks, Colors.red),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
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