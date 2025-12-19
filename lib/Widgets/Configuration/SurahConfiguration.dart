import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Services/QuranService.dart';
import 'package:provider/provider.dart';



class SurahConfiguration extends StatefulWidget {
  final Map<dynamic , dynamic> surah;
  final int index;


  const SurahConfiguration({super.key, required this.surah , required this.index});
  @override
  State<SurahConfiguration> createState() => _SurahConfigurationState();
}

class _SurahConfigurationState extends State<SurahConfiguration> {
  late Map<dynamic , dynamic> surah;
  late int index;
  var box = Hive.box('muslim_proj');
  bool isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    surah = widget.surah;
    index = widget.index;
  }


  @override
  void didUpdateWidget(covariant SurahConfiguration oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if(surah != widget.surah){
      surah = widget.surah;
    }
    if(index != widget.index){
      index = widget.index;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(color: KPrimaryColor.withOpacity(.05), borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    surah['englishName'] ?? '',
                    style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: KPrimaryColor
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        surah['englishNameTranslation'] +" - "+"${surah['numberOfAyahs']} Ayahs",
                        style: GoogleFonts.beVietnamPro(
                          color: Colors.black45,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ],
              ),
            ),


            SizedBox(height: 16),

            GestureDetector(
              onTap: ()async{
                print('download audio');

                Map<dynamic,dynamic> surahDetails = await Provider.of<QuranService>(context , listen: false).downlaodSurah(index +1);

                Map<dynamic, dynamic> oldDetails = Map<dynamic, dynamic>.from(box.get('surah_details') ?? {});
                print('oldQuranList : ${oldDetails.toString()}');


                print("surahDetails : $surahDetails");

                if(surahDetails['code'] != null && surahDetails['code'].toString() == "200" && surahDetails['status'] != null && surahDetails['status'].toString().toLowerCase() == "ok" && surahDetails['data'] != null){
                  oldDetails[surah['englishName'].toString()] = surahDetails['data'];


                  box.put('surah_details' , oldDetails);
                  print('oldDetails : $oldDetails');

                  Fluttertoast.showToast(
                    msg: 'Téléchargement terminer avec success',
                    toastLength: Toast.LENGTH_LONG,
                    webShowClose: true
                  );
                }else{
                  Fluttertoast.showToast(
                      msg: 'Désolé , un probleme d api',
                      toastLength: Toast.LENGTH_LONG,
                      webShowClose: true
                  );
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: KPrimaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Icon(
                        Icons.download_outlined,
                        color: Colors.white,
                      ),

                      SizedBox(width: 8),


                      Text(
                        'Télécharger',
                        style: GoogleFonts.beVietnamPro(
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        )
                      ),
                    ],
                  ),
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }
}
