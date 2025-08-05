import 'package:flutter/material.dart';
import 'package:habbit_tracker/model/app_settings.dart';
import 'package:habbit_tracker/model/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  // Created a variable to handle the operation
  static late Isar isar;
  // Created a List to store all the habits
  List<Habit> currentHabits = [];

  /// **** Initialize database **** ///

  static Future<void> initialize() async {
    // Getting the ApplicationDirectory to store our database
    final dir = await getApplicationDocumentsDirectory();
    // Creating a database with tableScheme and directory path
    isar = await Isar.open([
      HabitSchema,
      AppSettingsSchema,
    ], directory: dir.path);
  }

  /// **** Save first date of app startup (for heatMap) **** ///

  Future<void> saveFirstLaunchDate() async {
    // getting the existingSetting from local database
    final existingSetting = await isar.appSettings.where().findFirst();
    // Checking
    if (existingSetting == null) {
      // Creating a new AppSettings object with firstLaunchDate of Current Date
      final setting = AppSettings()..firstLaunchDate = DateTime.now();
      // Store AppSettings object into local storage
      await isar.writeTxn(() => isar.appSettings.put(setting));
    }
  }

  /// **** Get first date of app startup (for heatMap) **** ///

  Future<DateTime?> getFirstLaunchDate() async {
    // Fetching the first appSettings object from local database
    final setting = await isar.appSettings.where().findFirst();
    // Returning the firstLaunchDate
    return setting?.firstLaunchDate;
  }

  /// **** Create a new Habit **** ///

  Future<void> addHabit(String habitName) async {
    // Creating a new Habit object with habitName id will be generated automatically
    final newHabit = Habit()..name = habitName;
    // Storing the newHabit into local database
    isar.writeTxn(() => isar.habits.put(newHabit));
    // Calling readHabits to refresh the list of Habits
    readHabits();
  }

  /// **** fetching all Habits **** ///

  Future<void> readHabits() async {
    // Fetching all the habits from local database
    currentHabits = await isar.habits.where().findAll();
    // notifying the listeners to update the UI
    notifyListeners();
  }

  Future<void> updateHabitCompletion(int id,bool isCompleted )async{
    // fetch the specific habit by Id
    final  habit = await isar.habits.get(id);
     // Update Completion Logic
    if(habit != null){

      await isar.writeTxn(()async{
         // If the habit is completed
        if(isCompleted && !habit.completedDays.contains(DateTime.now())){
          final today = DateTime.now();
          habit.completedDays.add(DateTime(today.year,today.month,today.day));

        }


      });

    }

  }

}
