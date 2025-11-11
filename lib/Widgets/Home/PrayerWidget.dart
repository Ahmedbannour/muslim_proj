import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muslim_proj/Constants.dart';




class PrayerWidget extends StatefulWidget {
  const PrayerWidget({super.key});

  @override
  State<PrayerWidget> createState() => _PrayerWidgetState();
}

class _PrayerWidgetState extends State<PrayerWidget> {





  List<Map<String, dynamic>> prayers = [
    {
      "label" : "Fajer",
      "time" : "05:36",
      "icon" : "cloud-sun"
    },
    {
      "label" : "Dhuhr",
      "time" : "12:25",
      "icon" : "brightness"
    },
    {
      "label" : "Asr",
      "time" : "16:32",
      "icon" : "cloud-sun"
    },
    {
      "label" : "Magrib",
      "time" : "18:36",
      "icon" : "moon"
    },
    {
      "label" : "Fajer",
      "time" : "19:42",
      "icon" : "moon-stars"
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Container(
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Prayer Time" ,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: prayers.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context , index){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: KPrimaryColor.withOpacity(.1),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/${prayers[index]['icon']}.svg',
                              color: Color(0xFFFF7440),
                              fit: BoxFit.contain,
                              height: 24,
                              alignment: Alignment.center,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                            ),

                            SizedBox(height: 8),

                            Text(
                              prayers[index]['label'],

                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),


                            SizedBox(height: 8),


                            Text(
                              prayers[index]['time'],

                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )
    );
  }
}
