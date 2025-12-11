import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Services/ConfigService.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';


class ConfigWidget extends StatefulWidget {
  const ConfigWidget({super.key});

  @override
  State<ConfigWidget> createState() => _ConfigWidgetState();
}

class _ConfigWidgetState extends State<ConfigWidget> {



  late Future<List<Map<String, dynamic>>> _getTafsirList = getTafsirList();
  late Future<List<Map<String, dynamic>>> _getTajweedAyahList = getTajweedAyahList();
  late List<Map<String, dynamic>> _getTajweedSurahList= [
    {
      "identifier": "ar.alafasy",
      "language": "ar",
      "name": "مشاري العفاسي",
      "englishName": "Alafasy",
      "format": "audio",
      "type": "versebyverse",
      "direction": null
    },
    {
      "identifier": "ar.alashryomran",
      "language": "ar",
      "name": "العشري عمران",
      "englishName": "Alashry omran",
      "format": "audio",
      "type": "versebyverse",
      "direction": null
    },

    {
      "identifier": "ar.alfatehmuhammadzubair",
      "language": "ar",
      "name": "الفاتح محمد الزبير",
      "englishName": "Al Fateh Muhammad Zubair",
      "format": "audio",
      "type": "versebyverse",
      "direction": null
    },

    {
      "identifier": "ar.alhusaynialazazi",
      "language": "ar",
      "name": "الحسيني العزازي",
      "englishName": "Al husayni al azazi",
      "format": "audio",
      "type": "versebyverse",
      "direction": null
    },

    {
      "identifier": "ar.aliabdurrahmanalhuthaify",
      "language": "ar",
      "name": "علي الحذيفي",
      "englishName": "Ali Bin Abdur Rahman Al Huthaify",
      "format": "audio",
      "type": "versebyverse",
      "direction": null
    },

    {
      "identifier": "ar.alzainmohamedahmed",
      "language": "ar",
      "name": "الزين محمد أحمد",
      "englishName": "Alzain Mohamed Ahmed",
      "format": "audio",
      "type": "versebyverse",
      "direction": null
    },



    {
      "identifier": "ar.azizalili",
      "language": "ar",
      "name": "عزيز عليلي",
      "englishName": "Aziz Alili",
      "format": "audio",
      "type": "versebyverse",
      "direction": null
    },


    {
      "identifier": "ar.bandarbalila",
      "language": "ar",
      "name": "بندر بليلة",
      "englishName": "Bandar Baleela",
      "format": "audio",
      "type": "versebyverse",
      "direction": null
    },
    {
      "identifier": "ar.darwishfarajdarwishalattar",
      "language": "ar",
      "name": "Darwish Faraj Darwish Al Attar",
      "englishName": "Darwish Faraj Darwish Al Attar",
      "format": "audio",
      "type": "versebyverse",
      "direction": null
    },

    {
      "identifier": "ar.faresabbad",
      "language": "ar",
      "name": "فارس عباد",
      "englishName": "Fares Abbad",
      "format": "audio",
      "type": "versebyverse",
      "direction": null
    },
    {
      "identifier": "ar.haniarrifai",
      "language": "ar",
      "name": "هاني الرفاعي",
      "englishName": "Hani Ar Rifai",
      "format": "audio",
      "type": "versebyverse",
      "direction": null
    },
    {
      "identifier": "ar.hatemfarid",
      "language": "ar",
      "name": "حاتم فريد",
      "englishName": "Hatem Farid",
      "format": "audio",
      "type": "versebyverse",
      "direction": null
    },
    {
      "identifier": "ar.ibrahimaljormy",
      "language": "ar",
      "name": " ابراهيم الجرمي",
      "englishName": "Ibrahim Aljormy",
      "format": "audio",
      "type": "versebyverse",
      "direction": null
    },


  ];
  final GlobalKey<FormFieldState<dynamic>> dropdownKeyTafsir = GlobalKey<FormFieldState<dynamic>>();
  final GlobalKey<FormFieldState<dynamic>> dropdownKeyTajweedSurah = GlobalKey<FormFieldState<dynamic>>();
  final GlobalKey<FormFieldState<dynamic>> dropdownKeyTajweedAyahs = GlobalKey<FormFieldState<dynamic>>();


