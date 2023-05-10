import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:enfo/introduction.dart';
import 'package:enfo/settings.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'clock.dart';
import 'custom_app_bar.dart';

class Home extends StatefulWidget {
  final bool presentation;

  const Home({
    super.key,
    required this.presentation,
  });

  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  final CountDownController _controller = CountDownController();
  bool _mode = false;
  int time = 1500;
  bool notifications = true;
  bool _pinned = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: Platform.isWindows
            ? CustomAppBar(
                title: widget.presentation ? '' : 'Enfo',
                onMinimize: () async {
                  await windowManager.minimize();
                },
                onMaximize: () async {
                  if (await windowManager.isMaximized()) {
                    await windowManager.unmaximize();
                  } else {
                    await windowManager.maximize();
                  }
                },
                onClose: () async {
                  await windowManager.close();
                },
              )
            : null,
        body: widget.presentation
            ? const Introduction()
            : Clock(
                controller: _controller,
                mode: _mode,
                time: time,
                notification: notifications,
              ),
        bottomNavigationBar: widget.presentation
            ? null
            : Padding(
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
                              return Settings(
                                theme: theme,
                              );
                            });
                      },
                      icon: const Icon(
                        Icons.settings,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (notifications) {
                          setState(() {
                            notifications = false;
                          });
                        } else {
                          setState(() {
                            notifications = true;
                          });
                        }
                      },
                      icon: Icon(
                        notifications
                            ? Icons.notifications
                            : Icons.notifications_off_outlined,
                      ),
                    ),
                    Platform.isWindows
                        ? IconButton(
                            onPressed: () async {
                              if (_pinned) {
                                setState(() {
                                  _pinned = false;
                                });
                                await windowManager.setAlwaysOnTop(false);
                              } else {
                                setState(() {
                                  _pinned = true;
                                });
                                await windowManager.setAlwaysOnTop(true);
                              }
                            },
                            color: _pinned
                                ? Theme.of(context).colorScheme.primary
                                : null,
                            icon: Icon(
                              _pinned
                                  ? Icons.push_pin
                                  : Icons.push_pin_outlined,
                              size: 24,
                            ),
                          )
                        : const Center(),
                    const Spacer(),
                    Icon(
                      _mode ? Icons.title : Icons.access_time,
                    ),
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
