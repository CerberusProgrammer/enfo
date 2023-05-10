import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Introduction extends StatefulWidget {
  const Introduction({super.key});

  @override
  State<StatefulWidget> createState() => _Introduction();
}

class _Introduction extends State<Introduction> {
  List<PageViewModel> pages = [
    PageViewModel(title: '', body: ''),
    PageViewModel(title: '', body: ''),
    PageViewModel(title: '', body: ''),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: pages,
      showNextButton: true,
      showBackButton: true,
      done: const Text("Done"),
      onDone: () async {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('presentation', false);
        // ignore: use_build_context_synchronously
        _onIntroEnd(context);
      },
      back: const Icon(Icons.arrow_back),
      next: const Icon(Icons.arrow_forward),
    );
  }

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const Home(
          presentation: false,
        ),
      ),
    );
  }
}
