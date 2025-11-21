import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muslim_proj/Constants.dart';


class DateInput extends StatefulWidget {
  final String label;
  final Function(DateTime? olddate) updateDate;
  final DateTime? begin;
  final DateTime? end;
  final String? barrierLabel;
  final String? cancelText;
  final String? confirmText;
  final String? errorFormatText;
  final String? errorInvalidText;
  final String? fieldLabelText;
  final DateTime? currentDate;
  final String? helpText;
  final String? fieldHintText;
  const DateInput({
    super.key ,
    required this.label,
    required this.updateDate ,
    required this.begin ,
    required this.end,
    required this.barrierLabel,
    required this.cancelText,
    required this.confirmText,
    required this.currentDate,
    required this.errorFormatText,
    required this.errorInvalidText,
    required this.fieldHintText,
    required this.fieldLabelText,
    required this.helpText,
  });

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {


  late String label;
  DateTime? selectedDateTime;
  DateTime? begin;
  DateTime? end;
  String? barrierLabel;
  String? cancelText;
  String? confirmText;
  String? errorFormatText;
  String? errorInvalidText;
  String? fieldLabelText;
  DateTime? currentDate;
  String? helpText;
  String? fieldHintText;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    label = widget.label;
    begin = widget.begin;
    end = widget.end;
    barrierLabel = widget.barrierLabel;
    cancelText = widget.cancelText;
    confirmText = widget.confirmText;
    errorFormatText = widget.errorFormatText;
    errorInvalidText = widget.errorInvalidText;
    fieldLabelText = widget.fieldLabelText;
    currentDate = widget.currentDate;
    helpText = widget.helpText;
    fieldHintText = widget.fieldHintText;

    print('begin : $begin');
    print('end : $end');
  }


  @override
  void didUpdateWidget(covariant DateInput oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if(label != widget.label){
      label = widget.label;
    }
    if(begin != widget.begin){
      begin = widget.begin;
    }


    if(end != widget.end){
      end = widget.end;
    }

    if(barrierLabel != widget.barrierLabel){
      barrierLabel = widget.barrierLabel;
    }

    if(cancelText != widget.cancelText){
      cancelText = widget.cancelText;
    }

    if(confirmText != widget.confirmText){
      confirmText = widget.confirmText;
    }

    if(errorFormatText != widget.errorFormatText){
      errorFormatText = widget.errorFormatText;
    }

    if(errorInvalidText != widget.errorInvalidText){
      errorInvalidText = widget.errorInvalidText;
    }

    if(fieldLabelText != widget.fieldLabelText){
      fieldLabelText = widget.fieldLabelText;
    }

    if(currentDate != widget.currentDate){
      currentDate = widget.currentDate;
    }

    if(helpText != widget.helpText){
      helpText = widget.helpText;
    }

    if(fieldHintText != widget.fieldHintText){
      fieldHintText = widget.fieldHintText;
    }


  }


  @override
  Widget build(BuildContext context) {

    final formattedDate = selectedDateTime != null  ? DateFormat('dd/MM/yyyy').format(selectedDateTime!) : fieldLabelText ?? "Select date & time";


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => _pickDateTime(context),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              formattedDate,
              style: TextStyle(
                fontSize: 16,
                color: selectedDateTime != null ? Colors.black87 : Colors.grey.shade500,
              ),
            ),
          ),
        ),
      ],
    );
  }


  Future<void> _pickDateTime(BuildContext context) async {
    // 1️⃣ Sélection de la date
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: begin ?? DateTime(2020),
      lastDate: end ?? DateTime(2030),
      barrierColor: KPrimaryColor.withOpacity(.2),
      barrierDismissible: true,
      initialDatePickerMode: DatePickerMode.day,
      barrierLabel: barrierLabel,
      cancelText: cancelText,
      confirmText: confirmText,
      errorFormatText: errorFormatText,
      errorInvalidText: errorInvalidText,
      fieldLabelText: fieldLabelText,
      currentDate: currentDate,
      helpText: helpText,
      fieldHintText: fieldHintText,
      locale: const Locale('fr', 'FR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: KPrimaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date == null) return;


    // 3️⃣ Combine date + time
    final newDateTime = DateTime(
      date.year,
      date.month,
      date.day,
    );

    selectedDateTime = newDateTime;

    widget.updateDate(selectedDateTime);
  }

}
