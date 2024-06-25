import 'package:demowebsocket/home.dart';
import 'package:flutter/material.dart';

void main(List<String> arguments) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Web Socket',
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.blueGrey,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blueGrey,
            )),
        home: HomePage());
  }
}
