import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:intl/intl.dart';



class CoverWidget extends StatefulWidget {
  const CoverWidget({super.key});

  @override
  State<CoverWidget> createState() => _CoverWidgetState();
}

class _CoverWidgetState extends State<CoverWidget> {

  late Timer _timer; // pour la mise à jour automatique
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    // Met à jour chaque seconde
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // toujours annuler le timer quand le widget se détruit
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        //background
        Positioned(
          top: 0,
          right: 0,
          bottom: 10,
          left: 0,
          child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color(0xffdd8508).withOpacity(.9), // orange (centre)
                    KBackgroundColor, // jaune clair vers blanc (extérieur)
                  ],
                  center: Alignment.bottomCenter,
                  radius: 0.8, // contrôle la taille du cercle
                ),
              )
          ),
        ),

        //Hour Widget
        Positioned(
          bottom: 60,
          right: 1,
          left: 0,
          top: 0,
          child: Row(
            children: [
              // Partie heures
              Expanded(
                child: Text(
                  getHours(), // ex: "12"
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF864A15),
                    fontSize: 62,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),


              // Les deux points (toujours centré)
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Text(
                    ":",
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF864A15),
                      fontSize: 62,
                    ),
                  ),
                ),
              ),



              // Partie minutes
              Expanded(
                child: Text(
                  getMinutes(), // ex: "34"
                  // "05",
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF864A15),
                    fontSize: 62,
                  ),
                ),
              ),
            ],
          ),
        ),

        // cover image
        Positioned(
          bottom: 16,
          right: 0,
          left: 0,
          child: Image.asset(
            "assets/images/cover2.png",
            color: Color(0xFFFBE3C0),
            // fit: BoxFit.contain,
          ),
        ),

        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xFFFCE5C1), // orange (centre)
                      Color(0xFFFCE5C1), // orange (centre)
                      KBackgroundColor, // jaune clair vers blanc (extérieur)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                )
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                            "RAMAINING",
                            style: GoogleFonts.rubik(

                            )
                        ),
                      ),


                      Container(
                        child: Text(
                            "Maghrib 0:53:30",
                            style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w500
                            )
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 4,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color(0xffdd8508).withOpacity(.2),
                        borderRadius: BorderRadius.circular(8)
                    ),

                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                            "2 Juin 2025",
                            style: GoogleFonts.rubik(

                            )
                        ),
                      ),


                      Container(
                        child: Text(
                            "Monastir , Tunisia",
                            style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w500
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),


      ],
    );
  }


  String getHours() => _currentTime.hour.toString().padLeft(2, '0');

  String getMinutes() => _currentTime.minute.toString().padLeft(2, '0');

  String getActualTime() => DateFormat.Hm().format(_currentTime);
}
