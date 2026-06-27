import 'package:flutter/material.dart';
import 'package:my_life_assistant/pages/home_page.dart';
import 'package:my_life_assistant/utils/navigation_utils.dart';

class BackToHomeButton extends StatelessWidget {
  const BackToHomeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      onPressed: () {
        NavigationUtils.navigateTo(context, HomePage(), '首页');
      },
      child: const Icon(Icons.home, color: Colors.white),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: const CircleBorder(),
    );
  }
}