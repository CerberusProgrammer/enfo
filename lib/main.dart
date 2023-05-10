import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:enfo/introduction.dart';
import 'package:enfo/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  final prefs = await SharedPreferences.getInstance();

  Themes.defaultIndex = prefs.getInt('defaultIndex') ?? 8;
  bool presentation = prefs.getBool('presentation') ?? true;

  runApp(
    Main(
      savedThemeMode: savedThemeMode,
      presentation: presentation,
    ),
  );

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();

    const WindowOptions windowOptions = WindowOptions(
      size: Size(400, 400),
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      title: 'Enfo',
      titleBarStyle: TitleBarStyle.hidden,
      minimumSize: Size(250, 250),
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
    });
  }
}

class Main extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;
  final bool presentation;

  const Main({
    super.key,
    this.savedThemeMode,
    required this.presentation,
  });

  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          colorSchemeSeed: Themes.colors[Themes.defaultIndex],
          useMaterial3: true,
        ),
        dark: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: Themes.colors[Themes.defaultIndex],
          useMaterial3: true,
        ),
        initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
        builder: (theme, darkTheme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "enfo",
            theme: theme,
            darkTheme: darkTheme,
            home: Home(
              presentation: true,
            ),
          );
        });
  }
}
