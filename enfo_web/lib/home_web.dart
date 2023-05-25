import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:enfo_web/settings_web.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as web;
import 'clock_web.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:ui' as ui;

class HomeWeb extends StatefulWidget {
  const HomeWeb({super.key});

  @override
  State<StatefulWidget> createState() => _HomeWeb();
}

class _HomeWeb extends State<HomeWeb> {
  final CountDownController _controller = CountDownController();
  bool _mode = false;
  int time = 1500;
  bool notifications = false;
  String permission = "";

  Widget adsenseAdsView() {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'adViewType',
      (int viewID) => web.IFrameElement()
        ..width = '320'
        ..height = '100'
        ..src = 'adview.html'
        ..style.border = 'none',
    );

    return const SizedBox(
      height: 100.0,
      width: 320.0,
      child: HtmlElementView(
        viewType: 'adViewType',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClockWeb(
        controller: _controller,
        mode: _mode,
        notification: notifications,
        time: time,
        permission: permission,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          children: [
            Tooltip(
              message: 'Settings',
              child: IconButton(
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
                        return SettingsWeb(
                          theme: theme,
                        );
                      });
                },
                icon: const Icon(
                  Icons.settings,
                ),
              ),
            ),
            Tooltip(
              message: notifications
                  ? 'Disable notifications'
                  : 'Enable notifications',
              child: IconButton(
                onPressed: () async {
                  if (notifications) {
                    setState(() {
                      notifications = false;
                    });
                  } else {
                    String? p = web.Notification.permission;

                    if (p != 'granted') {
                      p = await web.Notification.requestPermission();
                    }

                    setState(() {
                      notifications = true;
                      permission = p ?? "";
                    });
                  }
                },
                icon: Icon(
                  notifications
                      ? Icons.notifications
                      : Icons.notifications_off_outlined,
                ),
              ),
            ),
            Tooltip(
              message: 'Buy me a coffee',
              child: IconButton(
                icon: const Icon(Icons.coffee),
                onPressed: () async {
                  const url = 'https://www.buymeacoffee.com/sazarcode';
                  final uri = Uri.parse(url);

                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ),
            Tooltip(
              message: 'View on GitHub',
              child: IconButton(
                onPressed: () async {
                  const url = 'https://github.com/CerberusProgrammer/enfo';
                  final uri = Uri.parse(url);

                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                icon: const Icon(FontAwesomeIcons.github),
              ),
            ),
            Tooltip(
              message: 'View on Play Store',
              child: IconButton(
                onPressed: () async {
                  const url =
                      'https://play.google.com/store/apps/details?id=com.sazarcode.enfo';
                  final uri = Uri.parse(url);

                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                icon: const Icon(FontAwesomeIcons.googlePlay),
              ),
            ),
            Tooltip(
              message: 'Get desktop version',
              child: IconButton(
                onPressed: () async {
                  const url =
                      'https://github.com/CerberusProgrammer/enfo/releases/download/Windows/enfo_installer.exe';
                  final uri = Uri.parse(url);

                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                icon: const Icon(FontAwesomeIcons.windows),
              ),
            ),
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
    );
  }
}
