import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:muslim_proj/Constants.dart';


class ScrollConfig extends StatefulWidget {
  const ScrollConfig({super.key});

  @override
  State<ScrollConfig> createState() => _ScrollConfigState();
}

class _ScrollConfigState extends State<ScrollConfig> {


  bool autoScroll = false;
  var box = Hive.box('muslim_proj');

  int scrollValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    autoScroll = box.get("autoScroll") ?? false;
    scrollValue = box.get("scrollValue") ?? 0;
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Auto Scroll',
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),


              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                    color: KPrimaryColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(8)
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          autoScroll = true;
                          box.put("autoScroll", autoScroll);
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: autoScroll ? KPrimaryColor : Colors.transparent
                        ),
                        width: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'ON',
                            style: GoogleFonts.beVietnamPro(
                                color: autoScroll ? Colors.white :  KPrimaryColor,
                                fontWeight: autoScroll ? FontWeight.w600 : FontWeight.w500
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 2),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          autoScroll = false;
                          box.put("autoScroll", autoScroll);
                        });

                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                            color: !autoScroll ? KPrimaryColor.withOpacity(.8) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'OFF',
                            style: GoogleFonts.beVietnamPro(
                                color: !autoScroll ? Colors.white : KPrimaryColor,
                                fontWeight: !autoScroll ? FontWeight.w600 : FontWeight.w500
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          if(autoScroll == true)
            SizedBox(height: 16),

          if(autoScroll == true)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Vitesse',
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),


              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                    color: KPrimaryColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(8)
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        if(scrollValue > 0){
                          setState(() {
                            scrollValue = scrollValue - 1;
                            box.put("scrollValue", scrollValue);
                          });
                        }
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0 , vertical: 4),
                          child: Text(
                            '-',
                            style: GoogleFonts.beVietnamPro(
                                color: scrollValue == 0 ? Colors.grey : KPrimaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 2),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0 , vertical: 4),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Text(
                          scrollValue.toString(),
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 18,
                            color: KPrimaryColor,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 2),
                    GestureDetector(
                      onTap: (){
                        if(scrollValue < 3){
                          setState(() {
                            scrollValue = scrollValue + 1;
                            box.put("scrollValue", scrollValue);
                          });
                        }
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0 , vertical: 4),
                          child: Text(
                            '+',
                            style: GoogleFonts.beVietnamPro(
                                color: scrollValue == 3 ? Colors.grey : KPrimaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],

      ),

    );
  }
}
