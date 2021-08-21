

import 'package:dreuel_invoice/home_page.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(bodyText1: TextStyle(fontSize: 11)),
      fontFamily: 'Futura'
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: HomePage(),
        ),
      ),
    );
  }
}


