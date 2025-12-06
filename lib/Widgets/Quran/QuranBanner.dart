import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:muslim_proj/Constants.dart';



class QuranBanner extends StatefulWidget {
  const QuranBanner({super.key});

  @override
  State<QuranBanner> createState() => _QuranBannerState();
}

class _QuranBannerState extends State<QuranBanner> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(16)
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.bottomRight,
                    radius: 4.3,
                    colors: [
                      Color(0xffdd8508).withOpacity(.9),
                      KBackgroundColor,
                      KBackgroundColor,
                    ]
                )
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    bottom: 0,
                    top: -20,
                    child: Image.asset(
                      "assets/images/cover3.png",
                      color: Color(0xFFFBE3C0),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    top: 0,
                    left: 0,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                "Last Read",
                                style: GoogleFonts.beVietnamPro(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20
                                ),
                              ),
                            ),

                            SizedBox(height: 4),


                            // if arabic => "elMessiri" else zain
                            Text(
                              "Al-Fatiah",
                              style: GoogleFonts.beVietnamPro(
                                fontWeight: FontWeight.w800,
                                fontSize: 40,
                                color: Color(0xFF864A15),
                              ),
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),


                            Container(
                              child: Text(
                                "Ayah N°1",
                                style: GoogleFonts.beVietnamPro(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18
                                ),
                              ),
                            ),
                          ],

                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
