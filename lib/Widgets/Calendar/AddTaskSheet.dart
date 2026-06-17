import 'package:flutter/material.dart';
import 'package:muslim_proj/Constants.dart';



class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key});
  @override State<AddTaskSheet> createState() => AddTaskSheetState();
}

class AddTaskSheetState extends State<AddTaskSheet> {
  final _labelCtrl = TextEditingController();
  final _noteCtrl  = TextEditingController();
  TimeOfDay? _time;
  TaskCategory _cat = TaskCategory.custom;

  static const _cats = [
    (TaskCategory.custom, 'Tâche'), (TaskCategory.doua, 'Doua'),
    (TaskCategory.dhikr,  'Dhikr'), (TaskCategory.coran, 'Coran'),
  ];

  @override void dispose() { _labelCtrl.dispose(); _noteCtrl.dispose(); super.dispose(); }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context, initialTime: _time ?? TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(
            primary: KPrimaryColor, onPrimary: Colors.white, surface: Colors.white)),
        child: child!,
      ),
    );
    if (t != null) setState(() => _time = t);
  }

  void _submit() {
    final label = _labelCtrl.text.trim();
    if (label.isEmpty) return;
    final timeStr = _time != null
        ? '${_time!.hour.toString().padLeft(2,'0')}:${_time!.minute.toString().padLeft(2,'0')}'
        : '';
    Navigator.pop(context, IslamicTask(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      label: label,
      subtitle: _noteCtrl.text.trim().isNotEmpty ? _noteCtrl.text.trim() : 'Tâche personnalisée',
      time: timeStr,
      sortMinutes: _time != null ? _time!.hour * 60 + _time!.minute : 9999,
      category: _cat, isCustom: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              color: KBackgroundColor,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24)
              )
          ),
          padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottom),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(2)
                        )
                    )
                ),
                const SizedBox(height: 20),
                Text(
                    'Nouvelle tâche',
                    style: amiri(22, kPrimaryDark)
                ),
                const SizedBox(height: 18),
                _lbl('Titre'),
                const SizedBox(height: 6),
                _field(_labelCtrl, 'Ex : Lire Sourat Al-Kahf'),
                const SizedBox(height: 14),
                _lbl('Note (optionnel)'),
                const SizedBox(height: 6),
                _field(_noteCtrl, 'Description...', maxLines: 2),
                const SizedBox(height: 14),
                _lbl('Catégorie'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: _cats.map((c) {
                    final sel = _cat == c.$1;
                    final col = IslamicTask(
                        id:'',
                        label:'',
                        subtitle:'',
                        time:'',
                        sortMinutes: 0,
                        category: c.$1
                    ).color;
                    return GestureDetector(
                      onTap: () => setState(() => _cat = c.$1),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                            color: sel ? col : col.withOpacity(.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: sel ? col : col.withOpacity(.3)
                                , width: 1.5
                            )
                        ),
                        child: Text(c.$2, style: viet(12, sel ? Colors.white : col, fw: FontWeight.w600)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                _lbl('Horaire (optionnel)'), const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: _time != null ? KPrimaryColor : Colors.black12,
                            width: 1.5
                        )
                    ),
                    child: Row(
                        children: [
                          Icon(
                              Icons.access_time_rounded,
                              color: _time != null ? KPrimaryColor : Colors.black38, size: 20
                          ),
                          const SizedBox(width: 10),
                          Text(
                              _time != null ? '${_time!.hour.toString().padLeft(2,'0')}:${_time!.minute.toString().padLeft(2,'0')}' : 'Choisir un horaire',
                              style: viet(
                                  14, _time != null ? KPrimaryColor : Colors.black38,
                                  fw: _time != null ? FontWeight.w600 : FontWeight.w400
                              )
                          ),
                          const Spacer(),
                          if (_time != null)
                            GestureDetector(
                                onTap: () => setState(() => _time = null),
                                child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.black38
                                )
                            ),
                        ]),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _labelCtrl.text.trim().isNotEmpty ? _submit : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: KPrimaryColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.black12,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0
                    ),
                    child: Text('Ajouter', style: viet(15, Colors.white, fw: FontWeight.w600)),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Widget _lbl(String t) => Text(t, style: viet(11, Colors.black45, fw: FontWeight.w600));

  Widget _field(TextEditingController c, String hint, {int maxLines = 1}) => TextField(
    controller: c, maxLines: maxLines, onChanged: (_) => setState(() {}),
    style: viet(14, Colors.black87),
    decoration: InputDecoration(
      hintText: hint, hintStyle: viet(14, Colors.black38),
      filled: true, fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: KPrimaryColor, width: 1.5)),
    ),
  );
}



