import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Widgets/AddParticipantWidget.dart';
import 'package:muslim_proj/Widgets/Calendar/MapSelectionScreen.dart';
import 'package:muslim_proj/Widgets/TaskDetails/DateTimeInput.dart';



class TaskDetails extends StatefulWidget {
  final Map<String, dynamic> task;
  const TaskDetails({super.key , required this.task});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {

  late Map<String, dynamic> task;
  final _taskForm = GlobalKey<FormState>();
  final FocusNode titreNode = FocusNode();
  final FocusNode descNode = FocusNode();
  final List<String> cats = [
    "home",
    "work",
    "sport",
    "freind",
    "education",
    "masjid"
  ];


  final List<Map<String,dynamic>> users = [
    {
      "id": 1,
      "name": "Ahmed Bannour",
      "email": "ahmed@example.com",
      "age": 28,
      "image": "men2.jpg",
      "role": "Admin",
      "isActive": true,
      "createdAt": DateTime(2024, 11, 10),
    },
    {
      "id": 2,
      "name": "Sana Trabelsi",
      "email": "sana.trabelsi@gmail.com",
      "age": 26,
      "image": "femme1.jpg",
      "role": "Manager",
      "isActive": true,
      "createdAt": DateTime(2024, 8, 4),
    },
    {
      "id": 3,
      "name": "Yassine Khaled",
      "email": "yassine.khaled@yahoo.com",
      "image": "men3.jpg",
      "age": 31,
      "role": "User",
      "isActive": false,
      "createdAt": DateTime(2024, 6, 18),
    }
  ];
  List<Map<String, dynamic>> locations = [
    {
      "id": 1,
      "label": "Lamta",
      "pays": "Tunisia",
      "city": "Monastir",
      "cp": 5099
    },
    {
      "id": 2,
      "label": "Sousse Centre",
      "pays": "Tunisia",
      "city": "Sousse",
      "cp": 4000
    },
    {
      "id": 3,
      "label": "Khezama",
      "pays": "Tunisia",
      "city": "Sousse",
      "cp": 4051
    },
    {
      "id": 4,
      "label": "Medenine Sud",
      "pays": "Tunisia",
      "city": "Medenine",
      "cp": 4100
    },
    {
      "id": 5,
      "label": "Tunis Centre",
      "pays": "Tunisia",
      "city": "Tunis",
      "cp": 1000
    },
    {
      "id": 6,
      "label": "Lac 1",
      "pays": "Tunisia",
      "city": "Tunis",
      "cp": 1053
    },
    {
      "id": 7,
      "label": "Lac 2",
      "pays": "Tunisia",
      "city": "Tunis",
      "cp": 1057
    },
    {
      "id": 8,
      "label": "Mahdia Centre",
      "pays": "Tunisia",
      "city": "Mahdia",
      "cp": 5100
    },
    {
      "id": 9,
      "label": "Borj Cedria",
      "pays": "Tunisia",
      "city": "Ben Arous",
      "cp": 2090
    },
    {
      "id": 10,
      "label": "Nabeul Centre",
      "pays": "Tunisia",
      "city": "Nabeul",
      "cp": 8000
    },
    {
      "id": 11,
      "label": "Hammamet Nord",
      "pays": "Tunisia",
      "city": "Nabeul",
      "cp": 8050
    },
    {
      "id": 12,
      "label": "Gabes Centre",
      "pays": "Tunisia",
      "city": "Gabes",
      "cp": 6000
    },
    {
      "id": 13,
      "label": "Gafsa Ville",
      "pays": "Tunisia",
      "city": "Gafsa",
      "cp": 2100
    },
    {
      "id": 14,
      "label": "Kairouan Médina",
      "pays": "Tunisia",
      "city": "Kairouan",
      "cp": 3100
    },
    {
      "id": 15,
      "label": "Sfax Centre",
      "pays": "Tunisia",
      "city": "Sfax",
      "cp": 3000
    },
    {
      "id": 16,
      "label": "El Ain",
      "pays": "Tunisia",
      "city": "Sfax",
      "cp": 3055
    },
    {
      "id": 17,
      "label": "Bizerte Nord",
      "pays": "Tunisia",
      "city": "Bizerte",
      "cp": 7000
    },
    {
      "id": 18,
      "label": "Rades",
      "pays": "Tunisia",
      "city": "Ben Arous",
      "cp": 2040
    },
    {
      "id": 19,
      "label": "La Marsa",
      "pays": "Tunisia",
      "city": "Tunis",
      "cp": 2070
    },
    {
      "id": 20,
      "label": "Sidi Bou Said",
      "pays": "Tunisia",
      "city": "Tunis",
      "cp": 2026
    },
  ];
  int? location;

  DateTime? selectedDateTimeBegin;
  DateTime? selectedDateTimeEnd;
  final GlobalKey<FormFieldState<dynamic>> dropdownKey = GlobalKey<FormFieldState<dynamic>>();
  TextEditingController searchContentSetor = TextEditingController();




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    task = widget.task;
  }



