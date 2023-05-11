import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'dart:html' as web;

class ClockWeb extends StatefulWidget {
  final CountDownController controller;
  final String permission;
  final int time;
  final bool notification;
  final bool mode;

  const ClockWeb({
    super.key,
    required this.controller,
    required this.time,
    required this.notification,
    required this.mode,
    required this.permission,
  });

  @override
  State<StatefulWidget> createState() => _ClockWeb();
}

class _ClockWeb extends State<ClockWeb> {
  bool rest = false;
  int time = 1500;

  void showNotification(
    String permission, {
    String title = "",
    String body = "",
  }) async {
    if (permission == 'granted') {
      web.Notification(
        title,
        body: body,
      );
    }
  }

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
                  fontSize: constraints.maxWidth > constraints.maxHeight
                      ? constraints.maxHeight / 6
                      : constraints.maxWidth / 6,
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
                  if (rest) {
                    rest = false;

                    if (widget.notification) {
                      showNotification(
                        widget.permission,
                        title: "Time to work",
                        body: "Let's continue with the work!",
                      );
                    }

                    setState(() {
                      time = 25 * 60;
                      widget.controller.restart(duration: time);
                      widget.controller.pause();
                    });
                  } else {
                    rest = true;

                    if (widget.notification) {
                      showNotification(
                        widget.permission,
                        title: "Time to rest",
                        body: "Take a break.",
                      );
                    }

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

                  if (widget.mode) {
                    if (rest) {
                      return 'Relax';
                    }
                    return 'Focus';
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
