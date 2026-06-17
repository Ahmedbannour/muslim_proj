import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Services/QuranService.dart';
import 'package:muslim_proj/Widgets/AyahDetails.dart';
import 'package:muslim_proj/Widgets/Configuration/ScrollConfig.dart';
import 'package:muslim_proj/Widgets/Quran/AudioReader.dart';
import 'package:provider/provider.dart';

class MushafWidget extends StatefulWidget {
  final Map<dynamic, dynamic> surah;
  final int surahNumber;
  const MushafWidget({super.key, required this.surah, required this.surahNumber});

  @override
  State<MushafWidget> createState() => _MushafWidgetState();
}

class _MushafWidgetState extends State<MushafWidget> {
  late Map<dynamic, dynamic> surah;
  late int surahNumber;
  late Future<Map<dynamic, dynamic>> _getSurahDetails;
  late Future<File> _getSurahAudio;
  final List<TapGestureRecognizer> _tapRecognizers = [];
  var box = Hive.box('muslim_proj');

  String? tajweedSurahId;
  final bool _isAutoScrolling = false;


  final ScrollController _controller = ScrollController();

  Timer? _autoScrollTimer;
  Timer? _resumeTimer;

  bool _userScrolling = false;
  late double _speed;


  void _startAutoScroll() {
    _autoScrollTimer?.cancel();

    _autoScrollTimer = Timer.periodic(
      const Duration(milliseconds: 16),
          (timer) {
        if (!_controller.hasClients) return;
        if (_userScrolling) return;

        final maxScroll = _controller.position.maxScrollExtent;
        final current = _controller.offset;

        if (current >= maxScroll) {
          timer.cancel();
        } else {
          _controller.jumpTo(current + _speed);
        }
      },
    );
  }

  void _onUserScroll() {
    _userScrolling = true;

    _resumeTimer?.cancel();
    _resumeTimer = Timer(const Duration(seconds: 2), () {
      _userScrolling = false;
    });
  }

  double getScrollSpeed(int level) {
    switch (level) {
      case 1:
        return 0.5;
      case 2:
        return 1.2;
      case 3:
        return 2.5;
      default:
        return 0.5;
    }
  }

  @override
  void initState() {
    super.initState();
    surah = widget.surah;
    surahNumber = widget.surahNumber;
    _getSurahDetails = getSurahDetails(surahNumber , surah);
    tajweedSurahId = box.get("tajweedSurahId");
    // _getSurahAudio = getSurahAudio(surahNumber);

    int scrollValue = box.get('scrollValue', defaultValue: 1);
    _speed = getScrollSpeed(scrollValue);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
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
    _autoScrollTimer?.cancel();
    _resumeTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  // Nettoyage helpers
  void _clearRecognizers() {
    for (final r in _tapRecognizers) {
      r.dispose();
    }
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
      backgroundColor: KBackgroundColor,
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

  Future<Map<String, dynamic>> getSurahDetails(int surahNumber , Map<dynamic,dynamic> surah) async {
    return await Provider.of<QuranService>(context, listen: false).getSurahDetails(surahNumber , surah);
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
          style: GoogleFonts.beVietnamPro(
              color: Colors.black,
              fontWeight: FontWeight.bold
          ),
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(shape: BoxShape.circle, color: KPrimaryColor.withOpacity(0.05)),
            child: IconButton(
              icon: const Icon(
                  Icons.swipe_vertical_outlined,
                  color: KPrimaryColor
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierColor: KPrimaryColor.withOpacity(0.2),
                    builder: (BuildContext context) =>
                        AlertDialog(
                            titlePadding: EdgeInsets.all(0),
                            surfaceTintColor: KBackgroundColor.withOpacity(0.2),
                            backgroundColor: KBackgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            title: Container(
                              decoration: BoxDecoration(
                                  color: KPrimaryColor,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      topLeft: Radius.circular(16)
                                  )
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [

                                    Icon(
                                      Icons.swipe_vertical_outlined,
                                      color: KBackgroundColor,
                                    ),

                                    SizedBox(
                                      width: 8,
                                    ),

                                    Expanded(
                                      child: Text(
                                        'Confirmation',
                                        style: GoogleFonts.beVietnamPro(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 22
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),

                                    SizedBox(width: 8),

                                    GestureDetector(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: KBackgroundColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            content: ScrollConfig()
                        )
                );
              },
            ),
          )
        ],
      ),

      body: SafeArea(
        child: FutureBuilder<Map<dynamic, dynamic>>(
          future: _getSurahDetails,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
        
            final quran = snapshot.data!;

            bool isConnected = true;

            if(quran['error'] != null && quran['error'].toString() == "1"){
              isConnected = false;
            }

            print('_getSurahDetails : $quran');


            if (quran['data']  != null){
              final surahDetails = quran['data'] as Map<dynamic, dynamic>;

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
                final Map<dynamic, dynamic> ay = ayahsRaw[i] as Map<dynamic, dynamic>;
                final int ayahNum = ay['numberInSurah'] is int ? ay['numberInSurah'] as int : int.parse(ay['numberInSurah'].toString());
                // pick text, clean invalid chars
                final String rawText = (i == 0 ? cleanedFirstAyah : ay['text'].toString());
                final String text = _cleanUnicodeArabic(rawText);

                // create recognizer and keep it for disposal
                final recognizer = TapGestureRecognizer()
                  ..onTap = () {
                    // open bottom sheet with ayah
                    if(isConnected){
                      _showAyahSheet(context, ayahNum, text);
                    }else{
                      Fluttertoast.showToast(
                        msg: 'ce service indisponible dans le mode hors ligne :/',
                        toastLength: Toast.LENGTH_LONG,
                      );
                    }

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
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is UserScrollNotification ||
                            notification is ScrollUpdateNotification) {
                          _onUserScroll();
                        }
                        return false;
                      },
                      child: ListView(
                        controller: _controller,
                        padding: const EdgeInsets.all(16),
                        children: [
                          // header card
                          GestureDetector(
                            onTap: (){
                              print('auto scroll : ${box.get('scrollValue')}');
                              _startAutoScroll();
                            },
                            child: AnimatedContainer(
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
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: isConnected == true ? AudioReader(url: "https://cdn.islamic.network/quran/audio-surah/128/${tajweedSurahId ?? "ar.alafasy"}/$surahNumber.mp3") : Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                    color: KPrimaryColor,
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'صَدَقَ ٱللّٰهُ ٱلْعَظِيمُ',
                                      style: TextStyle(
                                          fontFamily: 'UthmanicHafs',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 26
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }else{
              return Container(
                child: Center(
                  child: Text(
                    "data not found"
                  ),
                ),
              );
            }

          },
        ),
      ),
    );
  }
  Duration durationFromScrollValue(int value) {
    switch (value) {
      case 1: // lent
        return const Duration(milliseconds: 40);
      case 2: // normal
        return const Duration(milliseconds: 25);
      case 3: // rapide
        return const Duration(milliseconds: 12);
      default:
        return const Duration(milliseconds: 25);
    }
  }


}

enum ScrollSpeed { slow, normal, fast }

