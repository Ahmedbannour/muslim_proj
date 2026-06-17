import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Widgets/Calendar/AddTaskSheet.dart';
import 'package:muslim_proj/Widgets/Calendar/AdhkarPage.dart';
import 'package:muslim_proj/Widgets/Calendar/DouaListPage.dart';

class TaskStorageService {
  static const _tasksKey = 'tasks';
  static Box get _box => Hive.box('muslim_proj');

  static Map<String, List<IslamicTask>> loadAll() {
    final result = <String, List<IslamicTask>>{};
    try {
      final raw = _box.get(_tasksKey);
      if (raw == null) return result;
      final list = (jsonDecode(raw as String) as List).cast<Map<String, dynamic>>();
      for (final entry in list) {
        final dateKey = entry['dateKey'] as String;
        final task = IslamicTask.fromJson(entry['task'] as Map<String, dynamic>);
        result.putIfAbsent(dateKey, () => []).add(task);
      }
    } catch (_) {}
    return result;
  }

  static Future<void> saveAll(Map<String, List<IslamicTask>> allTasks) async {
    final flatList = <Map<String, dynamic>>[];
    for (final entry in allTasks.entries) {
      for (final task in entry.value) {
        flatList.add({'dateKey': entry.key, 'task': task.toJson()});
      }
    }
    await _box.put(_tasksKey, jsonEncode(flatList));
  }
}


class LocationService {
  static Future<Position?> get() async {
    if (!await Geolocator.isLocationServiceEnabled()) return null;
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) return null;
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
      timeLimit: const Duration(seconds: 10),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SERVICE ALADHAN — avec méthode hijri-first
// ═══════════════════════════════════════════════════════════════════════════════

class AladhanService {
  static const _base = 'https://api.aladhan.com/v1';

  /// Convertit une date grégorienne → hijri pour obtenir le mois courant
  static Future<HijriMonth> getCurrentHijriMonth() async {
    final today = DateTime.now();
    final dateStr = DateFormat('dd-MM-yyyy').format(today);
    final res = await http.get(Uri.parse('$_base/gToH?date=$dateStr'));
    if (res.statusCode != 200) throw Exception('Conversion hijri indisponible');
    final hijri = jsonDecode(res.body)['data']['hijri'];
    return HijriMonth(
      month: int.parse(hijri['month']['number'].toString()),
      year:  int.parse(hijri['year'].toString()),
    );
  }

  /// Récupère tous les jours d'un mois hijri donné (API hToGCalendar)
  static Future<List<HijriDay>> getMonthByHijri(int hijriMonth, int hijriYear) async {
    final res = await http.get(
        Uri.parse('$_base/hToGCalendar/$hijriMonth/$hijriYear'));
    if (res.statusCode != 200) throw Exception('Calendrier hijri indisponible');

    return (jsonDecode(res.body)['data'] as List).map<HijriDay>((item) {
      final greg  = item['gregorian'] as Map<String, dynamic>;
      final hijri = item['hijri']     as Map<String, dynamic>;
      // L'API hToGCalendar retourne la date grégorienne au format "dd-MM-yyyy"
      final p = (greg['date'] as String).split('-');
      return HijriDay(
        gregDay:   int.parse(p[0]),
        gregMonth: int.parse(p[1]),
        gregYear:  int.parse(p[2]),
        hijriDay:  int.parse(hijri['day'] as String),
        hijriMonth: int.parse(hijri['month']['number'].toString()),
        hijriYear: int.parse(hijri['year'] as String),
        hijriMonthAr: hijri['month']['ar'] as String,
        weekdayAr: hijri['weekday']['ar'] as String,
      );
    }).toList();
  }

