import 'package:flutter/material.dart';

// 页面导航工具，实现跳转与判断（SnackBar）
class NavigationUtils {
  /// 导航到目标页面，如果已在当前页面则显示提示
  static void navigateTo(
      BuildContext context,
      Widget targetPage,
      String targetName,
      [bool usePush = false]
      ) {
    // 获取当前路由名称
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    // 获取目标页面的路由名称（通过页面类型名）
    final targetRoute = targetPage.runtimeType.toString();

    if (currentRoute == targetRoute) {
      // 已在当前页面，显示提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('您已在 $targetName 页面')),
      );
    } else {
      if (usePush) {
        // 抽屉用 push：保留返回栈
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => targetPage,
            settings: RouteSettings(name: targetRoute),
          ),
        );
      } else {
        // 底部导航用 pushReplacement：避免栈堆积
        // 跳转到目标页面
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => targetPage,
            settings: RouteSettings(name: targetRoute),
          ),
        );
      }
    }
  }
}