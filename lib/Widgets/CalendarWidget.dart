import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Widgets/Calendar/EventsByDateWidget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<String, List<Map<String, dynamic>>> tasksByDay = {
    "01/11/2025": [
      {
        "label": "Réunion de planification",
        "categorie": "Travail",
        "heure_deb": "09:00",
        "heure_fin": "10:30",
        "localisation": "Bureau central",
        "color": Colors.blueAccent, // 💼 Travail
      },
      {
        "label": "Course hebdomadaire",
        "categorie": "Personnel",
        "heure_deb": "17:00",
        "heure_fin": "18:00",
        "localisation": "Carrefour Monastir",
        "color": Colors.orangeAccent, // 👤 Personnel
      },
    ],

    "02/11/2025": [
      {
        "label": "Code review - projet Flutter",
        "categorie": "Travail",
        "heure_deb": "10:00",
        "heure_fin": "12:00",
        "localisation": "Remote (Teams)",
        "color": Colors.blueAccent,
      },
    ],

    "03/11/2025": [
      {
        "label": "Sport (course à pied)",
        "categorie": "Santé",
        "heure_deb": "07:30",
        "heure_fin": "08:15",
        "localisation": "Plage Monastir",
        "color": Colors.green, // 💪 Santé
      },
      {
        "label": "Développement module Qibla",
        "categorie": "Projet personnel",
        "heure_deb": "15:00",
        "heure_fin": "18:00",
        "localisation": "Maison",
        "color": Colors.purpleAccent, // 🚀 Projet perso
      }
    ],

    "05/11/2025": [
      {
        "label": "Entretien technique",
        "categorie": "Carrière",
        "heure_deb": "14:00",
        "heure_fin": "15:00",
        "localisation": "Google Meet",
        "color": Colors.teal, // 🧠 Carrière
      },
    ],

    "08/11/2025": [
      {
        "label": "Lecture du Coran",
        "categorie": "Spiritualité",
        "heure_deb": "19:00",
        "heure_fin": "19:30",
        "localisation": "Maison",
        "color": Colors.indigo, // ☪️ Spiritualité
      },
    ],

    "10/11/2025": [
      {
        "label": "Livraison projet client",
        "categorie": "Travail",
        "heure_deb": "09:00",
        "heure_fin": "11:00",
        "localisation": "Remote",
        "color": Colors.blueAccent,
      },
      {
        "label": "Appel avec Ahmed (freelance)",
        "categorie": "Réseautage",
        "heure_deb": "16:30",
        "heure_fin": "17:00",
        "localisation": "Google Meet",
        "color": Colors.cyan, // 🌐 Réseautage
      },
    ],

    "15/11/2025": [
      {
        "label": "Sortie entre amis",
        "categorie": "Loisirs",
        "heure_deb": "20:00",
        "heure_fin": "23:00",
        "localisation": "Café Boulevard",
        "color": Colors.pinkAccent, // 🎉 Loisirs
      },
    ],

    "20/11/2025": [
      {
        "label": "Mise à jour application mobile",
        "categorie": "Projet personnel",
        "heure_deb": "10:00",
        "heure_fin": "12:00",
        "localisation": "Maison",
        "color": Colors.purpleAccent,
      },
      {
        "label": "Visite médicale",
        "categorie": "Santé",
        "heure_deb": "15:30",
        "heure_fin": "16:00",
        "localisation": "Clinique Essalem",
        "color": Colors.green,
      },
    ],

    "25/11/2025": [
      {
        "label": "Réunion mensuelle d’équipe",
        "categorie": "Travail",
        "heure_deb": "09:00",
        "heure_fin": "10:00",
        "localisation": "Bureau central",
        "color": Colors.blueAccent,
      },
      {
        "label": "Courses mensuelles",
        "categorie": "Personnel",
        "heure_deb": "18:00",
        "heure_fin": "19:30",
        "localisation": "Monoprix",
        "color": Colors.orangeAccent,
      },
    ],

    "30/11/2025": [
      {
        "label": "Bilan du mois & planification décembre",
        "categorie": "Organisation",
        "heure_deb": "17:00",
        "heure_fin": "18:30",
        "localisation": "Maison",
        "color": Colors.brown, // 🗂️ Organisation
      },
    ],
  };

  CalendarFormat calendarFormat = CalendarFormat.month;

  bool isExtensible = true;

  @override
  void initState() {
    // TODO: implement initState

    _selectedDay = DateTime.now();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 32),
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2010, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),

            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              leftChevronIcon: Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.black54
              ),
              rightChevronIcon: Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.black54
              ),
              titleTextStyle: GoogleFonts.beVietnamPro(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: KPrimaryColor.withOpacity(.2),
                borderRadius: BorderRadius.circular(8),
              ),
              selectedDecoration: BoxDecoration(
                color: KPrimaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              markerDecoration: BoxDecoration(
                color: KPrimaryColor,
                shape: BoxShape.circle
              ),
              canMarkersOverflow: false,
              isTodayHighlighted: true,
              outsideDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              disabledTextStyle: GoogleFonts.beVietnamPro(

              ),

              selectedTextStyle: GoogleFonts.beVietnamPro(
                color: Colors.white
              ),

              defaultTextStyle: GoogleFonts.beVietnamPro(
                color: Colors.black
              ),

              holidayTextStyle: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.w600
              ),
              outsideTextStyle: GoogleFonts.beVietnamPro(
                color: Colors.grey
              ),
              todayTextStyle: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.w600,
              ),

              weekendTextStyle: GoogleFonts.beVietnamPro(

              ),

              weekNumberTextStyle: GoogleFonts.beVietnamPro(

              ),

              rangeEndTextStyle: GoogleFonts.beVietnamPro(

              ),

              withinRangeTextStyle: GoogleFonts.beVietnamPro(

              )
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final isSelected = isSameDay(_selectedDay, day);
                Color color = isSelected ? KPrimaryColor : KPrimaryColor.withOpacity(.5);

                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 0), // 🔥 désactive l'animation
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${day.day}',
                      style: GoogleFonts.beVietnamPro(

                      ),
                    ),
                  ),
                );
              },

              markerBuilder: (context, date, events) {
                if (events.isEmpty) return const SizedBox();

                // Vérifie si la date actuelle est sélectionnée
                final isSelected = isSameDay(_selectedDay, date);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: events.take(3).map((event) {
                    Color color = isSelected ? KPrimaryColor : KPrimaryColor.withOpacity(.5);

                    return Container(
                      margin: const EdgeInsets.all(0.5),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    );
                  }).toList(),
                );
              },

            ),

            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) async {

              print('selectedDay : $selectedDay');
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });


              final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDay);

              // Récupérer les tâches du jour
              final dayTasks = tasksByDay[formattedDate] ?? [];

              setState(() {
                if(dayTasks.length > 3){
                  calendarFormat = CalendarFormat.week;
                }
              });

              await showMaterialModalBottomSheet(
                context: context,
                duration: const Duration(milliseconds: 400),
                backgroundColor: Colors.transparent, // 🔥 Important : transparent ici
                barrierColor: KPrimaryColor.withOpacity(.1),
                enableDrag: false,
                builder: (context) => EventsByDateWidget(
                  selectedDate: _selectedDay ?? DateTime.now(),
                  tasksByDate: dayTasks
                ),
              );

              setState(() {
                calendarFormat = CalendarFormat.month;
              });

            },

            eventLoader: (day) {
              final formatted = DateFormat('dd/MM/yyyy').format(day);
              return tasksByDay.containsKey(formatted) ? tasksByDay[formatted]! : [];
            },
            calendarFormat: calendarFormat,
            formatAnimationCurve: Curves.easeIn,


            onPageChanged: (e){
              print('fsdfsd : $e');
            },

          ),
        ],
      ),
    );
  }
}