  String? tafsirId;
  String? tajweedAyahId;
  String? tajweedSurahId;
  TextEditingController searchContentTafsir = TextEditingController();
  TextEditingController searchContentTajweedSurah = TextEditingController();
  TextEditingController searchContentTajweedAyah = TextEditingController();

  bool isNotifActive = false;
  var box = Hive.box('muslim_proj');


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var oldNotifStatus = box.get('notifSatus');

    if(oldNotifStatus != null && oldNotifStatus.toString() == "true"){
      oldNotifStatus = true;
    }

    isNotifActive = box.get("notifSatus");
    tafsirId = box.get("tafsirId");
    tajweedSurahId = box.get("tajweedSurahId");
    tajweedAyahId = box.get("tajweedAyahId");

    print('taffsir : $tafsirId');
    print('tajweedAyahId : $tajweedAyahId');
    print('tajweedSurahId : $tajweedSurahId');

  }

  @override
  Widget build(BuildContext context) {
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
          "Configuration",
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
              icon: const Icon(Icons.logout_outlined, color: KPrimaryColor),
              onPressed: () {},
            ),
          )
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [

                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                      color: KPrimaryColor.withOpacity(.08),
                      borderRadius: BorderRadius.circular(16)
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Notifications',
                                style: GoogleFonts.beVietnamPro(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.grey,
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
                                          isNotifActive = true;
                                          box.put("notifSatus", isNotifActive);
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: isNotifActive ? KPrimaryColor : Colors.transparent
                                        ),
                                        width: 40,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'ON',
                                            style: GoogleFonts.beVietnamPro(
                                              color: isNotifActive ? Colors.white :  KPrimaryColor,
                                                fontWeight: isNotifActive ? FontWeight.w600 : FontWeight.w500
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          isNotifActive = false;
                                          box.put("notifSatus", isNotifActive);
                                        });

                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        decoration: BoxDecoration(
                                          color: !isNotifActive ? KPrimaryColor.withOpacity(.8) : Colors.transparent,
                                          borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'OFF',
                                            style: GoogleFonts.beVietnamPro(
                                              color: !isNotifActive ? Colors.white : KPrimaryColor,
                                              fontWeight: !isNotifActive ? FontWeight.w600 : FontWeight.w500
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
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: 16),

                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                      color: KPrimaryColor.withOpacity(.08),
                      borderRadius: BorderRadius.circular(16)
                  ),

                  child: Row(
                    children: [
                      Expanded(
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

                              FutureBuilder(
                                  future: _getTafsirList,
                                  builder: (context , snapshot){
                                    if(snapshot.hasError){
                                      print("error : ${snapshot.error}");


                                      return Center(
                                        child: Text(
                                          "error : ${snapshot.error}"
                                        ),
                                      );
                                    }else if(snapshot.hasData){

                                      List<Map<String, dynamic>> tafsirs = snapshot.data as List<Map<String, dynamic>>;

                                      return DropdownButtonHideUnderline(
                                        child: DropdownButtonFormField2<Map<String,dynamic>>(
                                          key: dropdownKeyTafsir,
                                          value: tafsirs.firstWhereOrNull((item) => item["identifier"] == tafsirId.toString()),
                                          barrierDismissible: true,
                                          isExpanded: true,
                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintFadeDuration: Duration(milliseconds: 200),

                                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                            prefixIcon: Icon(
                                              Icons.translate_rounded,
                                              color: KPrimaryColor,
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8), // coins arrondis
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                )
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8), // coins arrondis
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                )
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8), // coins arrondis
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                )
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8), // coins arrondis
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                )
                                            ),
                                          ),
                                          iconStyleData: IconStyleData(

                                          ),
                                          barrierColor: KPrimaryColor.withOpacity(.2),
                                          items: tafsirs.map((Map<String,dynamic> value) {
                                            return DropdownMenuItem<Map<String,dynamic>>(
                                              value: value,
                                              child: Text(value['name'] ?? 'sans nom'),
                                            );
                                          }).toList(),
                                          hint: Text(
                                            'Chikh',
                                            style: GoogleFonts.beVietnamPro(
                                                color: Color(0xff808080),
                                                fontSize: 16
                                            ),
                                          ),
                                          style: GoogleFonts.beVietnamPro(
                                              color: KPrimaryColor
                                          ),
                                          onChanged: (newValue) {
                                            setState(() {
                                              tafsirId = newValue!['identifier'].toString();
                                              box.put("tafsirId", tafsirId);
                                              print('tafsirId: $tafsirId');
                                            });
                                          },
                                          // Search implementation using dropdown_button2 package
                                          dropdownSearchData: DropdownSearchData(
                                            searchController: searchContentTafsir,
                                            searchInnerWidgetHeight: 50,
                                            searchMatchFn: (item, searchValue) {
                                              return (item.value!['name'].toString().toLowerCase().contains(searchValue));
                                            },
                                            searchInnerWidget: Container(
                                              color: KBackgroundColor,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8,
                                                  bottom: 4,
                                                  right: 8,
                                                  left: 8,
                                                ),
                                                child: TextFormField(
                                                  controller: searchContentTafsir,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                      borderSide: BorderSide(
                                                          color: KPrimaryColor,
                                                          width: 2
                                                      ),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                      borderSide: BorderSide(
                                                          color: KPrimaryColor,
                                                          width: 2
                                                      ),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                      borderSide: BorderSide(
                                                          color: KPrimaryColor,
                                                          width: 2
                                                      ),
                                                    ),
                                                    label: Text(
                                                      'Tafsirs',
                                                      style: GoogleFonts.beVietnamPro(
                                                          color: KPrimaryColor
                                                      ),
                                                    ),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    hintText: 'Choisissez un Chikh',
                                                    labelStyle: GoogleFonts.beVietnamPro(
                                                      color: Color(0xff808080),
                                                    ),
                                                    prefixIcon: Icon(
                                                      Icons.translate_rounded,
                                                      color: KPrimaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          selectedItemBuilder: (context) {
                                            return tafsirs.map((item) {
                                              return Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  item['name'],
                                                  style: GoogleFonts.beVietnamPro(
                                                    color: KPrimaryColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              );
                                            }).toList();
                                          },

                                          dropdownStyleData: DropdownStyleData(
                                            decoration: BoxDecoration(
                                                color: KBackgroundColor
                                            ),
                                            isOverButton: true,
                                            useSafeArea: true,
                                          ),
                                          //This to clear the search value when you close the menu
                                          onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              // searchContentSetor.clear();
                                            }
                                          },
                                        ),
                                      );
                                    }

                                    return Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 60.0,
                                            child: Shimmer.fromColors(
                                              baseColor: KPrimaryColor.withOpacity(0.04),
                                              highlightColor: KPrimaryColor.withOpacity(0.1),
                                              child: Container(
                                                height: 60,
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius: BorderRadius.circular(15),
                                                    border: Border.all(
                                                        width: 4,
                                                        color: Colors.black
                                                    )
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),


                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                      color: KPrimaryColor.withOpacity(.08),
                      borderRadius: BorderRadius.circular(16)
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                ": تجويد ( سُوَر ) ",
                                style: GoogleFonts.zain(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  height: 1.6,
                                ),
                                textDirection: TextDirection.ltr,
                              ),

                              SizedBox(height: 4),

                              DropdownButtonHideUnderline(
                                child: DropdownButtonFormField2<Map<String,dynamic>>(
                                  key: dropdownKeyTajweedSurah,
                                  value: _getTajweedSurahList.firstWhereOrNull((item) => item["identifier"] == tajweedSurahId.toString()),
                                  barrierDismissible: true,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintFadeDuration: Duration(milliseconds: 200),

                                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                    prefixIcon: Icon(
                                      Icons.record_voice_over_outlined,
                                      color: KPrimaryColor,
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8), // coins arrondis
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8), // coins arrondis
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                        )
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8), // coins arrondis
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                        )
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8), // coins arrondis
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                        )
                                    ),
                                  ),
                                  iconStyleData: IconStyleData(

                                  ),
                                  barrierColor: KPrimaryColor.withOpacity(.2),
                                  items: _getTajweedSurahList.map((Map<String,dynamic> value) {
                                    return DropdownMenuItem<Map<String,dynamic>>(
                                      value: value,
                                      child: Text(value['name'] ?? 'sans nom'),
                                    );
                                  }).toList(),
                                  hint: Text(
                                    'Chikh',
                                    style: GoogleFonts.beVietnamPro(
                                        color: Color(0xff808080),
                                        fontSize: 16
                                    ),
                                  ),
                                  style: GoogleFonts.beVietnamPro(
                                      color: KPrimaryColor
                                  ),
                                  onChanged: (newValue) {
                                    setState(() {
                                      tajweedSurahId = newValue!['identifier'].toString();
                                      box.put("tajweedSurahId", tajweedSurahId);

                                      print('tajweedSurahId : $tajweedSurahId');
                                    });
                                  },
                                  // Search implementation using dropdown_button2 package
                                  dropdownSearchData: DropdownSearchData(
                                    searchController: searchContentTajweedSurah,
                                    searchInnerWidgetHeight: 50,
                                    searchMatchFn: (item, searchValue) {
                                      return (item.value!['name'].toString().toLowerCase().contains(searchValue));
                                    },
                                    searchInnerWidget: Container(
                                      color: KBackgroundColor,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 4,
                                          right: 8,
                                          left: 8,
                                        ),
                                        child: TextFormField(
                                          controller: searchContentTajweedSurah,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                  color: KPrimaryColor,
                                                  width: 2
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                  color: KPrimaryColor,
                                                  width: 2
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                  color: KPrimaryColor,
                                                  width: 2
                                              ),
                                            ),
                                            label: Text(
                                              'Tajweed',
                                              style: GoogleFonts.beVietnamPro(
                                                  color: KPrimaryColor
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Choisissez un Chikh',
                                            labelStyle: GoogleFonts.beVietnamPro(
                                              color: Color(0xff808080),
                                            ),
                                            prefixIcon: Icon(
                                              Icons.record_voice_over_outlined,
                                              color: KPrimaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  selectedItemBuilder: (context) {
                                    return _getTajweedSurahList.map((item) {
                                      return Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          item['name'],
                                          style: GoogleFonts.beVietnamPro(
                                            color: KPrimaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    }).toList();
                                  },

                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                        color: KBackgroundColor
                                    ),
                                    isOverButton: true,
                                    useSafeArea: true,
                                  ),
                                  //This to clear the search value when you close the menu
                                  onMenuStateChange: (isOpen) {
                                    if (!isOpen) {
                                      // searchContentSetor.clear();
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),


                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                      color: KPrimaryColor.withOpacity(.08),
                      borderRadius: BorderRadius.circular(16)
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                ": تجويد ( ايات ) ",
                                style: GoogleFonts.zain(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  height: 1.6,
                                ),
                                textDirection: TextDirection.ltr,
                              ),

                              SizedBox(height: 4),

                              FutureBuilder(
                                  future: _getTajweedAyahList,
                                  builder: (context , snapshot){
                                    if(snapshot.hasError){
                                      print("error : ${snapshot.error}");


                                      return Center(
                                        child: Text(
                                          "error : ${snapshot.error}"
                                        ),
                                      );
                                    }else if(snapshot.hasData){

                                      List<Map<String, dynamic>> tajweeds = snapshot.data as List<Map<String, dynamic>>;

                                      return DropdownButtonHideUnderline(
                                        child: DropdownButtonFormField2<Map<String,dynamic>>(
                                          key: dropdownKeyTajweedAyahs,
                                          value: tajweeds.firstWhereOrNull((item) => item["identifier"] == tajweedAyahId.toString()),
                                          barrierDismissible: true,
                                          isExpanded: true,
                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintFadeDuration: Duration(milliseconds: 200),

                                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                            prefixIcon: Icon(
                                              Icons.record_voice_over_outlined,
                                              color: KPrimaryColor,
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8), // coins arrondis
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                )
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8), // coins arrondis
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                )
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8), // coins arrondis
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                )
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8), // coins arrondis
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                )
                                            ),
                                          ),
                                          iconStyleData: IconStyleData(

                                          ),
                                          barrierColor: KPrimaryColor.withOpacity(.2),
                                          items: tajweeds.map((Map<String,dynamic> value) {
                                            return DropdownMenuItem<Map<String,dynamic>>(
                                              value: value,
                                              child: Text(value['name'] ?? 'sans nom'),
                                            );
                                          }).toList(),
                                          hint: Text(
                                            'Chikh',
                                            style: GoogleFonts.beVietnamPro(
                                                color: Color(0xff808080),
                                                fontSize: 16
                                            ),
                                          ),
                                          style: GoogleFonts.beVietnamPro(
                                              color: KPrimaryColor
                                          ),
                                          onChanged: (newValue) {
                                            setState(() {
                                              tajweedAyahId = newValue!['identifier'].toString();
                                              box.put("tajweedAyahId", tajweedAyahId);

                                              print('tajweedAyahId : $tajweedAyahId');
                                            });
                                          },
                                          // Search implementation using dropdown_button2 package
                                          dropdownSearchData: DropdownSearchData(
                                            searchController: searchContentTajweedAyah,
                                            searchInnerWidgetHeight: 50,
                                            searchMatchFn: (item, searchValue) {
                                              return (item.value!['name'].toString().toLowerCase().contains(searchValue));
                                            },
                                            searchInnerWidget: Container(
                                              color: KBackgroundColor,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8,
                                                  bottom: 4,
                                                  right: 8,
                                                  left: 8,
                                                ),
                                                child: TextFormField(
                                                  controller: searchContentTajweedAyah,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                      borderSide: BorderSide(
                                                          color: KPrimaryColor,
                                                          width: 2
                                                      ),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                      borderSide: BorderSide(
                                                          color: KPrimaryColor,
                                                          width: 2
                                                      ),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                      borderSide: BorderSide(
                                                          color: KPrimaryColor,
                                                          width: 2
                                                      ),
                                                    ),
                                                    label: Text(
                                                      'Tajweed',
                                                      style: GoogleFonts.beVietnamPro(
                                                          color: KPrimaryColor
                                                      ),
                                                    ),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    hintText: 'Choisissez un Chikh',
                                                    labelStyle: GoogleFonts.beVietnamPro(
                                                      color: Color(0xff808080),
                                                    ),
                                                    prefixIcon: Icon(
                                                      Icons.record_voice_over_outlined,
                                                      color: KPrimaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          selectedItemBuilder: (context) {
                                            return tajweeds.map((item) {
                                              return Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  item['name'],
                                                  style: GoogleFonts.beVietnamPro(
                                                    color: KPrimaryColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              );
                                            }).toList();
                                          },

                                          dropdownStyleData: DropdownStyleData(
                                            decoration: BoxDecoration(
                                                color: KBackgroundColor
                                            ),
                                            isOverButton: true,
                                            useSafeArea: true,
                                          ),
                                          //This to clear the search value when you close the menu
                                          onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              // searchContentSetor.clear();
                                            }
                                          },
                                        ),
                                      );
                                    }

                                    return Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 60.0,
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.black.withOpacity(0.04),
                                              highlightColor: Colors.black.withOpacity(0.1),
                                              child: Container(
                                                height: 60,
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius: BorderRadius.circular(15),
                                                    border: Border.all(
                                                        width: 4,
                                                        color: Colors.black
                                                    )
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  Future<List<Map<String, dynamic>>> getTafsirList()async{
    return await Provider.of<ConfigService>(context , listen: false).getTafsirList();
  }


  Future<List<Map<String, dynamic>>> getTajweedAyahList()async{
    return await Provider.of<ConfigService>(context , listen: false).getTajweedAyahList();
  }
}
