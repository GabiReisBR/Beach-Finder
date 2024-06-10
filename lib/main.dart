import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'pages/welcome_page.dart';
import 'beach_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BeachProvider(),
      child: MaterialApp(
        title: 'Beach Finder',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WelcomePage(), // Define WelcomePage como a tela inicial
      ),
    );
  }
}
