import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_life_assistant/models/app_state_model.dart';
import 'package:my_life_assistant/widgets/custom_drawer.dart';
import 'package:my_life_assistant/widgets/custom_button.dart';

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
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: CustomDrawer(scaffoldContext: context),
      body: ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 头像
                GestureDetector(
                  onTap: _showImagePickerDialog,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _avatarImage != null
                            ? FileImage(_avatarImage!)
                            : AssetImage('assets/images/logo.png') as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text('点击头像更换', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 32),
                // 统计信息
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 32),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('任务统计', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _statItem('总任务', model.totalTasks),
                            _statItem('已完成', model.completedTasks),
                            _statItem('未完成', model.pendingTasks),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),
                // 预览删除图片示例（如果存在）
                if (_avatarImage != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('删除头像'),
                              content: Text('确定要删除头像吗？'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx), child: Text('取消')),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _avatarImage = null;
                                    });
                                    Navigator.pop(ctx);
                                  },
                                  child: Text('删除'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.delete),
                        label: Text('删除头像'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
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