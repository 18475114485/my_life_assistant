import 'package:flutter/material.dart';
import 'package:my_life_assistant/pages/home_page.dart';
import 'package:my_life_assistant/utils/navigation_utils.dart';
import 'package:my_life_assistant/constants/my_icons.dart';
import 'package:my_life_assistant/constants/app_colors.dart';

// 全局按钮：返回首页
class BackToHomeButton extends StatelessWidget {
  const BackToHomeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 位于右下角
    return FloatingActionButton(
      onPressed: () {
        NavigationUtils.navigateTo(context, HomePage(), '首页');
      },
      child: const Icon(MyIcons.home, color: Colors.white, size: 30),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: const CircleBorder(),
    );
  }
}