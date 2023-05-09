import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:enfo/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<StatefulWidget> createState() => _Settings();
}

class _Settings extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Dark Theme'),
            trailing: Switch(
              value: false,
              onChanged: (bool value) {},
            ),
          ),
          ListTile(
            title: const Text('Change Theme'),
            trailing: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: const CircleBorder(),
                side: const BorderSide(
                  color: Color.fromARGB(70, 35, 35, 35),
                  width: 8,
                ),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (builder) {
                      return Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 300,
                            height: 300,
                            child: GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 4,
                              children:
                                  List.generate(Themes.colors.length, (index) {
                                return OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Themes.colors[index],
                                    side: const BorderSide(
                                      color: Color.fromARGB(70, 35, 35, 35),
                                      width: 8,
                                    ),
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context);

                                    setState(() {
                                      AdaptiveTheme.of(context).setTheme(
                                        light: Themes.changeTheme(index),
                                      );
                                    });
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setInt('defaultIndex', index);
                                  },
                                  child: null,
                                );
                              }),
                            ),
                          ),
                        ),
                      );
                    }).then((value) {
                  setState(() {
                    value;
                  });
                });
              },
              child: null,
            ),
          ),
        ],
      ),
    );
  }
}
