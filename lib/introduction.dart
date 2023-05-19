import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'home.dart';

class Introduction extends StatefulWidget {
  const Introduction({super.key});

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  bool _showDescription = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isWindows) {
      windowManager.setAlwaysOnTop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      isProgress: false,
      pages: [
        PageViewModel(
          titleWidget: AnimatedTextKit(
            isRepeatingAnimation: false,
            animatedTexts: [
              FadeAnimatedText(
                'Enfo',
                textAlign: TextAlign.center,
                duration: const Duration(seconds: 5),
                textStyle: const TextStyle(
                  fontSize: 120,
                ),
              ),
            ],
            onFinished: () {
              setState(() {
                _showDescription = true;
              });
            },
          ),
          bodyWidget: _showDescription
              ? AnimatedTextKit(
                  isRepeatingAnimation: false,
                  pause: const Duration(seconds: 3),
                  animatedTexts: [
                    TyperAnimatedText(
                      'Maximize your productivity with style and without distractions.',
                      textAlign: TextAlign.center,
                      textStyle: const TextStyle(
                        fontSize: 32,
                      ),
                      speed: const Duration(milliseconds: 70),
                    ),
                    TyperAnimatedText(
                      'Enfo is based on the Pomodoro system. \n\n Work for 25 minutes and rest for 5 minutes.',
                      textAlign: TextAlign.center,
                      textStyle: const TextStyle(
                        fontSize: 32,
                      ),
                      speed: const Duration(milliseconds: 70),
                    ),
                  ],
                  onFinished: () async {
                    if (Platform.isWindows) {
                      windowManager.setAlwaysOnTop(false);
                    }

                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool('presentation', false);

                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const Home(
                          presentation: false,
                        ),
                        transitionDuration: const Duration(seconds: 1),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                )
              : const Center(),
          decoration: const PageDecoration(
            bodyAlignment: Alignment.center,
          ),
        ),
      ],
      showDoneButton: false,
      showNextButton: false,
      onDone: () {},
    );
  }
}
