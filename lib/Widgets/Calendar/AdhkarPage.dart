import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muslim_proj/Constants.dart';


class AdhkarPage extends StatefulWidget {
  final bool isMorning;
  const AdhkarPage({super.key, required this.isMorning});
  @override State<AdhkarPage> createState() => _AdhkarPageState();
}

class _AdhkarPageState extends State<AdhkarPage> with SingleTickerProviderStateMixin {
  late TabController _tab;
  final Map<String, int> _counters = {};

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this, initialIndex: widget.isMorning ? 0 : 1);
  }

  @override void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KBackgroundColor,
      appBar: AppBar(
        backgroundColor: KPrimaryColor, foregroundColor: Colors.white, elevation: 0,
        title: Text('الأذكار', style: amiri(20, Colors.white)), centerTitle: true,
        bottom: TabBar(
          controller: _tab, onTap: (_) => setState(() {}),
          indicatorColor: kGold,
          labelStyle: amiri(15, Colors.white),
          unselectedLabelStyle: amiri(15, Colors.white70),
          tabs: const [Tab(text: 'أذكار الصباح'), Tab(text: 'أذكار المساء')],
        ),
      ),
      body: TabBarView(controller: _tab, children: [
        _buildList(kAdhkarMatin),
        _buildList(kAdhkarSoir),
      ]),
    );
  }

  Widget _buildList(List<AdhkarItem> items) => ListView.builder(
    padding: const EdgeInsets.all(14),
    itemCount: items.length,
    itemBuilder: (ctx, i) => _buildCard(items[i]),
  );

  Widget _buildCard(AdhkarItem dhikr) {
    final count    = _counters[dhikr.id] ?? 0;
    final maxCount = int.tryParse(dhikr.count.replaceAll('×', '')) ?? 1;
    final isDone   = count >= maxCount;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: isDone ? kGold.withOpacity(.08) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isDone ? kGold : kGold.withOpacity(.2),
              width: isDone ? 1.5 : 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(dhikr.titleAr, style: amiri(15, kPrimaryDark)),
                const SizedBox(height: 2),
                Text(dhikr.titleFr, style: viet(11, Colors.black45)),
              ])),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: isDone ? null : () => setState(() => _counters[dhikr.id] = count + 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                      color: isDone ? kGold : kPrimaryXLight, shape: BoxShape.circle,
                      border: Border.all(
                          color: isDone ? kGold : KPrimaryColor.withOpacity(.3), width: 1.5)),
                  child: Center(
                    child: isDone
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
                        : Text('${maxCount - count}', style: amiri(16, KPrimaryColor)),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 12),
            Align(alignment: Alignment.centerRight,
                child: Text(dhikr.textAr, textAlign: TextAlign.right,
                    style: amiri(16, Colors.black87, fw: FontWeight.w400).copyWith(height: 2.1))),
            const SizedBox(height: 10),
            Divider(color: Colors.black12, height: 1),
            const SizedBox(height: 10),
            Text(dhikr.translationFr, style: viet(11, Colors.black54).copyWith(height: 1.65)),
            const SizedBox(height: 10),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: kPrimaryXLight, borderRadius: BorderRadius.circular(8)),
                child: Text(dhikr.source, style: viet(10, KPrimaryColor, fw: FontWeight.w600)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: isDone ? kGold.withOpacity(.15) : kGold.withOpacity(.1),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(dhikr.count, style: viet(11, kGold, fw: FontWeight.w700)),
              ),
            ]),
            if (maxCount > 1) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                    value: count / maxCount,
                    backgroundColor: kGold.withOpacity(.15), color: kGold, minHeight: 4),
              ),
            ],
          ]),
        ),
      ),
    );
  }
}