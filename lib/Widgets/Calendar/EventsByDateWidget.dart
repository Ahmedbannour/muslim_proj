import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Widgets/Calendar/TaskDetails.dart';


class EventsByDateWidget extends StatefulWidget {

  final DateTime selectedDate;
  final List<Map<String,dynamic>> tasksByDate;
  const EventsByDateWidget({super.key , required this.selectedDate , required this.tasksByDate});

  @override
  State<EventsByDateWidget> createState() => _EventsByDateWidgetState();
}


class _EventsByDateWidgetState extends State<EventsByDateWidget> {

  late DateTime selectedDate;
  late List<Map<String,dynamic>> tasksByDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectedDate = widget.selectedDate;
    tasksByDate = widget.tasksByDate;
  }


  @override
  void didUpdateWidget(covariant EventsByDateWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if(selectedDate != widget.selectedDate){
      selectedDate = widget.selectedDate;
    }
    if(tasksByDate != widget.tasksByDate){
      tasksByDate = widget.tasksByDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: KPrimaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, -3),
              blurRadius: 8,
            ),
          ],
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
                            formattedDate(selectedDate),
                            style: TextStyle(
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
            Row(
              children: [
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 200,
                      maxHeight: (MediaQuery.of(context).size.height / 4) * 2
                    ),
                    decoration: BoxDecoration(
                      color: KBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: tasksByDate.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final task = tasksByDate[index];

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
                                child: const Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text("Modifier", style: TextStyle(color: Colors.white)),
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
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.delete_outline, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text("Supprimer", style: TextStyle(color: Colors.white)),
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
                                          child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
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
                                  tasksByDate.removeAt(index);
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
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
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
                                            style: const TextStyle(
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
                                          style: const TextStyle(
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
                                          style: const TextStyle(
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
            ),
          ],
        )
      ),
    );
  }



  String formattedDate (DateTime selectedDate){
    // 'Tuesday, 23 Junaury 2025'
    return DateFormat('EEEE, dd MMMM yyyy').format(selectedDate);
  }
}
