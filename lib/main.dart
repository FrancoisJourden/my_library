import 'package:flutter/material.dart';
import 'package:my_library/screens/book_screen.dart';
import 'package:my_library/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            // primarySwatch: Colors.blue,
            // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
            colorSchemeSeed: Colors.yellow,
            useMaterial3: true),
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.yellow,
            useMaterial3: true),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/book_screen': (context) => const BookScreen()
        });
  }
}
