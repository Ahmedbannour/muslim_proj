import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Services/QuranService.dart';
import 'package:muslim_proj/Widgets/Quran/AudioReader.dart';
import 'package:provider/provider.dart';


class AyahDetails extends StatefulWidget {
  final BuildContext oldContext;
  final int ayahNum;
  final String text;
  final Map<dynamic, dynamic> surah;
  final Function(int) toArabicIndic;
  const AyahDetails({super.key, required this.ayahNum , required this.text , required this.oldContext , required this.surah , required this.toArabicIndic});

  @override
  State<AyahDetails> createState() => _AyahDetailsState();
}

class _AyahDetailsState extends State<AyahDetails> {


  late BuildContext oldContext;
  late int ayahNum;
  late String text;
  late Map<dynamic, dynamic> surah;

  final List<InlineSpan> spans = [];

  late Future<Map<dynamic , dynamic>> getAyahExpilic;

  late Future<Map<dynamic , dynamic>> _getAyahDetails;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    oldContext = widget.oldContext;
    ayahNum = widget.ayahNum;
    text = widget.text;
    surah = widget.surah;

    getAyahExpilic = getAyahExplic(ayahNum , surah);
    _getAyahDetails = getAyahDetails(surah , ayahNum);

    // add the ayah text as TextSpan (clickable)
    spans.add(
      TextSpan(
        text: text, // add space so indicator is separated but inline
        style: TextStyle(
          fontFamily: 'HafsNastaleeq_Ver10',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: KPrimaryColor,
          height: 1.6,
        ),
      ),
    );

    // add indicator widget inline (aligned to middle)
    spans.add(
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                "assets/icons/ayah.svg",
                width: 36,
                height: 36,
              ),
              Text(
                widget.toArabicIndic(ayahNum),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: KPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  @override
  void didUpdateWidget(covariant AyahDetails oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(oldContext != widget.oldContext){
      oldContext = widget.oldContext;
    }

    if(ayahNum != widget.ayahNum){
      ayahNum = widget.ayahNum;
    }

    if(text != widget.text){
      text = widget.text;
    }

    if(surah != widget.surah){
      surah = widget.surah;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future: _getAyahDetails,
          builder: (context,snapshot) {
            if(snapshot.hasData){
              final response = snapshot.data as Map<String, dynamic>;


              Map<String,dynamic> fullDataAudio = response['data'];

              print('audio : ${fullDataAudio['audio']}');
              return AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                    color: KPrimaryColor.withOpacity(.05),
                    borderRadius: BorderRadius.circular(32)
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(16)
                              ),
                              width: 80,
                              height: 6,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      bottom: 80,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [

                            SizedBox(height: 4),

                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text.rich(
                                  TextSpan(children: spans),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),


                            FutureBuilder(
                                future: getAyahExpilic,
                                builder: (context , snapshot) {
                                  if(snapshot.hasError){
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  }else if(snapshot.hasData){
                                    final fullData = snapshot.data as Map<String, dynamic>;

                                    print("fullData: $fullData");


                                    Map<String,dynamic> explic = fullData['data'];

                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: AnimatedContainer(
                                              duration: Duration(milliseconds: 200),
                                              decoration: BoxDecoration(
                                                  color: KPrimaryColor.withOpacity(.08),
                                                  borderRadius: BorderRadius.circular(16)
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      ": تفسير",
                                                      style: GoogleFonts.zain(
                                                        fontSize: 24,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.grey,
                                                        height: 1.6,
                                                      ),
                                                      textDirection: TextDirection.ltr,
                                                    ),

                                                    SizedBox(height: 4),

                                                    AnimatedContainer(
                                                      duration: Duration(milliseconds: 200),
                                                      decoration: BoxDecoration(

                                                      ),

                                                      child: Text(
                                                        explic['text'].toString(),
                                                        style: GoogleFonts.zain(

                                                        ),
                                                        textDirection: TextDirection.rtl,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                            )




                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: AudioReader(url: fullDataAudio['audio'] ?? fullDataAudio['audioSecondary'][0])
                    )
                  ],
                ),
              );
            }else if(snapshot.hasError){
              return Center(
                child: Text(
                  "error : ${snapshot.error}"
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }
      ),
    );
  }

  Future<Map<dynamic,dynamic>> getAyahExplic(int ayahNum , Map<dynamic , dynamic> surah)async{
    return await Provider.of<QuranService>(context , listen: false).getAyahExplic(ayahNum, surah);
  }


  Future<Map<dynamic,dynamic>> getAyahDetails(Map<dynamic , dynamic> surah,int ayahNum )async{
    return await Provider.of<QuranService>(context , listen: false).getAyahDetails(ayahNum, surah);
  }
}
