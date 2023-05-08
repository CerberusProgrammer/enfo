import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  bool mode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FilledButton(
          onPressed: () {},
          child: const Text('start'),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
            const Spacer(),
            Icon(mode ? Icons.edit : Icons.remove_red_eye),
            Switch(
              value: mode,
              onChanged: (value) {
                setState(() {
                  mode = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
