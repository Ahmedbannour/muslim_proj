import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Services/PrayersInfo.dart';
import 'package:muslim_proj/Services/SimpleLatLng.dart';
import 'package:provider/provider.dart';




class PrayerWidget extends StatefulWidget {
  const PrayerWidget({super.key});

  @override
  State<PrayerWidget> createState() => _PrayerWidgetState();
}

class _PrayerWidgetState extends State<PrayerWidget> {


  late Future<List<Map<String,dynamic>>> prayersInfo = getPrayersInfo();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Container(
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Prayer Time" ,
                  style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              ),
            ),

            Expanded(
              child: FutureBuilder(
                  future: prayersInfo,
                  builder: (context , snapshot){
                    if(snapshot.hasData){
                      dynamic response = snapshot;
                      List<Map<String,dynamic>> res = response.data.where((elem) => (elem['label'] == "Fajr" || elem['label'] == "Dhuhr" || elem['label'] == "Asr" || elem['label'] == "Maghrib" || elem['label'] == "Isha")).toList();
                      print('data task : ${res.toString()}');
                      return ListView.builder(
                        itemCount: res.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context , index){
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: KPrimaryColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/${res[index]['icon']}.svg',
                                      color: Color(0xFFFF7440),
                                      fit: BoxFit.contain,
                                      height: 24,
                                      alignment: Alignment.center,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                    ),

                                    SizedBox(height: 8),

                                    Text(
                                      res[index]['label'],

                                      style: GoogleFonts.beVietnamPro(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),


                                    SizedBox(height: 4),


                                    Text(
                                      res[index]['time'],

                                      style: GoogleFonts.beVietnamPro(
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }else if(snapshot.hasError){
                      return Text(
                        'prayer service error : ${snapshot.error.toString()}'
                      );
                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
              ),
            ),

            SizedBox(height: 16)
          ],
        )
    );
  }


  Future<List<Map<String,dynamic>>>  getPrayersInfo() async{
    final location = await getCurrentLocation();

    return await Provider.of<PrayersInfoService>(context , listen: false).getPrayerInfos(DateTime.now() , LatLng(location.latitude, location.longitude));
  }
}
