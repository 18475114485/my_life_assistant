import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:my_life_assistant/models/app_state_model.dart';
import 'package:my_life_assistant/widgets/home_button.dart';
import 'package:my_life_assistant/constants/my_icons.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('设置'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(MyIcons.arrowBack),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          return ListView(
            children: [
              // 主题切换
              ListTile(
                leading: Icon(MyIcons.brightness),
                title: Text('深色模式'),
                trailing: Switch(
                  value: model.themeMode == ThemeMode.dark,
                  onChanged: (_) {
                    model.toggleTheme();
                  },
                ),
              ),
              // 字体缩放
              ListTile(
                leading: Icon(MyIcons.text),
                title: Text('字体大小'),
                subtitle: Slider(
                  value: model.fontScale,
                  min: 0.8,
                  max: 1.5,
                  divisions: 7,
                  label: '${(model.fontScale * 100).round()}%',
                  onChanged: (value) {
                    model.setFontScale(value);
                  },
                ),
              ),
              // 昵称输入
              ListTile(
                leading: Icon(MyIcons.person),
                title: Text('昵称'),
                subtitle: TextField(
                  controller: _nicknameController,
                  decoration: InputDecoration(
                    hintText: '输入昵称',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    model.updateUserInfo(nickname: value);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('昵称已更新: $value')), // 回车确认
                    );
                  },
                ),
              ),
              // 邮箱输入
              ListTile(
                leading: Icon(MyIcons.email),
                title: Text('邮箱'),
                subtitle: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: '输入邮箱',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    model.updateUserInfo(email: value);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('邮箱已更新: $value')), // 回车确认
                    );
                  },
                ),
              ),
              // 展示当前主题状态
              ListTile(
                title: Text('当前主题: ${model.themeMode == ThemeMode.dark ? "深色" : "浅色"}'),
              ),
              ListTile(
                title: Text('当前字体缩放: ${(model.fontScale * 100).round()}%'),
              ),
            ],
          );
        },
      ),
      // 首页按钮
      floatingActionButton: const BackToHomeButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}