import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Widgets/Dashboard/DashboardMenu.dart';
import 'package:muslim_proj/Widgets/HomeWidget.dart';
import 'package:permission_handler/permission_handler.dart';



class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}


class _DashboardWidgetState extends State<DashboardWidget> {
  late Widget _container;
  String _title = "Map";
  late int itemSalected;
  bool _hasPermissions = false;

  @override
  void initState() {
    super.initState();

    _fetchPermissionStatus();
    _container = HomeWidget();
    itemSalected = 1;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              bottom: 60,
              left: 0,
              child: _container,
            ),

            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 60,
                child: DashboardMenu(
                  itemSalected : itemSalected,
                  updateContainer: (Widget container , int newItemSelected){
                    setState(() {
                      _container = container;
                      itemSalected = newItemSelected;
                    });
                  },

                  updateTitle: (String title){
                    setState(() {
                      _title = title;
                    });
                  },
                ),
              ),
            ),

            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: _title == "Calendrier" ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _title,
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 22,
                          fontWeight: FontWeight.w500
                      ),
                    ),

                    GestureDetector(
                      onTap: (){
                        print('open search');
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        height: 40,
                        width: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            "assets/icons/search.svg",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ) :  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        print('open Drawer');
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        height: 40,
                        width: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            "assets/icons/menu-burger.svg",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),



                    Text(
                      _title,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                      ),
                    ),

                    GestureDetector(
                      onTap: (){
                        print('open search');
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        height: 40,
                        width: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            "assets/icons/search.svg",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        )
      )
    );
  }


  Widget _buildPermissionSheet() {
    return Center(
      child: ElevatedButton(
        child: const Text('Request Permissions'),
        onPressed: () {
          Permission.locationWhenInUse.request().then((ignored) {
            _fetchPermissionStatus();
          });
        },
      ),
    );
  }

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((status) {
      if (mounted) {
        setState(() => _hasPermissions = status == PermissionStatus.granted);
      }
    });
  }

}

