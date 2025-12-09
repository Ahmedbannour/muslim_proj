import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Services/QuranService.dart';
import 'package:provider/provider.dart';


class AyahDetails extends StatefulWidget {
  final BuildContext oldContext;
  final int ayahNum;
  final String text;
  final Map<String, dynamic> surah;
  final Function(int) toArabicIndic;
  const AyahDetails({super.key, required this.ayahNum , required this.text , required this.oldContext , required this.surah , required this.toArabicIndic});

  @override
  State<AyahDetails> createState() => _AyahDetailsState();
}

class _AyahDetailsState extends State<AyahDetails> {


  late BuildContext oldContext;
  late int ayahNum;
  late String text;
  late Map<String, dynamic> surah;

  final List<InlineSpan> spans = [];

  late Future<Map<String , dynamic>> getAyahExpilic;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    oldContext = widget.oldContext;
    ayahNum = widget.ayahNum;
    text = widget.text;
    surah = widget.surah;

    getAyahExpilic = getAyahExplic(ayahNum , surah);

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
      child: SingleChildScrollView(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
              color: KPrimaryColor.withOpacity(.05),
              borderRadius: BorderRadius.circular(32)
          ),
          alignment: AlignmentDirectional.center,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(16)
                  ),
                  width: 80,
                  height: 6,
                ),
              ),
        
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
    );
  }

  Future<Map<String,dynamic>> getAyahExplic(int ayahNum , Map<String , dynamic> surah)async{
    return await Provider.of<QuranService>(context , listen: false).getAyahExplic(ayahNum, surah);
  }
}
