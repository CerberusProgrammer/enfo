import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:enfo/settings.dart';
import 'package:flutter/material.dart';

import 'clock.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  final CountDownController _controller = CountDownController();
  bool _mode = false;
  int time = 3000;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: _mode
            ? Center()
            : Clock(
                controller: _controller,
                time: time,
              ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () async {
                  bool theme = false;
                  theme = await AdaptiveTheme.getThemeMode().then(
                    (value) {
                      return value!.isDark;
                    },
                  );

                  // ignore: use_build_context_synchronously
                  showModalBottomSheet(
                      context: context,
                      builder: (builder) {
                        return Settings(theme: theme);
                      });
                },
                icon: const Icon(
                  Icons.settings,
                ),
              ),
              const Spacer(),
              Icon(_mode ? Icons.edit : Icons.remove_red_eye),
              Switch(
                value: _mode,
                onChanged: (value) {
                  setState(() {
                    _mode = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
