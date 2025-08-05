import 'package:flutter/material.dart';
import 'package:habbit_tracker/database/habit_database.dart';
import 'package:habbit_tracker/themes/theme_provider.dart';
import 'package:habbit_tracker/ui/home_screen.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: HomeScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
