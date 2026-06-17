import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Widgets/CalendarWidget.dart';
import 'package:muslim_proj/Widgets/HomeWidget.dart';
import 'package:muslim_proj/Widgets/QiblaWidget.dart';
import 'package:muslim_proj/Widgets/QuranWidget.dart';



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

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: 70, // Un peu plus haut pour le confort
      decoration: BoxDecoration(
        color: KBackgroundColor, // Fond blanc pur
        borderRadius: BorderRadius.circular(30), // Bords très arrondis
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 70, // Un peu plus haut pour le confort
        decoration: BoxDecoration(
          color: KPrimaryColor.withOpacity(.1), // Fond blanc pur
          borderRadius: BorderRadius.circular(30), // Bords très arrondis
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            menuItem(1, 'Home', _itemSelected == 1 ? "house-blank (2)" : "house-blank (1)"),
            menuItem(2, 'Quran', _itemSelected == 2 ? "quran-user (1)" : "quran-user"),
            menuItem(3, 'Qibla', _itemSelected == 3 ? "compass-alt (1)" : "compass-alt"),
            menuItem(4, 'Calendar', _itemSelected == 4 ? "calendar-day (3)" : "calendar-day (2)"),
          ],
        ),
      ),
    );
  }


  Widget menuItem(int id, String title, String icon) {
    bool isSelected = _itemSelected == id;

    return GestureDetector(
        onTap: ()async{
          _itemSelected = id;
          setState((){
            if(id == 1){
              currentPage = DashboardItems.Home;
              widget.updateTitle('Deen Muslim');
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
              widget.updateContainer(HijriCalendarWidget(), id);
            }
          });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          // Si sélectionné, on crée une petite pilule de fond
          color: isSelected ? KPrimaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              "assets/icons/$icon.svg",
              colorFilter: ColorFilter.mode(
                isSelected ? KPrimaryColor : KPrimaryColor.withOpacity(0.5),
                BlendMode.srcIn,
              ),
              height: 24,
            ),
            if (isSelected) // Optionnel : afficher un petit point sous l'icône
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 4,
                width: 4,
                decoration: BoxDecoration(
                  color: KPrimaryColor,
                  shape: BoxShape.circle,
                ),
              )
          ],
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