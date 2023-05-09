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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Clock(
        controller: _controller,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder) {
                  return const Settings();
                }));
                /*
                showModalBottomSheet(
                    context: context,
                    builder: (builder) {
                      return const Settings();
                    });
                 */
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
    );
  }
}
