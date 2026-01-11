import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Widgets/Calendar/EventsByDateWidget.dart';
import 'package:muslim_proj/Widgets/Calendar/TaskDetails.dart';
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

  CalendarFormat calendarFormat = CalendarFormat.week;

  List<Map<String,dynamic>> dayTasks = [];

  bool isExtensible = true;

  @override
  void initState() {
    // TODO: implement initState

    _selectedDay = DateTime.now();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 48),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: KPrimaryColor.withOpacity(0.2),
                width: 2
              )
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2010, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),

                headerStyle: HeaderStyle(
                  titleCentered: true,
                  decoration: BoxDecoration(
                    color: Colors.red
                  ),
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

                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });


                  final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDay);

                  // Récupérer les tâches du jour
                  dayTasks = tasksByDay[formattedDate] ?? [];

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
                    calendarFormat = CalendarFormat.week;
                  });

                },

                eventLoader: (day) {
                  final formatted = DateFormat('dd/MM/yyyy').format(day);
                  return tasksByDay.containsKey(formatted) ? tasksByDay[formatted]! : [];
                },

                calendarFormat: calendarFormat,
                formatAnimationCurve: Curves.easeIn,
                pageJumpingEnabled: true,
                pageAnimationEnabled: true,
                daysOfWeekVisible: true,
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: GoogleFonts.beVietnamPro(
                    color: KPrimaryColor,
                    fontWeight: FontWeight.w600
                  ),
                  weekdayStyle: GoogleFonts.beVietnamPro(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500
                  ),

                  dowTextFormatter: (date, locale) {
                    return DateFormat.E(locale).format(date).characters.first.toUpperCase();
                  },
                ),

                headerVisible: false,

              ),
            ),
          ),
        ),


        Expanded(
          child: Container(
              decoration: BoxDecoration(
                color: KPrimaryColor,
                border: Border.all(
                  color: KBackgroundColor,
                  width: 0
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- Petite barre grise en haut (drag handle) ---
                  Container(
                    decoration: BoxDecoration(
                        color: KPrimaryColor
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  height: 5,
                                  width: 5,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle
                                  ),
                                ),
                                SizedBox(width: 12),

                                Text(
                                  formattedDate(_selectedDay ?? DateTime.now()),
                                  style: GoogleFonts.beVietnamPro(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500
                                  ),
                                )
                              ],
                            ),
                          ),

                          GestureDetector(
                            onTap:() {

                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: KPrimaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  // --- Contenu principal ---
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                          color: KBackgroundColor,
                          border: Border.all(
                            color: KBackgroundColor
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: dayTasks.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final task = dayTasks[index];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                                  child: Dismissible(
                                    key: ValueKey(task['label'] + task['heure_deb']),
                                    background: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(left: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(.8),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child:  Row(
                                        children: [
                                          Icon(Icons.edit, color: Colors.white),
                                          SizedBox(width: 8),
                                          Text("Modifier", style: GoogleFonts.beVietnamPro(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                    secondaryBackground: Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(.8),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Icon(Icons.delete_outline, color: Colors.white),
                                          SizedBox(width: 8),
                                          Text("Supprimer", style: GoogleFonts.beVietnamPro(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                    confirmDismiss: (direction) async {
                                      if (direction == DismissDirection.startToEnd) {
                                        // 🔧 Action : Modifier
                                        await showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: const Text("Modifier la tâche"),
                                            content: const Text("Souhaitez-vous modifier cette tâche ?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text("Annuler"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  // TODO: ouvrir un modal ou page d’édition ici
                                                },
                                                child: const Text("Modifier"),
                                              ),
                                            ],
                                          ),
                                        );
                                        return false; // ne pas supprimer l'élément
                                      } else if (direction == DismissDirection.endToStart) {
                                        // 🗑️ Action : Supprimer
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: const Text("Supprimer la tâche"),
                                            content: const Text("Êtes-vous sûr de vouloir supprimer cette tâche ?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, false),
                                                child: const Text("Annuler"),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, true),
                                                child: Text("Supprimer", style: GoogleFonts.beVietnamPro(color: Colors.red)),
                                              ),
                                            ],
                                          ),
                                        );
                                        return confirm ?? false;
                                      }
                                      return false;
                                    },
                                    onDismissed: (direction) {
                                      // Supprimer l’élément
                                      setState(() {
                                        dayTasks.removeAt(index);
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Tâche supprimée'),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      curve: Curves.easeInOut,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: task['color'].withOpacity(.15),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: task['color'], width: 1),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Catégorie
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: task['color'],
                                                  borderRadius: BorderRadius.circular(16),
                                                ),
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                child: Text(
                                                  task['categorie'].toString().toUpperCase(),
                                                  style: GoogleFonts.beVietnamPro(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),



                                              GestureDetector(
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetails(task: task)));
                                                },
                                                child: SvgPicture.asset(
                                                  "assets/icons/menu-dots-vertical2.svg",
                                                  fit: BoxFit.contain,
                                                  height: 20,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 8),

                                          // Label + heure + localisation
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  task['label'],
                                                  style: GoogleFonts.beVietnamPro(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),

                                              const SizedBox(width: 8),

                                              Text(
                                                "${task['heure_deb']} - ${task['heure_fin']}",
                                                style: GoogleFonts.beVietnamPro(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),

                                              const SizedBox(width: 8),

                                              Container(
                                                height: 14,
                                                width: 2,
                                                decoration: BoxDecoration(
                                                  color: Colors.black26,
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                              ),

                                              const SizedBox(width: 8),

                                              Text(
                                                task['localisation'],
                                                style: GoogleFonts.beVietnamPro(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )

                        )
                    ),
                  ),
                ],
              )
          ),
        )
      ],
    );
  }


  String formattedDate (DateTime selectedDate){
    // 'Tuesday, 23 Junaury 2025'
    return DateFormat('dd MMMM yyyy').format(selectedDate);
  }

}
