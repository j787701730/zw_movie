import 'package:flutter/material.dart';
import 'splashPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zw_movie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, platform: TargetPlatform.iOS),
      home: SplashPage(),
    );
  }
}
