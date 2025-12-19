import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Services/QuranService.dart';
import 'package:muslim_proj/Widgets/ErrorApiWidget.dart';
import 'package:muslim_proj/Widgets/MushafWidget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';



class QuranContent extends StatefulWidget {
  final int filterQuranType;
  const QuranContent({super.key , required this.filterQuranType});

  @override
  State<QuranContent> createState() => _QuranContentState();
}

class _QuranContentState extends State<QuranContent> {

  late Future<List<Map<dynamic,dynamic>>> quranInfo = getQuranAll();

  late int filterQuranType;
  late var currentPage;
  var box = Hive.box('muslim_proj');


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterQuranType = 1;
    if(filterQuranType == 1){
      currentPage = QuranFilter.surah;
    }else if(filterQuranType == 2){
      currentPage = QuranFilter.juz;
    }else if(filterQuranType == 3){
      currentPage = QuranFilter.page;
    }
  }


  @override
  void didUpdateWidget(covariant QuranContent oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if(filterQuranType != widget.filterQuranType){
      filterQuranType = widget.filterQuranType;
    }

  }


  @override
  Widget build(BuildContext context) {


    if(filterQuranType == 1){
      currentPage = QuranFilter.surah;
    }else if(filterQuranType == 2){
      currentPage = QuranFilter.juz;
    }else if(filterQuranType == 3){
      currentPage = QuranFilter.page;
    }


    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(

          ),
          child: Row(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  decoration: BoxDecoration(

                  ),
                  child: Text(
                    "Al Quran",
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.w600,
                      fontSize: 26
                    ),
                  ),
                ),
              ),

              SizedBox(width: 8),


              AnimatedContainer(
                duration: Duration(
                  milliseconds: 200
                ),
                decoration: BoxDecoration(
                  color: KPrimaryColor.withOpacity(.2),
                  borderRadius: BorderRadius.circular(16)
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Row(
                  children: QuranFilter.values.map((filter) {
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          filterQuranType = filter.index + 1;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(
                            milliseconds: 200,
                        ),
                        decoration: BoxDecoration(
                          color: filterQuranType == filter.index + 1 ? KPrimaryColor.withOpacity(.2) : Colors.transparent,
                          borderRadius: BorderRadius.circular(16)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8 , vertical: 4),
                          child: Text(
                            filter.name.toString(),
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 14,
                                color: Colors.black54
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),


        
        Expanded(
          child: FutureBuilder(
            future: quranInfo,
            builder: (context , snapshot){

              if(snapshot.hasError){
                print('error quran : ${snapshot.error}');
                print('trace quran : ${snapshot.stackTrace}');
                return Container(
                  width: 80,
                  height: 80,
                  color: Colors.red,
                  child: Text(
                    snapshot.error.toString(),
                  ),
                );
              }else if (snapshot.hasData){
                final quran = snapshot.data as List<Map<dynamic, dynamic>>;

                print("final data : $quran");
                final List<Map<dynamic, dynamic>> oldQuranList = ((box.get('quranList') ?? []) as List<dynamic>).map((e) => Map<dynamic, dynamic>.from(e)).toList();


                if(quran.isNotEmpty && quran[0]['error'] != null && oldQuranList.isEmpty){
                  return ErrorApiWidget(text: "Probleme de connexion");
                }else if(oldQuranList.isNotEmpty){
                  return ListView.builder(
                    itemCount: oldQuranList.length,
                    itemBuilder: (context, index) {
                      return quranItem(oldQuranList[index] , index);
                    },
                  );
                }
                return ListView.builder(
                  itemCount: quran.length,
                  itemBuilder: (context, index) {
                    return quranItem(quran[index] , index);
                  },
                );
              }


              return ListView.builder(
                itemCount: 114,
                itemBuilder: (context, index) {
                  return quranShimmer();
                },
              );
            },
          ),
        )

      ],
    );
  }


  Widget quranItem (Map<dynamic,dynamic> item, int index){
    return GestureDetector(
      onTap: ()async{
        await Navigator.push(context, MaterialPageRoute(builder: (context) => MushafWidget(surah: item , surahNumber : index + 1)));
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
                    padding: EdgeInsets.all(16),
                    child: Text(
                      twoDigits(index+1).toString(),
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.bold,
                      ),
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
                        item['englishName'],
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
                              item['revelationType'].toString().toLowerCase() == "meccan" ? "assets/icons/kaaba-1.svg" : "assets/icons/house-building.svg",
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
                            "${item['numberOfAyahs']} Ayahs",
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

                Container(
                  child: Text(
                    "${item['name']}",
                    style: TextStyle(
                      fontFamily: "Nabi_Quran_Font",
                      fontWeight: FontWeight.bold,
                      color: KPrimaryColor,
                      fontSize: 26
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget quranShimmer (){
    return Shimmer.fromColors(
      baseColor: KPrimaryColor.withOpacity(0.03),
      highlightColor: KPrimaryColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16)
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 60,
            ),
          ),
        ),
      ),
    );
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');


  Future<List<Map<dynamic,dynamic>>> getQuranAll() async{
    return await Provider.of<QuranService>(context , listen: false).getQuranAll();
  }


}


enum QuranFilter{
  surah,
  juz,
  page
}