  static Future<Map<String, String>> getPrayerTimes({
    required DateTime date, required double lat, required double lng, int method = 3,
  }) async {
    final ts = (date.millisecondsSinceEpoch ~/ 1000).toString();
    final res = await http.get(Uri.parse(
        '$_base/timings/$ts?latitude=$lat&longitude=$lng&method=$method'));
    if (res.statusCode != 200) throw Exception('Horaires indisponibles');
    final t = jsonDecode(res.body)['data']['timings'] as Map<String, dynamic>;
    const keys = ['Fajr','Dhuhr','Asr','Maghrib','Isha'];
    return {for (final k in keys) k: (t[k] as String).substring(0, 5)};
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════════════════════════════════════════════

bool isPrayerPassed(IslamicTask task, DateTime selectedDay) {
  if (task.category != TaskCategory.priere) return false;
  if (task.time.isEmpty || task.sortMinutes == 9999) return false;
  final now   = DateTime.now();
  final sel   = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
  final today = DateTime(now.year, now.month, now.day);
  if (sel.isBefore(today)) return true;
  if (sel.isAtSameMomentAs(today)) return task.sortMinutes < now.hour * 60 + now.minute;
  return false;
}

int _toMin(String hhmm) {
  if (!hhmm.contains(':')) return 9999;
  final p = hhmm.split(':');
  return int.parse(p[0]) * 60 + int.parse(p[1]);
}

const _prayerAr = {'Fajr':'الفجر','Dhuhr':'الظهر','Asr':'العصر','Maghrib':'المغرب','Isha':'العشاء'};
const _prayerFr = {'Fajr':'Aube','Dhuhr':'Midi','Asr':'Après-midi','Maghrib':'Coucher','Isha':'Nuit'};

List<IslamicTask> buildSystemTasks(Map<String, String> prayers) {
  final list = <IslamicTask>[];
  for (final e in prayers.entries) {
    list.add(IslamicTask(
      id: 'sys_prayer_${e.key}',
      label: '${e.key}  ${_prayerAr[e.key] ?? ''}',
      subtitle: 'Prière obligatoire · ${_prayerFr[e.key] ?? ''}',
      time: e.value, sortMinutes: _toMin(e.value),
      category: TaskCategory.priere,
    ));
  }
  final fajrMin = _toMin(prayers['Fajr'] ?? '05:00');
  final asrMin  = _toMin(prayers['Asr']  ?? '15:00');
  list.addAll([
    IslamicTask(id:'sys_dhikr_morning', label:'أذكار الصباح', subtitle:'Adhkâr du matin · 5 dhikr',
        time: prayers['Fajr'] ?? '05:00', sortMinutes: fajrMin + 5, category: TaskCategory.dhikr),
    IslamicTask(id:'sys_doua', label:'الدعاء', subtitle:'Doua du jour',
        time: prayers['Fajr'] ?? '05:00', sortMinutes: fajrMin + 10, category: TaskCategory.doua),
    IslamicTask(id:'sys_quran', label:'تلاوة القرآن', subtitle:'Lecture quotidienne',
        time: prayers['Fajr'] ?? '05:00', sortMinutes: fajrMin + 15, category: TaskCategory.coran),
    IslamicTask(id:'sys_dhikr_evening', label:'أذكار المساء', subtitle:'Adhkâr du soir · 5 dhikr',
        time: prayers['Asr'] ?? '15:00', sortMinutes: asrMin + 5, category: TaskCategory.dhikr),
  ]);
  list.sort((a, b) => a.sortMinutes.compareTo(b.sortMinutes));
  return list;
}


Future<IslamicTask?> showAddTaskModal(BuildContext context) =>
    showModalBottomSheet<IslamicTask>(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (_) => const AddTaskSheet(),
    );


class TaskCard extends StatelessWidget {
  final IslamicTask task;
  final bool selectionMode, isSelected, isPast;
  final VoidCallback? onTap, onLongPress, onDelete, onAdhkarTap;

  const TaskCard({
    required this.task,
    this.selectionMode = false, this.isSelected = false, this.isPast = false,
    this.onTap, this.onLongPress, this.onDelete, this.onAdhkarTap,
    super.key,
  });

  static IconData _icon(TaskCategory c) {
    switch (c) {
      case TaskCategory.priere: return Icons.mosque_outlined;
      case TaskCategory.doua:   return Icons.front_hand_outlined;
      case TaskCategory.dhikr:  return Icons.repeat_rounded;
      case TaskCategory.coran:  return Icons.menu_book_outlined;
      case TaskCategory.custom: return Icons.star_outline_rounded;
    }
  }

  static String _badge(TaskCategory c) {
    switch (c) {
      case TaskCategory.priere: return 'Prière';
      case TaskCategory.doua:   return 'Doua';
      case TaskCategory.dhikr:  return 'Dhikr';
      case TaskCategory.coran:  return 'Coran';
      case TaskCategory.custom: return 'Tâche';
    }
  }

  @override
  Widget build(BuildContext context) {
    final c             = isPast ? kGrey : task.color;
    final labelColor    = isPast ? Colors.black38 : Colors.black87;
    final subtitleColor = isPast ? Colors.black26 : Colors.black45;

    return Dismissible(
      key: ValueKey('dismiss_${task.id}'),
      direction: task.isCustom ? DismissDirection.endToStart : DismissDirection.none,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(color: Colors.red.shade400, borderRadius: BorderRadius.circular(16)),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          const Icon(Icons.delete_outline, color: Colors.white),
          const SizedBox(width: 6),
          Text('Supprimer', style: viet(13, Colors.white, fw: FontWeight.w600)),
        ]),
      ),
      confirmDismiss: (_) async {
        if (!task.isCustom) return false;
        return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text('Supprimer ?', style: amiri(18, kPrimaryDark)),
            content: Text('Supprimer « ${task.label} » ?', style: viet(13, Colors.black54)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false),
                  child: Text('Annuler', style: viet(13, Colors.black54))),
              TextButton(onPressed: () => Navigator.pop(context, true),
                  child: Text('Supprimer', style: viet(13, Colors.red))),
            ],
          ),
        ) ?? false;
      },
      onDismissed: (_) => onDelete?.call(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
              color: isPast ? Colors.grey.shade50 : (isSelected ? c.withOpacity(.08) : Colors.white),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: isPast ? Colors.grey.shade200 : (isSelected ? c : c.withOpacity(.2)),
                  width: isSelected ? 1.8 : 1.2)),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                if (task.category == TaskCategory.dhikr && !task.isCustom) {
                  onAdhkarTap?.call();
                } else { onTap?.call(); }
              },
              onLongPress: task.isCustom ? onLongPress : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(children: [
                  if (task.isCustom) ...[
                    Icon(Icons.drag_handle_rounded, color: Colors.black26, size: 18),
                    const SizedBox(width: 4),
                  ],
                  if (selectionMode && task.isCustom) ...[
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 20, height: 20,
                      decoration: BoxDecoration(
                          color: isSelected ? c : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: isSelected ? c : Colors.black26, width: 1.5)),
                      child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 13) : null,
                    ),
                    const SizedBox(width: 10),
                  ],
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(color: c.withOpacity(.1), borderRadius: BorderRadius.circular(10)),
                    child: Stack(alignment: Alignment.center, children: [
                      Icon(_icon(task.category), color: c, size: 20),
                      if (isPast)
                        Positioned(right: 2, bottom: 2,
                            child: Container(width: 13, height: 13,
                                decoration: const BoxDecoration(color: kGrey, shape: BoxShape.circle),
                                child: const Icon(Icons.check, color: Colors.white, size: 9))),
                    ]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(task.label,
                          style: task.label.contains(RegExp(r'[\u0600-\u06FF]'))
                              ? amiri(15, labelColor)
                              : viet(14, labelColor, fw: FontWeight.w600)),
                      Text(task.subtitle, style: viet(11, subtitleColor)),
                      if (isPast) Text('Passée', style: viet(10, kGrey, fw: FontWeight.w500)),
                    ]),
                  ),
                  const SizedBox(width: 8),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    if (task.time.isNotEmpty)
                      Text(task.time,
                          style: viet(12, isPast ? Colors.black26 : Colors.black54, fw: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: c.withOpacity(.1), borderRadius: BorderRadius.circular(20)),
                      child: Text(_badge(task.category), style: viet(10, c, fw: FontWeight.w600)),
                    ),
                    if (task.category == TaskCategory.dhikr && !task.isCustom) ...[
                      const SizedBox(height: 4),
                      Icon(Icons.chevron_right_rounded, color: kGold, size: 16),
                    ],
                  ]),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class HijriCalendarWidget extends StatefulWidget {
  const HijriCalendarWidget({super.key});
  @override State<HijriCalendarWidget> createState() => _HijriCalendarWidgetState();
}

