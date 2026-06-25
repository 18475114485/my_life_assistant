import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class StorageService {
  static const String _tasksKey = 'tasks';
  static const String _themeKey = 'themeMode';
  static const String _fontScaleKey = 'fontScale';

  // 保存任务列表
  static Future<void> saveTasks(List<Map<String, dynamic>> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(tasks);
    await prefs.setString(_tasksKey, jsonString);
  }

  // 读取任务列表
  static Future<List<Map<String, dynamic>>?> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_tasksKey);
    if (jsonString == null) return null;
    return List<Map<String, dynamic>>.from(jsonDecode(jsonString));
  }

  // 保存主题模式
  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    final value = mode.index; // 0: light, 1: dark, 2: system
    await prefs.setInt(_themeKey, value);
  }

  // 读取主题模式
  static Future<ThemeMode?> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(_themeKey);
    if (value == null) return null;
    return ThemeMode.values[value];
  }

  // 保存字体缩放
  static Future<void> saveFontScale(double scale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontScaleKey, scale);
  }

  // 读取字体缩放
  static Future<double?> loadFontScale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_fontScaleKey);
  }
}