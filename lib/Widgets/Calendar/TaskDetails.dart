import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:muslim_proj/Constants.dart';
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
  final List<String> cats = [
    "home",
    "work",
    "sport",
    "freind",
    "education",
    "masjid"
  ];
  DateTime? selectedDateTimeBegin;
  DateTime? selectedDateTimeEnd;


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
          style: TextStyle(
              fontFamily: 'OpenSansBold',
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
          return true;
        },
        child: SafeArea(
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
                      style: TextStyle(
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
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8), // coins arrondis
                        gapPadding: 5
                      ),
                      focusedBorder: OutlineInputBorder(

                      )
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
                      style: TextStyle(
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

                    highlightColor: Colors.red,
                    itemsDecoration: MultiSelectDecorations(
                      selectedDecoration: BoxDecoration(
                        color: KPrimaryColor,
                        borderRadius: BorderRadius.circular(12)
                      ),
                      decoration: BoxDecoration(
                        color: KPrimaryColor.withOpacity(.4),
                        borderRadius: BorderRadius.circular(12)
                      ),
                    ),
                    isMaxSelectableWithPerpetualSelects: true,
                    listViewSettings: ListViewSettings(
                      addRepaintBoundaries: true,
                      addSemanticIndexes: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shrinkWrap: true,
                      dragStartBehavior: DragStartBehavior.down,
                      padding: EdgeInsets.all(20),
                    ),
                    
                    itemsPadding: EdgeInsets.all(8),
                    splashColor: KPrimaryColor,
                    wrapSettings: WrapSettings(
                      runSpacing: 5,
                      spacing: 8,
                    ),

                    maxSelectableCount: 2,
                    textStyles: MultiSelectTextStyles(
                      selectedTextStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600
                      ),
                      disabledTextStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600
                      ),
                      textStyle: TextStyle(
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
                  )



                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}