class _HijriCalendarWidgetState extends State<HijriCalendarWidget> {

  // ── Mois hijri affiché (source de vérité de la navigation) ─────────────────
  HijriMonth _displayHijriMonth = const HijriMonth(month: 1, year: 1446); // fallback

  List<HijriDay> _hijriDays    = [];
  bool _loadingCalendar = true;
  String? _calendarError;

  DateTime  _selectedDay     = DateTime.now();
  HijriDay? _selectedHijriDay;

  double _lat = 36.8065, _lng = 10.1815;
  bool _locationLoaded = false;

  bool _loadingPrayers = false;
  List<IslamicTask> _systemTasks = [];

  final Map<String, List<IslamicTask>> _customByDate = {};
  bool _selectionMode = false;
  final Set<String> _selectedIds = {};

  // ── Init ────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _customByDate.addAll(TaskStorageService.loadAll());
    _initLocation();
    _loadCurrentHijriMonth(); // ← démarre sur le mois hijri courant
  }

  // ── Géolocalisation ─────────────────────────────────────────────────────────

  Future<void> _initLocation() async {
    final pos = await LocationService.get();
    if (pos != null && mounted) {
      setState(() { _lat = pos.latitude; _lng = pos.longitude; _locationLoaded = true; });
      _loadPrayers(_selectedDay);
    }
  }

  // ── Chargement initial : détecter le mois hijri actuel via API ──────────────

  Future<void> _loadCurrentHijriMonth() async {
    setState(() { _loadingCalendar = true; _calendarError = null; _hijriDays = []; });
    try {
      final hm = await AladhanService.getCurrentHijriMonth();
      _displayHijriMonth = hm;
      await _loadHijriMonth(hm);
    } catch (e) {
      if (!mounted) return;
      setState(() { _loadingCalendar = false; _calendarError = '$e'; });
    }
  }

  // ── Charger les jours d'un mois hijri ────────────────────────────────────────

  Future<void> _loadHijriMonth(HijriMonth hm) async {
    setState(() { _loadingCalendar = true; _calendarError = null; _hijriDays = []; });
    try {
      final days = await AladhanService.getMonthByHijri(hm.month, hm.year);
      if (!mounted) return;
      setState(() { _hijriDays = days; _loadingCalendar = false; });

      // Sélectionner aujourd'hui si présent dans ce mois, sinon premier jour
      final today = DateTime.now();
      final todayInMonth = days.any((d) =>
      d.gregorianDate.year  == today.year &&
          d.gregorianDate.month == today.month &&
          d.gregorianDate.day   == today.day);

      if (todayInMonth) {
        setState(() => _selectedDay = today);
        _loadPrayers(today);
      } else if (days.isNotEmpty) {
        setState(() => _selectedDay = days.first.gregorianDate);
        _loadPrayers(days.first.gregorianDate);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() { _loadingCalendar = false; _calendarError = '$e'; });
    }
  }

  // ── Prières ────────────────────────────────────────────────────────────────

  Future<void> _loadPrayers(DateTime date) async {
    setState(() { _loadingPrayers = true; _systemTasks = []; });
    try {
      final times = await AladhanService.getPrayerTimes(date: date, lat: _lat, lng: _lng);
      if (!mounted) return;
      setState(() {
        _systemTasks = buildSystemTasks(times);
        _loadingPrayers = false;
        _selectedHijriDay = _hijriDays.firstWhere(
              (d) => d.gregorianDate.year  == date.year &&
              d.gregorianDate.month == date.month &&
              d.gregorianDate.day   == date.day,
          orElse: () => _hijriDays.isNotEmpty ? _hijriDays.first : HijriDay(
              gregDay: date.day, gregMonth: date.month, gregYear: date.year,
              hijriDay: 1, hijriMonth: _displayHijriMonth.month,
              hijriYear: _displayHijriMonth.year, hijriMonthAr: '', weekdayAr: ''),
        );
      });
    } catch (_) {
      if (mounted) setState(() => _loadingPrayers = false);
    }
  }

  // ── Navigation hijri ────────────────────────────────────────────────────────

  void _prevMonth() {
    final p = _displayHijriMonth.prev;
    setState(() => _displayHijriMonth = p);
    _loadHijriMonth(p);
  }

  void _nextMonth() {
    final n = _displayHijriMonth.next;
    setState(() => _displayHijriMonth = n);
    _loadHijriMonth(n);
  }

  void _selectDay(HijriDay d) {
    setState(() {
      _selectedDay = d.gregorianDate;
      _selectionMode = false;
      _selectedIds.clear();
    });
    _loadPrayers(d.gregorianDate);
  }

  // ── Tâches ──────────────────────────────────────────────────────────────────

  String get _dateKey  => DateFormat('dd/MM/yyyy').format(_selectedDay);
  List<IslamicTask> get _customTasks => List.of(_customByDate[_dateKey] ?? []);
  List<IslamicTask> get _systemSorted {
    final s = List.of(_systemTasks);
    s.sort((a, b) => a.sortMinutes.compareTo(b.sortMinutes));
    return s;
  }

  Future<void> _addTask() async {
    final t = await showAddTaskModal(context);
    if (t == null) return;
    setState(() { _customByDate.putIfAbsent(_dateKey, () => []).add(t); });
    await TaskStorageService.saveAll(_customByDate);
  }

  Future<void> _deleteTask(String id) async {
    setState(() {
      _customByDate[_dateKey]?.removeWhere((t) => t.id == id);
      if (_customByDate[_dateKey]?.isEmpty ?? false) _customByDate.remove(_dateKey);
    });
    await TaskStorageService.saveAll(_customByDate);
  }

  Future<void> _deleteSelected() async {
    setState(() {
      for (final id in _selectedIds) {
        _customByDate[_dateKey]?.removeWhere((t) => t.id == id);
      }
      if (_customByDate[_dateKey]?.isEmpty ?? false) _customByDate.remove(_dateKey);
      _selectedIds.clear();
      _selectionMode = false;
    });
    await TaskStorageService.saveAll(_customByDate);
  }

  void _toggleSel(String id) => setState(() {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
      if (_selectedIds.isEmpty) _selectionMode = false;
    } else { _selectedIds.add(id); }
  });

  Future<void> _onReorder(int oldIdx, int newIdx) async {
    final list = _customByDate[_dateKey];
    if (list == null) return;
    if (newIdx > oldIdx) newIdx--;
    setState(() { final item = list.removeAt(oldIdx); list.insert(newIdx, item); });
    await TaskStorageService.saveAll(_customByDate);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 48),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: _buildCalendarCard(),
      ),
      Expanded(child: _buildTasksSection()),
    ]);
  }

  // ── CALENDRIER ───────────────────────────────────────────────────────────────

  Widget _buildCalendarCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: KPrimaryColor.withOpacity(.15), width: 1.5),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          _buildCalHeader(),
          const SizedBox(height: 8),
          _buildDow(),
          const SizedBox(height: 4),
          if (_loadingCalendar)
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: CircularProgressIndicator(color: KPrimaryColor, strokeWidth: 2))
          else if (_calendarError != null)
            Padding(padding: const EdgeInsets.all(16),
                child: Text(_calendarError!, style: viet(12, Colors.red)))
          else
            _buildGrid(),
        ]),
      ),
    );
  }

  /// En-tête : mois hijri en arabe (principal) + fourchette grégorienne (secondaire)
  Widget _buildCalHeader() {
    final monthName = hijriMonthsAr[_displayHijriMonth.month] ?? '';
    final yearAr    = toArabicNumerals(_displayHijriMonth.year);

    return Row(children: [
      _navBtn(Icons.chevron_left_rounded, _prevMonth),
      Expanded(
        child: Column(children: [
          // ── Mois hijri — SOURCE DE VÉRITÉ ──
          Text(
            '$monthName $yearAr',
            textAlign: TextAlign.center,
            style: amiri(20, kPrimaryDark),
          ),
          // ── Fourchette grégorienne indicative ──
          if (_hijriDays.isNotEmpty)
            Text(
              _gregRange(),
              style: viet(11, Colors.black38, fw: FontWeight.w500),
            ),
        ]),
      ),
      _navBtn(Icons.chevron_right_rounded, _nextMonth),
    ]);
  }

  /// Ex : "Mar – Avr 2025"
  String _gregRange() {
    if (_hijriDays.isEmpty) return '';
    final first = _hijriDays.first.gregorianDate;
    final last  = _hijriDays.last.gregorianDate;
    final fmt   = DateFormat('MMM', 'fr_FR');
    if (first.month == last.month && first.year == last.year) {
      return DateFormat('MMMM yyyy', 'fr_FR').format(first);
    }
    final yearSuffix = first.year == last.year ? '' : ' ${last.year}';
    return '${fmt.format(first)} – ${fmt.format(last)}$yearSuffix ${last.year}';
  }

  Widget _navBtn(IconData icon, VoidCallback fn) => GestureDetector(
    onTap: fn,
    child: Container(
      width: 34, height: 34,
      decoration: BoxDecoration(color: kPrimaryXLight, borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, color: KPrimaryColor, size: 22),
    ),
  );

  Widget _buildDow() {
    const labels  = ['Dim','Lun','Mar','Mer','Jeu','Ven','Sam'];
    const weekend = {0, 5, 6};
    return Row(
      children: List.generate(7, (i) => Expanded(
        child: Text(labels[i], textAlign: TextAlign.center,
            style: viet(11, weekend.contains(i) ? KPrimaryColor : Colors.black38,
                fw: FontWeight.w600)),
      )),
    );
  }

  /// Grille basée sur les jours hijri du mois
  Widget _buildGrid() {
    if (_hijriDays.isEmpty) return const SizedBox();
    // L'offset est le weekday grégorien du 1er jour hijri du mois (0 = dimanche)
    final offset = _hijriDays.first.gregorianDate.weekday % 7;
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 3,
      crossAxisSpacing: 1,
      childAspectRatio: 0.95,
      children: [
        for (int i = 0; i < offset; i++) const SizedBox(),
        for (final day in _hijriDays) _buildDayCell(day),
      ],
    );
  }

  /// Cellule : jour hijri EN GRAND (chiffres arabes) + jour grégorien en petit
  Widget _buildDayCell(HijriDay day) {
    final isSel    = _isSameDay(day.gregorianDate, _selectedDay);
    final isToday  = _isSameDay(day.gregorianDate, DateTime.now());
    final hasCustom = (_customByDate[
    DateFormat('dd/MM/yyyy').format(day.gregorianDate)] ?? []).isNotEmpty;

    Color bg = Colors.transparent;
    Color numColor = Colors.black87, subColor = Colors.black38;
    if (isSel)        { bg = KPrimaryColor; numColor = Colors.white;    subColor = Colors.white60; }
    else if (isToday) { bg = kPrimaryXLight; numColor = KPrimaryColor; subColor = kPrimaryLight; }

    return GestureDetector(
      onTap: () => _selectDay(day),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: isToday && !isSel ? Border.all(color: KPrimaryColor.withOpacity(.3), width: 1) : null,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // ── Jour hijri en grand (chiffres arabes) ──
          Text(
            toArabicNumerals(day.hijriDay),
            style: amiri(14, numColor),
          ),
          // ── Jour grégorien en petit (secondaire) ──
          Text(
            '${day.gregDay}',
            style: viet(9, subColor, fw: FontWeight.w400),
          ),
          // ── Point doré si tâche custom ──
          if (hasCustom)
            Container(
              margin: const EdgeInsets.only(top: 1),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                  color: isSel ? Colors.white : kGold,
                  shape: BoxShape.circle
              ),
            ),
        ]),
      ),
    );
  }

  // ── SECTION TÂCHES ──────────────────────────────────────────────────────────

  Widget _buildTasksSection() {
    final hijri = _selectedHijriDay;
    final hijriLabel = hijri != null
        ? '${toArabicNumerals(hijri.hijriDay)} ${hijriMonthsAr[hijri.hijriMonth] ?? ''} ${toArabicNumerals(hijri.hijriYear)}'
        : '';

    return Container(
      decoration: const BoxDecoration(
        color: KPrimaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(hijriLabel, style: amiri(16, Colors.white)),
                Row(children: [
                  Container(width: 5, height: 5,
                      decoration: const BoxDecoration(color: kGold, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text(DateFormat('EEE dd MMM', 'fr_FR').format(_selectedDay),
                      style: viet(11, Colors.white60)),
                  if (!_locationLoaded) ...[
                    const SizedBox(width: 8),
                    const SizedBox(width: 10, height: 10,
                        child: CircularProgressIndicator(color: kGold, strokeWidth: 1.5)),
                  ],
                ]),
              ]),
            ),

            // Bouton doua
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DouaListPage())),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                child: Row(children: [
                  const Icon(Icons.front_hand_outlined, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text('الدعاء', style: amiri(13, Colors.white)),
                ]),
              ),
            ),

            if (_selectionMode && _selectedIds.isNotEmpty)
              GestureDetector(
                onTap: _deleteSelected,
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.red.shade400, borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const Icon(Icons.delete_outline, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text('${_selectedIds.length}',
                        style: viet(12, Colors.white, fw: FontWeight.w600)),
                  ]),
                ),
              ),

            if (_selectionMode)
              GestureDetector(
                onTap: () => setState(() { _selectionMode = false; _selectedIds.clear(); }),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                  child: Text('✕', style: viet(12, Colors.white)),
                ),
              ),

            GestureDetector(
              onTap: _addTask,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.add_rounded, color: KPrimaryColor, size: 20),
              ),
            ),
          ]),
        ),

        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: KBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: _loadingPrayers
                ? const Center(child: CircularProgressIndicator(color: KPrimaryColor))
                : _buildTaskList(),
          ),
        ),
      ]),
    );
  }

  Widget _buildTaskList() {
    final custom = _customTasks;
    final system = _systemSorted;

    if (system.isEmpty && custom.isEmpty) {
      return Center(child: Text('Aucune tâche', style: viet(14, Colors.black38)));
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 70),
      children: [
        for (final task in system)
          TaskCard(
            key: ValueKey(task.id),
            task: task,
            isPast: isPrayerPassed(task, _selectedDay),
            onAdhkarTap: () {
              final isMorning = task.id.contains('morning');
              Navigator.push(context, MaterialPageRoute(builder: (_) => AdhkarPage(isMorning: isMorning)));
            },
          ),

        if (custom.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(children: [
              Expanded(child: Divider(color: KPrimaryColor.withOpacity(.15))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('Mes tâches', style: viet(11, kPrimaryLight, fw: FontWeight.w600)),
              ),
              Expanded(child: Divider(color: KPrimaryColor.withOpacity(.15))),
            ]),
          ),

          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: custom.length,
            proxyDecorator: (child, index, anim) => Material(
              color: Colors.transparent, elevation: 6,
              shadowColor: KPrimaryColor.withOpacity(.25),
              borderRadius: BorderRadius.circular(16), child: child,
            ),
            onReorder: _onReorder,
            buildDefaultDragHandles: false,
            itemBuilder: (ctx, i) {
              final task = custom[i];
              return ReorderableDragStartListener(
                key: ValueKey(task.id), index: i,
                child: TaskCard(
                  task: task,
                  selectionMode: _selectionMode,
                  isSelected: _selectedIds.contains(task.id),
                  onTap: () { if (_selectionMode) _toggleSel(task.id); },
                  onLongPress: () {
                    setState(() => _selectionMode = true);
                    _toggleSel(task.id);
                  },
                  onDelete: () => _deleteTask(task.id),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
}