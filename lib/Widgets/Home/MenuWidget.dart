import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muslim_proj/Constants.dart';


class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key});

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {

  List<Map<String,dynamic>> items = [
    {
      "name" : "Reminder",
      "icon" : "alarm-clock",
      "container" : Container()
    },
    {
      "name" : "Memorize",
      "icon" : "lightbulb-on",
      "container" : Container()
    },
    {
      "name" : "Ruqiyah",
      "icon" : "bong",
      "container" : Container()
    },
    {
      "name" : "Dua Q&A",
      "icon" : "comment",
      "container" : Container()
    },
    {
      "name" : "Books",
      "icon" : "book-open-cover",
      "container" : Container()
    },
    {
      "name" : "Donate",
      "icon" : "gift",
      "container" : Container()
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0 , vertical: 8),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  KPrimaryColor.withOpacity(.05), // orange (centre)
                  KPrimaryColor.withOpacity(.1)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
            ),
            borderRadius: BorderRadius.circular(16)
        ),

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // number of columns
                crossAxisSpacing: 8, // horizontal space
                mainAxisSpacing: 24, // vertical space
                childAspectRatio: 0.8
            ),
            itemBuilder: (context , index){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/${items[index]['icon']}.svg',
                    color: Color(0xFF864A15),
                    fit: BoxFit.contain,
                    height: 24,
                    alignment: Alignment.center,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      items[index]['name'],
                      style: TextStyle(
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  )
                ],
              );
            },

          ),
        ),
      ),
    );
  }
}
