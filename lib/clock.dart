import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

class Clock extends StatelessWidget {
  final CountDownController controller;

  const Clock({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Material(
          clipBehavior: Clip.hardEdge,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: () {
              controller.start();
            },
            child: CircularCountDownTimer(
              duration: 100,
              initialDuration: 0,
              controller: controller,
              width: 300,
              height: 300,
              ringColor: Theme.of(context).colorScheme.primary.withAlpha(80),
              ringGradient: null,
              fillColor: Theme.of(context).colorScheme.primary.withAlpha(180),
              fillGradient: null,
              backgroundColor: Theme.of(context).colorScheme.primary,
              backgroundGradient: null,
              strokeWidth: 20.0,
              strokeCap: StrokeCap.round,
              textStyle: const TextStyle(
                fontSize: 33.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textFormat: CountdownTextFormat.MM_SS,
              isReverse: false,
              isReverseAnimation: false,
              isTimerTextShown: true,
              autoStart: false,
              onStart: () {
                debugPrint('Countdown Started');
              },
              onComplete: () {
                debugPrint('Countdown Ended');
              },
              onChange: (String timeStamp) {
                debugPrint('Countdown Changed $timeStamp');
              },
              timeFormatterFunction: (defaultFormatterFunction, duration) {
                if (!controller.isStarted) {
                  return "Start";
                } else {
                  return Function.apply(
                    defaultFormatterFunction,
                    [duration],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
