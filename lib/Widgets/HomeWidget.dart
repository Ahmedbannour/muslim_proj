import 'package:flutter/material.dart';
import 'package:muslim_proj/Widgets/Home/CoverWidget.dart';
import 'package:muslim_proj/Widgets/Home/MenuWidget.dart';
import 'package:muslim_proj/Widgets/Home/PrayerWidget.dart';


class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex : 2,
          child: CoverWidget(),
        ),

        Expanded(
          child: MenuWidget(),
        ),






        Expanded(
          child: PrayerWidget(),
        )
      ],
    );
  }



}
