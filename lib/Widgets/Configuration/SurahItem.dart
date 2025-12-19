import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Widgets/Configuration/SurahConfiguration.dart';


class SurahItem extends StatefulWidget {
  final Map<dynamic , dynamic> surah;
  final int index;
  final Function(bool) updateSelectedItem;
  final bool isSelected;
  const SurahItem({super.key, required this.surah , required this.index , required this.updateSelectedItem , required this.isSelected});

  @override
  State<SurahItem> createState() => _SurahItemState();
}

class _SurahItemState extends State<SurahItem> {

  late Map<dynamic , dynamic> surah;
  late int index;
  late bool isSelected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    surah = widget.surah;
    index = widget.index;
    isSelected = widget.isSelected;
  }


  @override
  void didUpdateWidget(covariant SurahItem oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if(surah != widget.surah){
      surah = widget.surah;
    }
    if(index != widget.index){
      index = widget.index;
    }
    if(isSelected != widget.isSelected){
      isSelected = widget.isSelected;
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()async{
        showDialog(
            context: context,
            barrierColor: KPrimaryColor.withOpacity(0.2),
            useSafeArea: true,
            builder: (BuildContext context) => AlertDialog(
                titlePadding: EdgeInsets.all(0),
                backgroundColor: Colors.white,
                contentPadding: const EdgeInsets.all(0),
                actionsPadding: EdgeInsets.all(0),
                actions: null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                title: Container(
                  decoration: BoxDecoration(
                      color: KPrimaryColor,
                      borderRadius: BorderRadius.circular(16)
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.bookmark_border_outlined,
                          color: Colors.white,
                        ),
                        Text(
                          'Surah',
                          style: GoogleFonts.beVietnamPro(
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                content: SurahConfiguration(index: index,surah: surah,)
            )
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
              color: KPrimaryColor.withOpacity(.03),
              borderRadius: BorderRadius.circular(16)
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: KPrimaryColor.withOpacity(.1),
                      shape: BoxShape.circle
                  ),

                  clipBehavior: Clip.antiAliasWithSaveLayer,

                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Checkbox(
                      value: isSelected,
                      activeColor: KPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (value) {
                        widget.updateSelectedItem(value!);
                      },
                    ),
                  ),
                ),

                SizedBox(width: 8),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        surah['englishName'],
                        style: GoogleFonts.beVietnamPro(
                            fontWeight: FontWeight.bold
                        ),
                      ),



                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: SvgPicture.asset(
                              // "assets/icons/cabin.svg",
                              surah['revelationType'].toString().toLowerCase() == "meccan" ? "assets/icons/kaaba-1.svg" : "assets/icons/house-building.svg",
                              color: Colors.black45,
                              alignment: Alignment.center,
                              height: 16,
                              width: 16,
                              fit: BoxFit.contain,
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black45,
                                  shape: BoxShape.circle
                              ),
                              width: 4,
                              height: 4,
                            ),
                          ),

                          Text(
                            "${surah['numberOfAyahs']} Ayahs",
                            style: GoogleFonts.beVietnamPro(
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0,
                                color: Colors.black45
                            ),
                          ),
                        ],
                      ),



                    ],
                  ),
                ),

                AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                        color: KPrimaryColor.withOpacity(.1),
                        shape: BoxShape.circle
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.download_outlined,
                        color: KPrimaryColor,
                      ),
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');
}
