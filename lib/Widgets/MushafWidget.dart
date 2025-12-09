import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Services/QuranService.dart';
import 'package:muslim_proj/Widgets/AyahDetails.dart';
import 'package:muslim_proj/Widgets/Quran/AudioReader.dart';
import 'package:provider/provider.dart';

class MushafWidget extends StatefulWidget {
  final Map<String, dynamic> surah;
  final int surahNumber;
  const MushafWidget({super.key, required this.surah, required this.surahNumber});

  @override
  State<MushafWidget> createState() => _MushafWidgetState();
}

class _MushafWidgetState extends State<MushafWidget> {
  late Map<String, dynamic> surah;
  late int surahNumber;
  late Future<Map<String, dynamic>> _getSurahDetails;
  late Future<File> _getSurahAudio;
  final List<TapGestureRecognizer> _tapRecognizers = [];

  @override
  void initState() {
    super.initState();
    surah = widget.surah;
    surahNumber = widget.surahNumber;
    _getSurahDetails = getSurahDetails(surahNumber);
    _getSurahAudio = getSurahAudio(surahNumber);
  }

  @override
  void didUpdateWidget(covariant MushafWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (surahNumber != widget.surahNumber) surahNumber = widget.surahNumber;
    if (surah != widget.surah) surah = widget.surah;
  }

  @override
  void dispose() {
    for (final r in _tapRecognizers) {
      r.dispose();
    }
    _tapRecognizers.clear();
    super.dispose();
  }

  // Nettoyage helpers
  void _clearRecognizers() {
    for (final r in _tapRecognizers) r.dispose();
    _tapRecognizers.clear();
  }

  String _cleanUnicodeArabic(String input) {
    // keep Arabic letters, tashkeel and a few Quranic signs, spaces
    return input.replaceAll(RegExp(r'[^\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF\sًٌٍَُِّْۖۚۛۗ]'), '').trim();
  }

  String _toArabicIndic(int number) {
    const map = {
      '0': '٠',
      '1': '١',
      '2': '٢',
      '3': '٣',
      '4': '٤',
      '5': '٥',
      '6': '٦',
      '7': '٧',
      '8': '٨',
      '9': '٩',
    };
    return number.toString().split('').map((d) => map[d] ?? d).join();
  }

