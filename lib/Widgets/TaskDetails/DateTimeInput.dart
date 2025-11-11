import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muslim_proj/Constants.dart';


class DateTimeInput extends StatefulWidget {
  final String label;
  final Function(DateTime? olddate) updateDate;
  const DateTimeInput({super.key , required this.label, required this.updateDate});

  @override
  State<DateTimeInput> createState() => _DateTimeInputState();
}

class _DateTimeInputState extends State<DateTimeInput> {
  
  
  late String label;
  DateTime? selectedDateTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    label = widget.label;
  }
  
  
  @override
  void didUpdateWidget(covariant DateTimeInput oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    
    if(widget.label != label){
      label = widget.label;
    }
  }
  
  
  @override
  Widget build(BuildContext context) {

    final formattedDate = selectedDateTime != null  ? DateFormat('dd MMM, hh:mm a').format(selectedDateTime!) : "Select date & time";

    
    
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
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              formattedDate,
              style: TextStyle(
                fontSize: 16,
                color: selectedDateTime != null
                    ? Colors.black87
                    : Colors.grey.shade500,
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
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepOrange,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date == null) return;

    // 2️⃣ Sélection de l’heure
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: KPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time == null) return;

    // 3️⃣ Combine date + time
    final newDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      selectedDateTime = newDateTime;
    });
    
    widget.updateDate(selectedDateTime);
  }

}
