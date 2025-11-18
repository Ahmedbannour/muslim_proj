import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muslim_proj/Constants.dart';



class AddParticipantWidget extends StatefulWidget {
  const AddParticipantWidget({super.key});

  @override
  State<AddParticipantWidget> createState() => _AddParticipantWidgetState();
}

class _AddParticipantWidgetState extends State<AddParticipantWidget> {
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
        child: SingleChildScrollView(
          child: Column(
            children: [

            ],
          ),
        ),
      )
    );
  }
}
