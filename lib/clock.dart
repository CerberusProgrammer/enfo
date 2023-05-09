import 'dart:io';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:local_notifier/local_notifier.dart';

class Clock extends StatefulWidget {
  final CountDownController controller;
  final int time;
  final bool alarm;

  const Clock({
    super.key,
    required this.controller,
    required this.time,
    required this.alarm,
  });

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  bool rest = false;
  int time = 1500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: Material(
            clipBehavior: Clip.hardEdge,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () {
                if (widget.controller.isStarted) {
                  if (widget.controller.isPaused) {
                    widget.controller.resume();
                  } else {
                    setState(() {
                      widget.controller.pause();
                    });
                  }
                } else {
                  widget.controller.start();
                }
              },
              onLongPress: () {
                setState(() {
                  widget.controller.reset();
                });
              },
              child: CircularCountDownTimer(
                duration: time,
                initialDuration: 0,
                controller: widget.controller,
                width: constraints.maxWidth / 1.2,
                height: constraints.maxHeight / 1.2,
                ringColor: Theme.of(context).colorScheme.primary.withAlpha(80),
                ringGradient: null,
                fillColor: Theme.of(context).colorScheme.primary.withAlpha(180),
                fillGradient: null,
                backgroundColor: Theme.of(context).colorScheme.primary,
                backgroundGradient: null,
                strokeWidth: 100.0,
                strokeCap: StrokeCap.butt,
                textStyle: TextStyle(
                  fontSize: constraints.maxWidth < 300 ? 18 : 33.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textFormat: CountdownTextFormat.MM_SS,
                isReverse: true,
                isReverseAnimation: false,
                isTimerTextShown: true,
                autoStart: false,
                onStart: () {},
                onComplete: () {
                  if (Platform.isWindows) {
                    print('windows');
                  } else if (Platform.isAndroid) {
                    print('android');
                  }

                  if (rest) {
                    rest = false;
                    setState(() {
                      time = 25 * 60;
                      widget.controller.restart(duration: time);
                      widget.controller.pause();
                    });
                  } else {
                    rest = true;
                    setState(() {
                      time = 5 * 60;
                      widget.controller.restart(duration: time);
                      widget.controller.pause();
                    });
                  }
                },
                onChange: (String timeStamp) {},
                timeFormatterFunction: (defaultFormatterFunction, duration) {
                  if (widget.controller.isPaused) {
                    return 'Paused';
                  }

                  return Function.apply(
                    defaultFormatterFunction,
                    [duration],
                  );
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
