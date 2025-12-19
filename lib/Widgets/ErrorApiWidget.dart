import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_proj/Constants.dart';


class ErrorApiWidget extends StatefulWidget {

  final String text;
  const ErrorApiWidget({super.key , required this.text});

  @override
  State<ErrorApiWidget> createState() => _ErrorApiWidgetState();
}

class _ErrorApiWidgetState extends State<ErrorApiWidget> {

  late String text;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    text = widget.text;
  }

  @override
  void didUpdateWidget(covariant ErrorApiWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if(text != widget.text){
      text = widget.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                child: SvgPicture.asset(
                  "assets/icons/octagon-xmark (1).svg",
                  width: 80,
                  color: KPrimaryColor.withOpacity(.8),
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: 8),

              Container(
                child: Text(
                  text,
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
