import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  final CountDownController controller;
  final int time;

  const Clock({
    super.key,
    required this.controller,
    required this.time,
  });

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  bool isTimer = false;

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
                    widget.controller.pause();
                  }
                } else {
                  widget.controller.start();
                }
              },
              onLongPress: () {
                widget.controller.restart();
              },
              child: CircularCountDownTimer(
                duration: widget.time,
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
                onStart: () {
                  setState(() {
                    isTimer = true;
                  });
                },
                onComplete: () {},
                onChange: (String timeStamp) {},
                timeFormatterFunction: (defaultFormatterFunction, duration) {
                  if (!widget.controller.isStarted) {
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
        );
      }),
    );
  }
}
