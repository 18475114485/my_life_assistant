import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_life_assistant/pages/home_page.dart';
import 'package:my_life_assistant/pages/statistics_page.dart';
import 'package:my_life_assistant/pages/task_list_page.dart';
import 'package:my_life_assistant/models/app_state_model.dart';
import 'package:my_life_assistant/widgets/custom_drawer.dart';
import 'package:my_life_assistant/widgets/custom_button.dart';
import 'package:my_life_assistant/widgets/nav_bar.dart';
import 'package:my_life_assistant/widgets/home_button.dart';
import 'package:flutter_cors_image/flutter_cors_image.dart';
import 'package:my_life_assistant/utils/navigation_utils.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  File? _avatarImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });
    }
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('从相册选择'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('拍照'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('个人中心'),
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
      ),
      drawer: CustomDrawer(scaffoldContext: context),
      body: Stack(
        children: [
          // 背景图
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://www.helloimg.com/i/2026/05/09/69fee0f890e96.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              // 计算可用高度（屏幕高度 - AppBar - 底部导航栏）
              final screenHeight = MediaQuery
                  .of(context)
                  .size
                  .height;
              final appBarHeight = kToolbarHeight; // 默认 56
              final bottomNavHeight = kBottomNavigationBarHeight; // 默认 56
              final minHeight = screenHeight - appBarHeight - bottomNavHeight;
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: minHeight,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
                    color: Colors.black.withOpacity(0.4),
                    child: ScopedModelDescendant<AppStateModel>(
                      builder: (context, child, model) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 头像
                            GestureDetector(
                              onTap: _showImagePickerDialog,
                              child: Stack(
                                children: [
                                  ClipOval(
                                    child: _avatarImage != null
                                        ? Image.file(_avatarImage!, width: 120,
                                        height: 120,
                                        fit: BoxFit.cover)
                                        : CustomNetworkImage(
                                      url: 'https://q1.qlogo.cn/g?b=qq&nk=3031648024&s=100',
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      // 加载失败时显示占位图标
                                      errorBuilder: (context, error,
                                          stackTrace) =>
                                          Container(
                                            color: Colors.grey[300],
                                            child: Icon(Icons.person, size: 50,
                                                color: Colors.grey[600]),
                                          ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.blue,
                                      child: Icon(
                                          Icons.camera_alt, color: Colors.white,
                                          size: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              model.nickname.isNotEmpty
                                  ? model.nickname
                                  : '未设置昵称',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              model.email.isNotEmpty ? model.email : '未设置邮箱',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[300],
                              ),
                            ),
                            SizedBox(height: 32),
                            // 标签云（使用任务标题）
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: model.tasks.map((task) {
                                  return Chip(
                                    label: Text(
                                      task.title,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.blue,
                                    shape: StadiumBorder(),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
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

  Widget _statItem(String label, int count) {
    return Column(
      children: [
        Text('$count', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}