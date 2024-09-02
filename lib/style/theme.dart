import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      scaffoldBackgroundColor: Colors.grey[100],
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.blue,
        iconSize: 40,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: Colors.grey[200],
      ),
      tabBarTheme: TabBarTheme(
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
      primaryColor: Colors.indigoAccent,
      cardTheme: CardTheme(
        color: Colors.blue[100],
      ),
      listTileTheme: const ListTileThemeData(
        horizontalTitleGap: 40,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        subtitleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        leadingAndTrailingTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: Colors.blue,
        backgroundColor: Colors.grey[200],
      ),
    );
  }
}
