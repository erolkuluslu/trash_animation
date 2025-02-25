import 'package:flutter/material.dart';
import 'package:trash_animation/card_hidden_animation_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      color: Colors.white,
      home: CardHiddenAnimationPage(),
    );
  }
}
