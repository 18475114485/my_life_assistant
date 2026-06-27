import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:my_life_assistant/models/task_model.dart';
import 'package:my_life_assistant/services/storage_service.dart';
import 'dart:math' show Random;

class AppStateModel extends Model {
  List<Task> _tasks = [];
  ThemeMode _themeMode = ThemeMode.light; // 当前主题模式
  double _fontScale = 1.0;               // 字体缩放系数

  // 构造函数：加载持久化数据
  AppStateModel() {
    _loadData();
  }

  // ---- Getter ----
  List<Task> get tasks => List.unmodifiable(_tasks);
  ThemeMode get themeMode => _themeMode;
  double get fontScale => _fontScale;

  // ---- 主题切换 ----
  void toggleTheme() {
    _themeMode = (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    _saveThemePreference();
    notifyListeners();
  }

  // ---- 字体缩放 ----
  void setFontScale(double value) {
    _fontScale = value;
    _saveFontScalePreference();
    notifyListeners();
  }

  // ---- 任务操作 ----
  // 增加
  void addTask(String title, {String description = '', DateTime? dueDate, String priority = 'medium'}) {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      priority: priority,
    );
    _tasks.insert(0, newTask); // 新任务放在最前
    _saveTasks();
    notifyListeners();
  }

  // 删除
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveTasks();
    notifyListeners();
  }

  // 更新（编辑）
  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      _saveTasks();
      notifyListeners();
    }
  }

  // 切换完成状态
  void toggleCompleted(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      _saveTasks();
      notifyListeners();
    }
  }

  // ---- 查询操作（搜索、筛选、排序） ----
  List<Task> searchTasks(String keyword) {
    if (keyword.isEmpty) return _tasks;
    return _tasks.where((task) =>
    task.title.toLowerCase().contains(keyword.toLowerCase()) ||
        task.description.toLowerCase().contains(keyword.toLowerCase())
    ).toList();
  }

  List<Task> filterTasks({bool? showCompleted}) {
    if (showCompleted == null) return _tasks;
    return _tasks.where((task) => task.isCompleted == showCompleted).toList();
  }

  List<Task> sortTasks(String by) {
    final sorted = List<Task>.from(_tasks);
    switch (by) {
      case 'createdAt':
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'dueDate':
        sorted.sort((a, b) {
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case 'priority':
        final priorityOrder = {'high': 0, 'medium': 1, 'low': 2};
        sorted.sort((a, b) => priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!));
        break;
    }
    return sorted;
  }

  // ---- 昵称及邮箱（多页面共用） ----
  String _nickname = '';
  String _email = '';
  String get nickname => _nickname;
  String get email => _email;

  void updateUserInfo({String? nickname, String? email}) {
    if (nickname != null) {
      _nickname = nickname;
      StorageService.saveNickname(nickname);
    }
    if (email != null) {
      _email = email;
      StorageService.saveEmail(email);
    }
    notifyListeners();
  }

  // ---- 统计 ----
  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((t) => t.isCompleted).length;
  int get pendingTasks => totalTasks - completedTasks;

  // ---- 数据持久化 ----
  void _loadData() async {
    final tasksJson = await StorageService.loadTasks();
    if (tasksJson != null) {
      _tasks = tasksJson.map((json) => Task.fromJson(json)).toList();
    } else {
      // 如果没有数据，添加一些示例任务
      _addSampleTasks();
    }
    _themeMode = await StorageService.loadThemeMode() ?? ThemeMode.light;
    _fontScale = await StorageService.loadFontScale() ?? 1.0;
    _nickname = await StorageService.loadNickname() ?? '';
    _email = await StorageService.loadEmail() ?? '';
    notifyListeners();


    notifyListeners();
  }

  void _addSampleTasks() {
    final now = DateTime.now();
    _tasks = [
      Task(
        id: '1',
        title: '学习 Flutter',
        description: '完成基础组件练习',
        createdAt: now.subtract(Duration(days: 2)),
        dueDate: now.add(Duration(days: 2)),
        priority: 'high',
      ),
      Task(
        id: '2',
        title: '买日用品',
        description: '牙膏、洗发水',
        createdAt: now.subtract(Duration(hours: 5)),
        dueDate: now.add(Duration(days: 1)),
        priority: 'medium',
      ),
      Task(
        id: '3',
        title: '阅读《百年孤独》',
        description: '至少读50页',
        createdAt: now.subtract(Duration(days: 7)),
        dueDate: now.add(Duration(days: 7)),
        priority: 'low',
      ),
      Task(
        id: '4',
        title: '锻炼身体',
        description: '跑步30分钟',
        createdAt: now.subtract(Duration(hours: 2)),
        dueDate: now,
        priority: 'high',
      ),
    ];
  }

  void _saveTasks() {
    final jsonList = _tasks.map((task) => task.toJson()).toList();
    StorageService.saveTasks(jsonList);
  }

  void _saveThemePreference() {
    StorageService.saveThemeMode(_themeMode);
  }

  void _saveFontScalePreference() {
    StorageService.saveFontScale(_fontScale);
  }

}