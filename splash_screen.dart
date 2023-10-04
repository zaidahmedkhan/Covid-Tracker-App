import 'dart:async';
import 'dart:ffi';

import 'package:covid_tracker/view/world_stats.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 5), vsync: this)
        ..repeat();
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void initState() {
    super.initState();

    Timer(
        const Duration(seconds: 8),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => WorldStats())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder(
                animation: _controller,
                child: Container(
                  height: 200,
                  width: 200,
                  child: const Center(
                    child: Image(
                        image: NetworkImage(
                            "https://github.com/axiftaj/Flutter-Covid-19-Tracker-App-Tutorials/blob/main/images/virus.png?raw=true")),
                  ),
                ),
                builder: (BuildContext context, Widget? child) {
                  return Transform.rotate(
                    angle: _controller.value * 2.0 * math.pi,
                    child: child,
                  );
                }),
            SizedBox(height: MediaQuery.of(context).size.height * .08),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Covid-19 \n Tracker App",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                // color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
