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

  late var currentPage;
  var box = Hive.box('muslim_proj');


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  void didUpdateWidget(covariant QuranContent oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);



  }


  @override
  Widget build(BuildContext context) {

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


              GestureDetector(
                onTap: (){
                  _showSurahInfoModal(context);
                },
                child: AnimatedContainer(
                    duration: Duration(
                        milliseconds: 200
                    ),
                    decoration: BoxDecoration(
                        color: KPrimaryColor.withOpacity(.2),
                        borderRadius: BorderRadius.circular(16)
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Padding(
                      padding: EdgeInsets.all(2),
                      child: SvgPicture.asset(
                        "assets/icons/exclamation.svg",
                        color: kPrimaryLight,
                      ),
                    )
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
                    children: [
                      Text(
                        item['englishName'],
                        style: GoogleFonts.beVietnamPro(
                          fontWeight: FontWeight.bold
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

                          Expanded(
                            child: Text(
                              "${item['numberOfAyahs']} Ayahs",
                              style: GoogleFonts.beVietnamPro(
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0,
                                color: Colors.black45
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),



                    ],
                  ),
                ),

                Text(
                  "${item['name']}",
                  style: TextStyle(
                    fontFamily: "Nabi_Quran_Font",
                    fontWeight: FontWeight.bold,
                    color: KPrimaryColor,
                    fontSize: 26
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
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



  void _showSurahInfoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSurahInfoModal(context),
    );
  }

  Widget _buildSurahInfoModal(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          Text(
            "Légende des Sourates",
            style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Comprendre les icônes affichées pour chaque sourate",
            style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.w400,
              fontSize: 13,
              color: Colors.black45,
            ),
          ),

          const SizedBox(height: 20),

          _legendItem(
            icon: "assets/icons/kaaba-1.svg",
            title: "Mecquoise (Meccan)",
            description: "Cette sourate a été révélée à La Mecque, généralement avant l'Hégire.",
          ),

          const SizedBox(height: 12),

          _legendItem(
            icon: "assets/icons/house-building.svg",
            title: "Médinoise (Medinan)",
            description: "Cette sourate a été révélée à Médine, généralement après l'Hégire.",
          ),
        ],
      ),
    );
  }

  Widget _legendItem({required String icon, required String title, required String description}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: KPrimaryColor.withOpacity(.05),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: KPrimaryColor.withOpacity(.12),
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(
                  icon,
                  color: KPrimaryColor,
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.5,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<List<Map<dynamic,dynamic>>> getQuranAll() async{
    return await Provider.of<QuranService>(context , listen: false).getQuranAll();
  }


}
