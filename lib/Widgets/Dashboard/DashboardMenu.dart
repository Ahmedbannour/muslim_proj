import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Widgets/CalendarWidget.dart';
import 'package:muslim_proj/Widgets/HomeWidget.dart';
import 'package:muslim_proj/Widgets/QiblaWidget.dart';
import 'package:muslim_proj/Widgets/QuranWidget.dart';
import 'package:muslim_proj/Widgets/TasbihWidget.dart';
import 'dart:math' as math;



class DashboardMenu extends StatefulWidget {
  final int itemSalected;
  final Function(Widget container , int itemSelected) updateContainer;
  final Function(String newTitle) updateTitle;
  const DashboardMenu({super.key , required this.itemSalected , required this.updateContainer , required this.updateTitle});


  @override
  State<DashboardMenu> createState() => _DashboardMenuState();
}

class _DashboardMenuState extends State<DashboardMenu> {

  late int _itemSelected;
  late var currentPage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _itemSelected = widget.itemSalected;


    if(_itemSelected == 1){
      currentPage = DashboardItems.Home;
    }else if(_itemSelected == 2){
      currentPage = DashboardItems.Quran;
    }else if(_itemSelected == 3){
      currentPage = DashboardItems.Qibla;
    }else if(_itemSelected == 4){
      currentPage = DashboardItems.Calendar;
    }


  }


  @override
  void didUpdateWidget(covariant DashboardMenu oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if(_itemSelected != widget.itemSalected){
      _itemSelected = widget.itemSalected;
    }

  }

  @override
  Widget build(BuildContext context) {

    if(_itemSelected == 1){
      currentPage = DashboardItems.Home;
    }else if(_itemSelected == 2){
      currentPage = DashboardItems.Quran;
    }else if(_itemSelected == 3){
      currentPage = DashboardItems.Qibla;
    }else if(_itemSelected == 4){
      currentPage = DashboardItems.Calendar;
    }

    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              topLeft: Radius.circular(16)
            ),
            color: KPrimaryColor.withOpacity(.2)
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: menuItem(1 , 'Home' , currentPage == DashboardItems.Home ? "house-blank (2)" : "house-blank (1)" , currentPage == DashboardItems.Home)
            ),

            Expanded(
                child: menuItem(2 , 'Quran' , currentPage == DashboardItems.Quran ? "quran-user (1)" : "quran-user" ,currentPage == DashboardItems.Quran)
            ),

            Expanded(
                child: menuItem(3 , 'Qibla' , currentPage == DashboardItems.Qibla ? "compass-alt (1)" : "compass-alt" , currentPage == DashboardItems.Qibla)
            ),

            Expanded(
                child: menuItem(4 , 'Calendar' , currentPage == DashboardItems.Calendar ? "calendar-day (3)" : "calendar-day (2)" ,currentPage == DashboardItems.Calendar)
            ),
          ],
        )
    );
  }


  Widget menuItem(int id , String title , String icon ,bool selected){
    return GestureDetector(
      onTap: ()async{
        _itemSelected = id;
        setState((){
          if(id == 1){
            currentPage = DashboardItems.Home;
            widget.updateTitle('Home');
            widget.updateContainer(HomeWidget() , id);
          }else if(id == 2){
            currentPage = DashboardItems.Quran;
            widget.updateTitle('Quran');
            widget.updateContainer(QuranWidget(), id);
          }else if(id == 3){
            currentPage = DashboardItems.Qibla;
            widget.updateTitle('Qibla');
            widget.updateContainer(StreamBuilder<CompassEvent>(
              stream: FlutterCompass.events,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error reading heading: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                double? direction = snapshot.data!.heading;

                // if direction is null, then device does not support this sensor
                // show error message
                if (direction == null) {
                  return const Center(
                    child: Text("Device does not have sensors !"),
                  );
                }

                return QiblaWidget();
              },
            ), id);
          }else if(id == 4){
            currentPage = DashboardItems.Calendar;
            widget.updateTitle('Calendrier');
            widget.updateContainer(CalendarWidget(), id);
          }
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
            color: _itemSelected == id ? KPrimaryColor : Colors.white,
            boxShadow: _itemSelected == id ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // couleur et transparence de l’ombre
                blurRadius: 10, // adoucissement de l’ombre
                offset: const Offset(0, 4), // position de l’ombre (x, y)
              ),
            ] : null
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            "assets/icons/$icon.svg",
            color : _itemSelected == id ? Colors.white : KPrimaryColor,
            fit: BoxFit.contain,
            alignment: Alignment.center,
            height: _itemSelected == id ? 24 : 28,
          ),
        ),


      ),
    );
  }
}


enum DashboardItems{
  Home,
  Quran,
  Qibla,
  Calendar,
  Tasbih

}