  // affiche un bottom sheet avec le texte de l'ayah (responsive)
  void _showAyahSheet(BuildContext ctx, int ayahNum, String text) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      barrierColor: KPrimaryColor.withOpacity(.2),
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return ConstrainedBox(
            constraints:  BoxConstraints(
              maxHeight: (3 / 4) * MediaQuery.of(context).size.height,
            ),
            child: AyahDetails(oldContext: ctx,surah: surah , ayahNum: ayahNum , text: text,toArabicIndic: _toArabicIndic,)
        );
      },
    );
  }

  Future<Map<String, dynamic>> getSurahDetails(int surahNumber) async {
    return await Provider.of<QuranService>(context, listen: false).getSurahDetails(surahNumber);
  }


  Future<File> getSurahAudio(int surahNumber) async {
    return await Provider.of<QuranService>(context, listen: false).getSurahAudio(surahNumber);
  }

  @override
  Widget build(BuildContext context) {
    // responsiveness base font
    final Size media = MediaQuery.of(context).size;
    final double baseFont = (media.width / 16).clamp(20.0, 36.0);

    return Scaffold(
      backgroundColor: KBackgroundColor,
      appBar: AppBar(
        backgroundColor: KBackgroundColor,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        surfaceTintColor: KBackgroundColor,
        centerTitle: true,
        elevation: 5,
        leading: Container(
          margin: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: KPrimaryColor.withOpacity(0.05),
          ),
          child: IconButton(
            icon: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: SvgPicture.asset(
                "assets/icons/angle-left (1).svg",
                color: KPrimaryColor,
                width: 15,
                height: 15,
                excludeFromSemantics: true,
                allowDrawingOutsideViewBox: true,
                matchTextDirection: true,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text(
          "Quran",
          style: GoogleFonts.beVietnamPro(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(shape: BoxShape.circle, color: KPrimaryColor.withOpacity(0.05)),
            child: IconButton(
              icon: const Icon(Icons.logout_outlined, color: KPrimaryColor),
              onPressed: () {},
            ),
          )
        ],
      ),


      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _getSurahDetails,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
        
            final quran = snapshot.data!;
            final surahDetails = quran['data'] as Map<String, dynamic>;
            final List<dynamic> ayahsRaw = surahDetails['ayahs'] as List<dynamic>;
        
            // cleaning basmallah & invalid chars
            final String basmallah = "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ";
            final String firstRaw = ayahsRaw.isNotEmpty ? ayahsRaw[0]['text'].toString() : '';
            final String cleanedFirstRaw = _cleanUnicodeArabic(firstRaw);
            final bool hasBasmallah = cleanedFirstRaw.startsWith(basmallah);
            final String onlyBasmallah = hasBasmallah ? basmallah : '';
            final String cleanedFirstAyah = hasBasmallah ? cleanedFirstRaw.replaceFirst(basmallah, '').trim() : cleanedFirstRaw;
        
            // clear previous recognizers to avoid leaks / duplicates
            _clearRecognizers();
        
            // build spans (TextSpan + WidgetSpan for indicator)
            final List<InlineSpan> spans = [];
        
            for (int i = 0; i < ayahsRaw.length; i++) {
              final Map<String, dynamic> ay = ayahsRaw[i] as Map<String, dynamic>;
              final int ayahNum = ay['numberInSurah'] is int ? ay['numberInSurah'] as int : int.parse(ay['numberInSurah'].toString());
              // pick text, clean invalid chars
              final String rawText = (i == 0 ? cleanedFirstAyah : ay['text'].toString());
              final String text = _cleanUnicodeArabic(rawText);
        
              // create recognizer and keep it for disposal
              final recognizer = TapGestureRecognizer()
                ..onTap = () {
                  // open bottom sheet with ayah
                  _showAyahSheet(context, ayahNum, text);
        
                };
              _tapRecognizers.add(recognizer);
        
              // add the ayah text as TextSpan (clickable)
              spans.add(
                TextSpan(
                  text: text, // add space so indicator is separated but inline
                  style: TextStyle(
                    fontFamily: 'UthmanicHafs',
                    fontSize: baseFont,
                    fontWeight: FontWeight.bold,
                    color: KPrimaryColor,
                    height: 1.6,
                  ),
                  recognizer: recognizer,
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
                          _toArabicIndic(ayahNum),
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
        
            // build final UI using ListView for smooth scroll
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: 80,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // header card
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(color: KPrimaryColor.withOpacity(.05), borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              surah['englishName'] ?? '',
                              style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold, fontSize: 28, color: KPrimaryColor),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
        
                                Text(
                                  surah['englishNameTranslation'],
                                  style: GoogleFonts.beVietnamPro(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
        
                                SizedBox(width: 8),
        
                                Container(
                                  height: 6,
                                  width: 6,
                                  decoration: BoxDecoration(
                                      color: Color(0xf736000000),
                                      shape: BoxShape.circle
                                  ),
                                ),
        
        
                                SizedBox(width: 8),
                                Text(
                                  "${surah['numberOfAyahs']} Ayahs",
                                  style: GoogleFonts.beVietnamPro(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w400
                                  ),
                                )
                              ],
                            ),
        
                            const SizedBox(height: 12),
                            if (onlyBasmallah.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  onlyBasmallah,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      fontFamily: 'HafsNastaleeq_Ver10',
                                      fontSize: baseFont * 1.4,
                                      fontWeight: FontWeight.bold,
                                      color: KPrimaryColor
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
        
                      const SizedBox(height: 18),
        
                      // the mushaf text (single Text.rich)
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text.rich(
                          TextSpan(children: spans),
                          textAlign: TextAlign.justify,
                        ),
                      ),
        
                      // spacing so bottom button doesn't overlap content
                      SizedBox(height: media.height * 0.12),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: FutureBuilder(
                    future: _getSurahAudio,
                    builder: (context , snapshot) {
                      if(snapshot.hasError){
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }else if(snapshot.hasData){
                        return AudioReader(url: "https://cdn.islamic.network/quran/audio/128/ar.ahmedajamy/294.mp3");
                      }

                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
