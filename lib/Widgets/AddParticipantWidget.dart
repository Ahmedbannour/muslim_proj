import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Widgets/TaskDetails/DateInput.dart';



class AddParticipantWidget extends StatefulWidget {
  const AddParticipantWidget({super.key});

  @override
  State<AddParticipantWidget> createState() => _AddParticipantWidgetState();
}

class _AddParticipantWidgetState extends State<AddParticipantWidget> {


  final _participantForm = GlobalKey<FormState>();
  final FocusNode nameNode = FocusNode();
  final FocusNode numNode = FocusNode();


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
          "participants",
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            onWillPop: () async{
              if(nameNode.hasFocus) {
                setState(() {
                  nameNode.unfocus();
                });
                return false;
              }

              if(numNode.hasFocus) {
                setState(() {
                  numNode.unfocus();
                });
                return false;
              }
              return true;
            },

            key: _participantForm,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                print('upload photo');

                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: KPrimaryColor.withOpacity(.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    radius: Radius.circular(16),
                                    color: KPrimaryColor.withOpacity(.8),
                                    strokeWidth: 2,
                                    dashPattern: [6, 4],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(24),
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/images.svg",
                                          fit: BoxFit.contain,
                                          width: 96,
                                        ),
                                        SizedBox(height: 8),
                  
                  
                                        Text(
                                          "Click to upload image",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20
                                          ),
                                        ),
                  
                                        SizedBox(height: 4),
                  
                                        Text(
                                          "jpg , png ( 12MB max )",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                  
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  
                        SizedBox(height: 24),
                  
                        Container(
                          child: Text(
                            "nom",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                  
                        SizedBox(height: 4),
                  
                        TextFormField(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          focusNode: nameNode,
                          decoration: InputDecoration(
                              hintStyle: const TextStyle(color: Colors.grey),
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
                  
                              hintText: "Tapez le nom complet de participant"
                  
                          ),
                          onChanged: (value){
                  
                          },
                  
                          onTapOutside: (a){
                            nameNode.unfocus();
                          },
                  
                        ),
                  
                        SizedBox(height: 8),
                  
                        Container(
                          child: Text(
                            "Télephone",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                  
                        SizedBox(height: 4),
                  
                        TextFormField(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          focusNode: numNode,
                          decoration: InputDecoration(
                              hintStyle: const TextStyle(color: Colors.grey),
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
                  
                              hintText: numNode.hasFocus == true ? "+216 XX XXX XXX" :"Tapez le numero de participant"
                  
                          ),
                          onChanged: (value){
                  
                          },
                  
                          onTap: (){
                            setState(() {
                  
                            });
                          },
                          onTapOutside: (a){
                            setState(() {
                              numNode.unfocus();
                            });
                          },
                  
                        ),
                  
                        SizedBox(height: 8),
                  
                        DateInput(
                            label: "Date de naissance",
                            updateDate: (date){
                              setState(() {
                  
                              });
                            },
                            begin: DateTime(1940),
                            end: DateTime.now(),
                            barrierLabel: "Date de naissance",
                            cancelText: "Annuler",
                            confirmText: "Confirmer",
                            currentDate: DateTime.now(),
                            errorFormatText: "Date de naissance invalide",
                            errorInvalidText: "Date de naissance invalide",
                            fieldHintText: "Merci de tapez la date de naissance",
                            fieldLabelText: "Date de naissance",
                            helpText: "Date de naissance"
                  
                        )
                  
                      ],
                    ),
                  ),
                ),
                

                Row(
                  children: [
                    Expanded(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: KPrimaryColor,
                          borderRadius: BorderRadius.circular(16)
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              'Enregistrer',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )

              ],
            ),
          ),
        ),
      )
    );
  }
}
