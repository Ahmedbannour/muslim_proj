import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


const KPrimaryColor = Color(0xFF864A15);
const KBackgroundColor = Color(0xFFF9F4EE);
const KTextColor = Color(0xFF000000);
const kSecondaryColor = Color(0xFFF0E5D7);
const kFontColor = Color(0xFFa8a8a9);

const kPrimaryDark   = Color(0xFF5C3110);
const kPrimaryLight  = Color(0xFFB07040);
const kPrimaryXLight = Color(0xFFF5ECE3);
const kGold          = Color(0xFFBA8B3A);
const kGrey          = Color(0xFFB0B0B0);



class IslamicTask {
  final String id;
  final String label;
  final String subtitle;
  final String time;
  final int sortMinutes;
  final TaskCategory category;
  final bool isCustom;

  const IslamicTask({
    required this.id, required this.label, required this.subtitle,
    required this.time, required this.sortMinutes,
    required this.category, this.isCustom = false,
  });

  Color get color {
    switch (category) {
      case TaskCategory.priere: return KPrimaryColor;
      case TaskCategory.dhikr:  return kGold;
      case TaskCategory.doua:   return kPrimaryLight;
      case TaskCategory.coran:  return kPrimaryDark;
      case TaskCategory.custom: return KPrimaryColor;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'label': label, 'subtitle': subtitle,
    'time': time, 'sortMinutes': sortMinutes,
    'category': category.index, 'isCustom': isCustom,
  };

  factory IslamicTask.fromJson(Map<String, dynamic> j) => IslamicTask(
    id: j['id'] as String,
    label: j['label'] as String,
    subtitle: j['subtitle'] as String,
    time: j['time'] as String,
    sortMinutes: j['sortMinutes'] as int,
    category: TaskCategory.values[j['category'] as int],
    isCustom: j['isCustom'] as bool,
  );
}


enum TaskCategory { priere, dhikr, doua, coran, custom }


class HijriDay {
  final int gregDay, gregMonth, gregYear;
  final int hijriDay, hijriMonth, hijriYear;
  final String hijriMonthAr, weekdayAr;
  const HijriDay({
    required this.gregDay, required this.gregMonth, required this.gregYear,
    required this.hijriDay, required this.hijriMonth, required this.hijriYear,
    required this.hijriMonthAr, required this.weekdayAr,
  });
  DateTime get gregorianDate => DateTime(gregYear, gregMonth, gregDay);
}


class AdhkarItem {
  final String id, titleAr, titleFr, textAr, translationFr, source, count, category;
  const AdhkarItem({
    required this.id, required this.titleAr, required this.titleFr,
    required this.textAr, required this.translationFr,
    required this.source, required this.count, required this.category,
  });
}

const List<AdhkarItem> kAdhkarMatin = [
  AdhkarItem(id:'am01', category:'matin', titleAr:'آية الكرسي', titleFr:'Âyat Al-Kursî',
      textAr:'اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ',
      translationFr:'Allah ! Point de divinité à part Lui, le Vivant, Celui qui subsiste par lui-même.', source:'Coran 2:255', count:'1×'),
  AdhkarItem(id:'am02', category:'matin', titleAr:'سيد الاستغفار', titleFr:'Maître de l\'imploration',
      textAr:'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ وَأَبُوءُ بِذَنْبِي، فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
      translationFr:'Ô Allah, Tu es mon Seigneur, il n\'y a de divinité que Toi.', source:'Sahih Bukhari 6306', count:'1×'),
  AdhkarItem(id:'am03', category:'matin', titleAr:'التسبيح والتحميد والتكبير', titleFr:'Glorification matinale',
      textAr:'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      translationFr:'Gloire à Allah et à Sa louange.', source:'Sahih Muslim 2692', count:'100×'),
  AdhkarItem(id:'am04', category:'matin', titleAr:'دعاء الصباح', titleFr:'Doua du matin',
      textAr:'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ',
      translationFr:'Ô Allah, c\'est grâce à Toi que nous entrons dans le matin.', source:'Sunan Tirmidhi 3391', count:'1×'),
  AdhkarItem(id:'am05', category:'matin', titleAr:'الحفاظ من الشيطان', titleFr:'Protection contre Shaytan',
      textAr:'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
      translationFr:'Je cherche refuge dans les paroles parfaites d\'Allah.', source:'Sahih Muslim 2708', count:'3×'),
];

const List<AdhkarItem> kAdhkarSoir = [
  AdhkarItem(id:'as01', category:'soir', titleAr:'دعاء المساء', titleFr:'Doua du soir',
      textAr:'اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ',
      translationFr:'Ô Allah, c\'est grâce à Toi que nous entrons dans le soir.', source:'Sunan Tirmidhi 3391', count:'1×'),
  AdhkarItem(id:'as02', category:'soir', titleAr:'آية الكرسي', titleFr:'Âyat Al-Kursî',
      textAr:'اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ',
      translationFr:'Allah ! Point de divinité à part Lui, le Vivant.', source:'Coran 2:255', count:'1×'),
  AdhkarItem(id:'as03', category:'soir', titleAr:'الاستغفار المسائي', titleFr:'Istighfâr du soir',
      textAr:'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ',
      translationFr:'Je demande pardon à Allah et je me repens à Lui.', source:'Sahih Bukhari 6307', count:'100×'),
  AdhkarItem(id:'as04', category:'soir', titleAr:'التسبيح المسائي', titleFr:'Tasbiḥ du soir',
      textAr:'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ',
      translationFr:'Gloire à Allah et à Sa louange. Gloire à Allah le Très Grand.', source:'Sahih Bukhari 6682', count:'33×'),
  AdhkarItem(id:'as05', category:'soir', titleAr:'الحفظ من الهم', titleFr:'Protection contre l\'anxiété',
      textAr:'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ وَالْكَسَلِ، وَالْبُخْلِ وَالْجُبْنِ، وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ',
      translationFr:'Ô Allah, je cherche refuge en Toi contre l\'anxiété.', source:'Sahih Bukhari 2893', count:'1×'),
];



class DouaItem {
  final String id, titleAr, titleFr, textAr, translationFr, source, when;
  const DouaItem({
    required this.id, required this.titleAr, required this.titleFr,
    required this.textAr, required this.translationFr,
    required this.source, required this.when,
  });
}

const List<DouaItem> kAllDuas = [
  DouaItem(id:'d01', titleAr:'دعاء الاستفتاح', titleFr:'Doua d\'ouverture',
      textAr:'اللَّهُمَّ بَاعِدْ بَيْنِي وَبَيْنَ خَطَايَايَ كَمَا بَاعَدْتَ بَيْنَ الْمَشْرِقِ وَالْمَغْرِبِ',
      translationFr:'Ô Allah, éloigne de moi mes péchés comme Tu as éloigné l\'orient de l\'occident.',
      source:'Sahih Bukhari 744', when:'Au début de la prière'),
  DouaItem(id:'d02', titleAr:'دعاء الكرب', titleFr:'Doua de la détresse',
      textAr:'لَا إِلَهَ إِلَّا اللَّهُ الْعَظِيمُ الْحَلِيمُ، لَا إِلَهَ إِلَّا اللَّهُ رَبُّ الْعَرْشِ الْعَظِيمِ',
      translationFr:'Il n\'y a de divinité qu\'Allah, le Grandiose, le Doux.',
      source:'Sahih Bukhari 6345', when:'En cas de détresse'),
  DouaItem(id:'d03', titleAr:'دعاء يونس', titleFr:'Doua de Younous',
      textAr:'لَا إِلَهَ إِلَّا أَنتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ',
      translationFr:'Il n\'y a de divinité que Toi. Gloire à Toi !',
      source:'Coran 21:87', when:'En toute circonstance'),
  DouaItem(id:'d04', titleAr:'دعاء السفر', titleFr:'Doua du voyage',
      textAr:'اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَى',
      translationFr:'Ô Allah, nous Te demandons dans ce voyage la piété et la crainte de Toi.',
      source:'Sahih Muslim 1342', when:'Au début d\'un voyage'),
  DouaItem(id:'d05', titleAr:'سيد الاستغفار', titleFr:'Maître de l\'imploration',
      textAr:'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ',
      translationFr:'Ô Allah, Tu es mon Seigneur, il n\'y a de divinité que Toi.',
      source:'Sahih Bukhari 6306', when:'Matin et soir'),
  DouaItem(id:'d06', titleAr:'دعاء دخول المسجد', titleFr:'Entrée à la mosquée',
      textAr:'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
      translationFr:'Ô Allah, ouvre-moi les portes de Ta miséricorde.',
      source:'Sahih Muslim 713', when:'En entrant à la mosquée'),
  DouaItem(id:'d07', titleAr:'دعاء الرزق', titleFr:'Doua de la subsistance',
      textAr:'اللَّهُمَّ اكْفِنِي بِحَلَالِكَ عَنْ حَرَامِكَ، وَأَغْنِنِي بِفَضْلِكَ عَمَّنْ سِوَاكَ',
      translationFr:'Ô Allah, suffis-moi par ce que Tu as rendu licite.',
      source:'Sunan Tirmidhi 3563', when:'Pour demander la subsistance'),
  DouaItem(id:'d08', titleAr:'دعاء الهم والحزن', titleFr:'Contre l\'anxiété',
      textAr:'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ وَالْكَسَلِ',
      translationFr:'Ô Allah, je cherche refuge auprès de Toi contre l\'anxiété.',
      source:'Sahih Bukhari 2893', when:'En cas d\'anxiété'),
  DouaItem(id:'d09', titleAr:'دعاء النوم', titleFr:'Doua avant le sommeil',
      textAr:'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      translationFr:'En Ton nom, Ô Allah, je meurs et je vis.',
      source:'Sahih Bukhari 6312', when:'Avant de dormir'),
  DouaItem(id:'d10', titleAr:'دعاء الاستيقاظ', titleFr:'Doua au réveil',
      textAr:'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
      translationFr:'Louange à Allah qui nous a fait vivre après nous avoir fait mourir.',
      source:'Sahih Bukhari 6312', when:'Au réveil'),
  DouaItem(id:'d11', titleAr:'دعاء الطعام', titleFr:'Avant le repas',
      textAr:'اللَّهُمَّ بَارِكْ لَنَا فِيهِ وَأَطْعِمْنَا خَيْرًا مِنْهُ',
      translationFr:'Ô Allah, bénis-nous en cela et nourris-nous de quelque chose de meilleur.',
      source:'Sunan Tirmidhi 3455', when:'Avant de manger'),
  DouaItem(id:'d12', titleAr:'دعاء القنوت', titleFr:'Doua du Qounout',
      textAr:'اللَّهُمَّ اهْدِنِي فِيمَنْ هَدَيْتَ، وَعَافِنِي فِيمَنْ عَافَيْتَ',
      translationFr:'Ô Allah, guide-moi parmi ceux que Tu as guidés.',
      source:'Sunan Abu Dawud 1425', when:'Dans la prière du witr'),
];


class HijriMonth {
  final int month; // 1-12
  final int year;
  const HijriMonth({required this.month, required this.year});

  HijriMonth get prev => month == 1 ? HijriMonth(month: 12, year: year - 1) : HijriMonth(month: month - 1, year: year);

  HijriMonth get next => month == 12 ? HijriMonth(month: 1, year: year + 1) : HijriMonth(month: month + 1, year: year);

  @override
  String toString() => '$month/$year';
}

String toArabicNumerals(int n) {
  const w = ['0','1','2','3','4','5','6','7','8','9'];
  const a = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
  return n.toString().split('').map((c) => a[w.indexOf(c)]).join();
}

const hijriMonthsAr = {
  1:'مُحَرَّم', 2:'صَفَر', 3:'رَبِيعُ الأَوَّل', 4:'رَبِيعُ الآخِر',
  5:'جُمَادَى الأُولَى', 6:'جُمَادَى الآخِرَة', 7:'رَجَب', 8:'شَعْبَان',
  9:'رَمَضَان', 10:'شَوَّال', 11:'ذُو القَعْدَة', 12:'ذُو الحِجَّة',
};


const kDefaultPadding = 20.0;


TextStyle amiri(double size, Color color, {FontWeight fw = FontWeight.w700}) => GoogleFonts.amiri(fontSize: size, fontWeight: fw, color: color, height: 1.5);

TextStyle viet(double size, Color color, {FontWeight fw = FontWeight.w400}) => GoogleFonts.beVietnamPro(fontSize: size, fontWeight: fw, color: color);



DateTime prayerDateTime(String date, String time) {
  final dateParts = date.split('-'); // yyyy-MM-dd
  final timeParts = time.split(':'); // HH:mm

  return DateTime(
    int.parse(dateParts[2]), // year
    int.parse(dateParts[1]), // month
    int.parse(dateParts[0]), // day
    int.parse(timeParts[0]), // hour
    int.parse(timeParts[1]), // minute
  );
}

Future<bool> isOnline() async {
  try {
    final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 3));
    return result.isNotEmpty;
  } catch (_) {
    return false;
  }
}