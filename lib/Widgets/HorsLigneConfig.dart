import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Services/QuranService.dart';
import 'package:muslim_proj/Widgets/Configuration/SurahItem.dart';
import 'package:provider/provider.dart';


class HorsLigneConfig extends StatefulWidget {
  const HorsLigneConfig({super.key});

  @override
  State<HorsLigneConfig> createState() => _HorsLigneConfigState();
}

class _HorsLigneConfigState extends State<HorsLigneConfig> {

  late DownloadQuranSteps steps;
  List<Map<dynamic , dynamic>> quranList = [];
  var box = Hive.box('muslim_proj');

  Set<int> selectedIndexes = {};
  bool selectAll = false;
  int downloadedCount = 0;
  bool isDownloading = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    box.put("quranList", null);

    quranList = ((box.get('quranList') ?? []) as List<dynamic>).map((e) => Map<dynamic, dynamic>.from(e)).toList();
    print('quranlist : $quranList');
    steps = DownloadQuranSteps.Nothing;
    if(quranList.isNotEmpty){
      steps = DownloadQuranSteps.QuranList;
    }
    print('steps : $steps');
  }
  
  
  @override
  Widget build(BuildContext context) {

    if(quranList.isNotEmpty){
      steps = DownloadQuranSteps.QuranList;
    }
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
            "Hors ligne",
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
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Builder(
              builder: (context) {
                if(steps == DownloadQuranSteps.Nothing){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: ()async{
                                print('download quran list');

                                List<Map<dynamic , dynamic>> quran = await Provider.of<QuranService>(context , listen: false).downloadQuranList();

                                print('quran : ${quran[0]}');

                                if(quran.isNotEmpty && quran[0]['error'] != null && quran[0]['error'] == 1){
                                  print('fdjlskdhfmlsdf');
                                  Fluttertoast.showToast(
                                    msg: quran[0]['message'] ?? 'probleme de connexion',
                                    toastLength: Toast.LENGTH_LONG
                                  );
                                }else{
                                  print('elseeeee');
                                  quranList = quran;

                                  if(quranList.isNotEmpty){
                                    setState(() {
                                      steps = DownloadQuranSteps.QuranList;
                                    });
                                  }

                                }
                                

                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                    color: KPrimaryColor,
                                    borderRadius: BorderRadius.circular(16)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'Download Quran List',
                                    style: GoogleFonts.beVietnamPro(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                }else if(steps == DownloadQuranSteps.QuranList){
                  return Stack(
                    children: [
                      Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        bottom: 0,
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: KPrimaryColor.withOpacity(.03),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: selectAll,
                                    activeColor: KPrimaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        selectAll = value ?? false;
                                        if (selectAll) {
                                          selectedIndexes = Set.from(List.generate(quranList.length, (i) => i+1));
                                        } else {
                                          selectedIndexes.clear();
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Sélectionner toutes les sourates',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 8),
                            Expanded(
                              child: ListView.builder(
                                itemCount: quranList.length + 1,
                                itemBuilder: (context, index) {
                                  final isSelected = selectedIndexes.contains(index+1);

                                  if(index == quranList.length)
                                    return Container(
                                      height: 60,
                                    );
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isSelected ? KPrimaryColor.withOpacity(.05) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: SurahItem(
                                            surah: quranList[index],
                                            index: index,
                                            isSelected: isSelected,
                                            updateSelectedItem: (value){
                                              setState(() {
                                                if (value == true) {
                                                  selectedIndexes.add(index+1);
                                                } else {
                                                  selectedIndexes.remove(index+1);
                                                }

                                                selectAll = selectedIndexes.length == quranList.length;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        right: 0,
                        left: 0,
                        bottom: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: isDownloading ? null : () async {
                              await downloadSelectedSurahs(
                                context,
                                selectedIndexes,
                                quranList, // ta liste venant de getQuranAll()
                              );


                              Map<dynamic, dynamic> oldDetails = Map<dynamic, dynamic>.from(box.get('surah_details') ?? {});



                              print('oldQuranList : ${oldDetails['Aal-i-Imraan'].toString()}');

                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: isDownloading ? Colors.grey : KPrimaryColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (isDownloading)
                                      SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    else
                                      Icon(Icons.download_outlined, color: Colors.white),

                                    SizedBox(width: 8),

                                    Text(
                                      isDownloading ? '$downloadedCount / ${selectedIndexes.length}' : 'Download',
                                      style: GoogleFonts.beVietnamPro(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        ),
                      )
                    ],
                  );
                }else{
                  return Container(
                    width: 200,
                    height: 200,
                    color: Colors.red,
                  );
                }
              }
            ),
          ),
        )
    );
  }


  Future<void> downloadSelectedSurahs(BuildContext context, Set<int> selectedIndexes, List<Map<dynamic, dynamic>> quranList,) async {

    final service = context.read<QuranService>();

    print('selectedIndexes : $selectedIndexes');
    Map<dynamic, dynamic> surahDetails = Map<dynamic, dynamic>.from(box.get('surah_details') ?? {});

    setState(() {
      isDownloading = true;
      downloadedCount = 0;
    });

    for (final surahNumber in selectedIndexes) {

      final surah = quranList.firstWhere((e) => e['number'] == surahNumber);

      final String key = surah['englishName'];

      /// ⛔ Déjà téléchargée → on saute
      if (surahDetails.containsKey(key)) {
        downloadedCount++;
        setState(() {});
        continue;
      }

      /// ⬇️ Télécharger
      final data = await service.downlaodSurah(surahNumber);

      print('dataa : $data');
      if (data['error'] != 1) {
        surahDetails[key] = data['data'];
        await box.put('surah_details', surahDetails);

      }else{
        Fluttertoast.showToast(
          msg: 'Désolé , un probeleme d api'
        );
        break;
      }

      downloadedCount++;
      setState(() {});
    }

    setState(() {
      isDownloading = false;
    });
  }

}

enum DownloadQuranSteps{
  Nothing,
  QuranList,
  QuranDetails,
  QuranExplix,
  QuranAudio,

}
