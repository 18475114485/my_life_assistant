import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:my_life_assistant/models/app_state_model.dart';
import 'package:my_life_assistant/pages/home_page.dart';
import 'package:my_life_assistant/constants/app_colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final AppStateModel _model = AppStateModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppStateModel>(
      model: _model,
      child: ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          return MaterialApp(
            title: '我的生活助理',
            theme: ThemeData(
              primaryColor: AppColors.primary,
              colorScheme: ColorScheme.light(primary: AppColors.primary),
              textTheme: TextTheme(
                bodyLarge: TextStyle(fontSize: 16 * model.fontScale),
                bodyMedium: TextStyle(fontSize: 14 * model.fontScale),
              ),
              iconTheme: IconThemeData(color: AppColors.primary),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.purple,
              colorScheme: ColorScheme.dark(primary: Colors.purple),
              textTheme: TextTheme(
                bodyLarge: TextStyle(fontSize: 16 * model.fontScale),
                bodyMedium: TextStyle(fontSize: 14 * model.fontScale),
              ),
              iconTheme: IconThemeData(color: Colors.purpleAccent),
            ),
            themeMode: model.themeMode,
            home: HomePage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}