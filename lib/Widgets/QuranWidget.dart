import 'package:flutter/material.dart';
import 'package:muslim_proj/Widgets/Quran/QuranBanner.dart';
import 'package:muslim_proj/Widgets/Quran/QuranContent.dart';


class QuranWidget extends StatefulWidget {
  const QuranWidget({super.key});

  @override
  State<QuranWidget> createState() => _QuranWidgetState();
}


class _QuranWidgetState extends State<QuranWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),

          Expanded(
            flex : 1,
            child: QuranBanner(),
          ),

          SizedBox(height: 16),

          Expanded(
            flex: 3,
            child: QuranContent(filterQuranType: 1)
          ),

        ],
      ),
    );
  }

}