  @override
  void didUpdateWidget(covariant TaskDetails oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if(task != widget.task){
      task = widget.task;
    }
  }




  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: KBackgroundColor,
      appBar: AppBar(
        backgroundColor: KPrimaryColor,
        bottomOpacity: 0,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
        ),
        centerTitle: true,
        toolbarHeight: 70,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
          ),
          child: IconButton(
            icon: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: SvgPicture.asset(
                "assets/icons/angle-left (1).svg",
                color: Colors.white,
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
        iconTheme: IconThemeData(
          color: Colors.white, // change your color here
        ),
        title: Text(
          task['label'].toString(),
          style: GoogleFonts.beVietnamPro(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.logout_outlined,
              ),
              onPressed: () {

              },
            ),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () async{
          if(titreNode.hasFocus) {
            setState(() {
              titreNode.unfocus();
            });
            return false;
          }
          
          if(descNode.hasFocus) {
            setState(() {
              descNode.unfocus();
            });
            return false;
          }
          return true;
        },
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                bottom: 70,
                left: 0,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _taskForm,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "Task Title",
                              style: GoogleFonts.beVietnamPro(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),

                          SizedBox(height: 4),

                          TextFormField(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            focusNode: titreNode,
                            decoration: InputDecoration(
                              hintStyle: GoogleFonts.beVietnamPro(color: Colors.grey),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
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

                            ),
                            initialValue: task['label'] ?? null,
                            onChanged: (value){
                              setState(() {
                                task['label'] = value;
                              });
                            },

                            onTapOutside: (a){
                              titreNode.unfocus();
                            },

                          ),

                          SizedBox(height: 8),

                          Container(
                            child: Text(
                              "Categories",
                              style: GoogleFonts.beVietnamPro(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),

                          SizedBox(height: 4),

                          MultiSelectContainer(
                              items: cats.map((cat){
                                return MultiSelectCard(value: cat.toString() , label: cat.toString());
                              }).toList(),

                              highlightColor: KPrimaryColor,
                              itemsDecoration: MultiSelectDecorations(
                                selectedDecoration: BoxDecoration(
                                    color: KPrimaryColor,
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                decoration: BoxDecoration(
                                    color: KPrimaryColor.withOpacity(.4),
                                    borderRadius: BorderRadius.circular(8)
                                ),
                              ),
                              isMaxSelectableWithPerpetualSelects: true,
                              listViewSettings: ListViewSettings(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shrinkWrap: true,
                                dragStartBehavior: DragStartBehavior.down,
                                padding: EdgeInsets.all(8),
                              ),

                              itemsPadding: EdgeInsets.all(8),
                              splashColor: KPrimaryColor,
                              wrapSettings: WrapSettings(
                                runSpacing: 5,
                                spacing: 8,
                              ),

                              maxSelectableCount: 2,
                              textStyles: MultiSelectTextStyles(
                                  selectedTextStyle: GoogleFonts.beVietnamPro(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600
                                  ),
                                  disabledTextStyle: GoogleFonts.beVietnamPro(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600
                                  ),
                                  textStyle: GoogleFonts.beVietnamPro(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400
                                  )
                              ),
                              onMaximumSelected: (allSelectedItems, selectedItem) {

                              },

                              onChange: (allSelectedItems, selectedItem) {

                              }
                          ),


                          SizedBox(height: 8),

                          Row(
                            children: [
                              Expanded(
                                  child: DateTimeInput(
                                      label: "Commence",
                                      begin: DateTime.now(),
                                      end: selectedDateTimeEnd ?? DateTime(2030),
                                      fieldHintText: "Date Commence",
                                      helpText: "Date Commence",
                                      currentDate: selectedDateTimeEnd ?? DateTime.now(),
                                      fieldLabelText: "Date Commence",
                                      errorInvalidText: "Date Commence invalid",
                                      errorFormatText: "Date Commence format invalid",
                                      confirmText: "enregistrer",
                                      cancelText: "annuler",
                                      barrierLabel: "Date Commence",
                                      updateDate: (newDate){
                                        setState(() {
                                          selectedDateTimeBegin = newDate;
                                        });
                                        print('selectedDateTimeBegin : $selectedDateTimeBegin');
                                      }
                                  )
                              ),

                              SizedBox(width: 8),


                              Expanded(
                                child: DateTimeInput(
                                    label: "Fin",
                                    begin: selectedDateTimeBegin ?? DateTime.now(),
                                    end: DateTime(2030),
                                    fieldHintText: "Date Fin",
                                    helpText: "Date Fin",
                                    currentDate: selectedDateTimeBegin ?? DateTime.now(),
                                    fieldLabelText: "Date Fin",
                                    errorInvalidText: "Date Fin invalid",
                                    errorFormatText: "Date Fin format invalid",
                                    confirmText: "enregistrer",
                                    cancelText: "annuler",
                                    barrierLabel: "Date Fin",
                                    updateDate: (newDate){
                                      setState(() {
                                        selectedDateTimeEnd = newDate;
                                      });
                                      print('selectedDateTimeEnd : $selectedDateTimeEnd');
                                    }
                                ),
                              ),




                            ],
                          ),

                          SizedBox(height: 8),

                          Container(
                            child: Text(
                              "Participants",
                              style: GoogleFonts.beVietnamPro(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),

                          SizedBox(height: 4),

                          Container(
                            height: 60,
                            child: ListView.builder(
                              itemCount: users.length+1,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context , index){
                                if(index == 0) {
                                  return GestureDetector(
                                    onTap: (){
                                      print('add participant');
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddParticipantWidget()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                                width: 2,
                                                color: KPrimaryColor
                                            )
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.add,
                                            color: KPrimaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return GestureDetector(
                                  onTap: (){

                                    if(users[index - 1]['selected'] == null || users[index - 1]['selected'] == false){
                                      setState(() {
                                        users[index - 1]['selected'] = true;
                                      });
                                    }else{
                                      setState(() {
                                        users[index - 1]['selected'] = false;
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 200),
                                      decoration: BoxDecoration(
                                          color: (users[index - 1]['selected'] == null || users[index - 1]['selected'] == false) ?  Colors.white : KPrimaryColor,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: (users[index - 1]['selected'] == null || users[index - 1]['selected'] == false)  ? Colors.grey.shade300 : KPrimaryColor,
                                          )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              child: AspectRatio(
                                                aspectRatio: 1,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle
                                                  ),
                                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                                  child: Image.asset(
                                                    "assets/images/${users[index-1]['image']}",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),

                                            SizedBox(width: 8),

                                            Text(
                                              users[index-1]['name'].toString(),
                                              style: GoogleFonts.beVietnamPro(
                                                  fontWeight: FontWeight.w500,
                                                  color: (users[index - 1]['selected'] == null || users[index - 1]['selected'] == false) ? Colors.black : Colors.white
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 8),



                          Container(
                            child: Text(
                              "Localisation",
                              style: GoogleFonts.beVietnamPro(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),

                          SizedBox(height: 4),

                          // GestureDetector(
                          //   onTap: () async {
                          //     final result = await Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => const MapSelectionScreen(),
                          //       ),
                          //     );
                          //
                          //     if (result != null && result is LatLng) {
                          //       // 🔍 Convertir les coordonnées en adresse
                          //       List<Placemark> placemarks = await placemarkFromCoordinates(
                          //         result.latitude,
                          //         result.longitude,
                          //       );
                          //
                          //       setState(() {
                          //         _selectedLatLng = result;
                          //         _selectedLocation = "${placemarks.first.locality ?? ''}, ${placemarks.first.country ?? ''}";
                          //       });
                          //     }
                          //   },
                          //   child: AnimatedContainer(
                          //     duration: const Duration(milliseconds: 200),
                          //     curve: Curves.easeInOut,
                          //     decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       borderRadius: BorderRadius.circular(12),
                          //       border: Border.all(
                          //         color: Colors.teal,
                          //         width: 2,
                          //       ),
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: Colors.teal.withOpacity(0.15),
                          //           blurRadius: 6,
                          //           offset: const Offset(0, 3),
                          //         ),
                          //       ],
                          //     ),
                          //     padding: const EdgeInsets.symmetric(horizontal: 12),
                          //     height: 60,
                          //     child: Row(
                          //       children: [
                          //         Icon(
                          //           Icons.add_location_alt_outlined,
                          //           color: Colors.teal,
                          //           size: 28,
                          //         ),
                          //
                          //         const SizedBox(width: 12),
                          //
                          //         Container(
                          //           width: 2,
                          //           height: 32,
                          //           decoration: BoxDecoration(
                          //             color: Colors.teal.withOpacity(.4),
                          //             borderRadius: BorderRadius.circular(8),
                          //           ),
                          //         ),
                          //
                          //         const SizedBox(width: 12),
                          //
                          //         Expanded(
                          //           child: Text(
                          //             _selectedLocation ?? 'Choisir votre localisation',
                          //             overflow: TextOverflow.ellipsis,
                          //             maxLines: 1,
                          //             style: GoogleFonts.beVietnamPro(
                          //               color: _selectedLocation == null
                          //                   ? Colors.grey
                          //                   : Colors.black87,
                          //               fontWeight: FontWeight.w500,
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),

                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField2<dynamic>(
                                    key: dropdownKey,
                                    value: locations.firstWhereOrNull((item) => item["id"] == location.toString()),
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                      prefixIcon: Icon(
                                        Icons.location_on_outlined,
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
                                    alignment: Alignment.centerLeft,
                                    barrierColor: KPrimaryColor.withOpacity(.2),
                                    items: locations.map((dynamic value) {
                                      return DropdownMenuItem<dynamic>(
                                        value: value,
                                        child: Text(value['label'] ?? 'sans label'),
                                      );
                                    }).toList(),
                                    hint: Text(
                                      'Locations',
                                      style: GoogleFonts.beVietnamPro(
                                          color: Color(0xff808080),
                                          fontSize: 16
                                      ),
                                    ),
                                    style: GoogleFonts.beVietnamPro(
                                        color: KPrimaryColor
                                    ),
                                    onChanged: (newValue) {
                                      location = int.parse(newValue['id'].toString());
                                      print('new client : $location');
                                    },
                                    // Search implementation using dropdown_button2 package
                                    dropdownSearchData: DropdownSearchData(
                                      searchController: searchContentSetor,
                                      searchInnerWidgetHeight: 50,
                                      searchMatchFn: (item, searchValue) {
                                        return (item.value['label'].toString().toLowerCase().contains(searchValue));
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
                                            controller: searchContentSetor,
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
                                                'locations',
                                                style: GoogleFonts.beVietnamPro(
                                                    color: KPrimaryColor
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              hintText: 'Choisissez une localisation',
                                              labelStyle: GoogleFonts.beVietnamPro(
                                                color: Color(0xff808080),
                                              ),
                                              prefixIcon: Icon(
                                                Icons.location_on_outlined,
                                                color: KPrimaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    selectedItemBuilder: (context) {
                                      return locations.map((item) {
                                        return Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            item['label'],
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
                                      width: MediaQuery.of(context).size.width ,
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
                                ),
                              ),

                              SizedBox(width: 8),

                              GestureDetector(
                                onTap: (){
                                  print('add location');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            width: 2,
                                            color: KPrimaryColor
                                        )
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: KPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 8),

                          Container(
                            child: Text(
                              "Description",
                              style: GoogleFonts.beVietnamPro(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),

                          SizedBox(height: 4),


                          TextFormField(
                            maxLines: 5,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            focusNode: descNode,
                            decoration: InputDecoration(
                                hintStyle: GoogleFonts.beVietnamPro(color: Colors.grey),
                                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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

                                filled: true,
                                fillColor: Colors.white
                            ),
                            initialValue: task['label'] ?? null,
                            onChanged: (value){
                              setState(() {
                                task['label'] = value;
                              });
                            },

                            onTapOutside: (a){
                              descNode.unfocus();
                            },

                          ),


                        ],
                      ),
                    ),
                  ),
                ),
              ),


              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: KBackgroundColor
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        topLeft: Radius.circular(16),
                      )
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: KPrimaryColor,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Center(
                          child: Text(
                            'Enregistrer',
                            style: GoogleFonts.beVietnamPro(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),


            ],
          )
        ),
      ),
    );
  }
}
