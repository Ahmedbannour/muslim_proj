import 'package:flutter/material.dart';


class QuranWidget extends StatefulWidget {
  const QuranWidget({super.key});

  @override
  State<QuranWidget> createState() => _QuranWidgetState();
}

class _QuranWidgetState extends State<QuranWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
          "Quran widget"
      ),
    );
  }
}
