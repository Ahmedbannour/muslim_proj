import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muslim_proj/Constants.dart';



class DouaListPage extends StatefulWidget {
  const DouaListPage({super.key});
  @override State<DouaListPage> createState() => _DouaListPageState();
}

class _DouaListPageState extends State<DouaListPage> {
  String _search = '';
  int? _expanded;

  List<DouaItem> get _filtered => _search.isEmpty ? kAllDuas
      : kAllDuas.where((d) =>
  d.titleFr.toLowerCase().contains(_search.toLowerCase()) ||
      d.when.toLowerCase().contains(_search.toLowerCase()) ||
      d.textAr.contains(_search) ||
      d.translationFr.toLowerCase().contains(_search.toLowerCase())).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KBackgroundColor,
      appBar: AppBar(
        backgroundColor: KPrimaryColor, foregroundColor: Colors.white, elevation: 0,
        title: Text('الأدعية المأثورة', style: amiri(20, Colors.white)), centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(58),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              style: viet(13, Colors.black87),
              decoration: InputDecoration(
                hintText: 'Rechercher...', hintStyle: viet(13, Colors.black38),
                prefixIcon: const Icon(Icons.search, color: Colors.black38, size: 20),
                filled: true, fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
      ),
      body: _filtered.isEmpty
          ? Center(child: Text('Aucune doua trouvée', style: viet(14, Colors.black38)))
          : ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: _filtered.length,
        itemBuilder: (ctx, i) => _buildDouaCard(_filtered[i], i),
      ),
    );
  }

  Widget _buildDouaCard(DouaItem dua, int i) {
    final isOpen = _expanded == i;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250), curve: Curves.easeInOut,
        decoration: BoxDecoration(
            color: isOpen ? KPrimaryColor : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: isOpen ? KPrimaryColor : KPrimaryColor.withOpacity(.15), width: 1.2)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => setState(() => _expanded = isOpen ? null : i),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: isOpen ? Colors.white24 : kPrimaryXLight,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(dua.titleAr,
                        style: amiri(13, isOpen ? Colors.white : KPrimaryColor)),
                  ),
                  const Spacer(),
                  Icon(isOpen ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      color: isOpen ? Colors.white60 : Colors.black38, size: 20),
                ]),
                const SizedBox(height: 6),
                Text(dua.titleFr, style: viet(13, isOpen ? Colors.white : Colors.black87, fw: FontWeight.w600)),
                Text(dua.when,    style: viet(11, isOpen ? Colors.white60 : Colors.black38)),
                if (isOpen) ...[
                  const SizedBox(height: 14),
                  Container(height: 1, color: Colors.white24),
                  const SizedBox(height: 14),
                  Align(alignment: Alignment.centerRight,
                      child: Text(dua.textAr, textAlign: TextAlign.right,
                          style: amiri(17, Colors.white, fw: FontWeight.w400).copyWith(height: 2.2))),
                  const SizedBox(height: 14),
                  Container(height: 1, color: Colors.white24),
                  const SizedBox(height: 10),
                  Text(dua.translationFr, style: viet(12, Colors.white70).copyWith(height: 1.7)),
                  const SizedBox(height: 10),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                      child: Text(dua.source, style: viet(10, Colors.white70, fw: FontWeight.w600)),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: dua.textAr));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Doua copiée', style: viet(13, Colors.white)),
                          backgroundColor: KPrimaryColor, behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          duration: const Duration(seconds: 2),
                        ));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                        child: Row(children: [
                          const Icon(Icons.copy_rounded, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text('Copier', style: viet(11, Colors.white)),
                        ]),
                      ),
                    ),
                  ]),
                ],
              ]),
            ),
          ),
        ),
      ),
    );
  }
}