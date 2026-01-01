import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Widgets/Configuration/AdhanItem.dart';

class AdhanConfiguration extends StatefulWidget {
  final List<Map<String, dynamic>> adhanList;
  const AdhanConfiguration({super.key, required this.adhanList});

  @override
  State<AdhanConfiguration> createState() => _AdhanConfigurationState();
}

class _AdhanConfigurationState extends State<AdhanConfiguration> {
  final AudioPlayer _player = AudioPlayer();

  String? _playingValue; // L'audio actuellement sélectionné
  String? _selectedValue; // L'audio sélectionné par checkbox
  bool _isPlayerPlaying = false; // État réel du player
  var box = Hive.box('muslim_proj');

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();

    if(box.get('adhanAuteurId') != null){
      _selectedValue = box.get('adhanAuteurId');
    }
    // 🎵 Écoute de la position
    _player.positionStream.listen((p) {
      if (mounted) {
        setState(() => _position = p);
      }
    });

    // ⏱ Écoute de la durée totale
    _player.durationStream.listen((d) {
      if (d != null && mounted) {
        setState(() => _duration = d);
      }
    });

    // 🔄 ÉCOUTE CRITIQUE DE L'ÉTAT DU PLAYER
    _player.playingStream.listen((playing) {
      if (mounted) {
        setState(() {
          _isPlayerPlaying = playing;
        });
      }
    });

    // 🏁 Écoute de la fin de l'audio
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed && mounted) {
        setState(() {
          _playingValue = null;
          _isPlayerPlaying = false;
          _position = Duration.zero;
          _duration = Duration.zero;
        });
      }
    });
  }

  Future<void> _togglePlay(String value) async {
    try {
      // CAS 1: Même audio - Toggle Play/Pause
      if (_playingValue == value) {
        if (_isPlayerPlaying) {
          // ⏸ Mettre en pause
          await _player.pause();
        } else {
          // ▶️ Reprendre la lecture
          await _player.play();
        }
        return;
      }

      // CAS 2: Nouvel audio - Charger et jouer
      setState(() {
        _playingValue = value;
        _selectedValue = value;
        _isPlayerPlaying = true; // Anticiper l'état
      });

      // Arrêter l'audio précédent
      await _player.stop();

      // Charger le nouveau fichier
      await _player.setAsset('assets/audio/$value.mp3');

      // Jouer
      await _player.play();

    } catch (e) {
      debugPrint('❌ Erreur: $e');

      if (mounted) {
        setState(() {
          _playingValue = null;
          _isPlayerPlaying = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de lecture de l\'audio'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _seek(double seconds) async {
    try {
      await _player.seek(Duration(seconds: seconds.toInt()));
    } catch (e) {
      debugPrint('❌ Erreur seek: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KBackgroundColor,
      appBar: AppBar(
        backgroundColor: KBackgroundColor,
        centerTitle: true,
        foregroundColor: KPrimaryColor,
        surfaceTintColor: KBackgroundColor,
        title: Text(
          "Configuration",
          style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: widget.adhanList.length,
          itemBuilder: (context, index) {
            final item = widget.adhanList[index];
            final value = item['value'];
            final isCurrentAudio = _playingValue == value;
        
            return AdhanItem(
              auteur: item['auteur'],
              // ✅ IMPORTANT: Utiliser _isPlayerPlaying seulement si c'est l'audio actuel
              isPlaying: isCurrentAudio && _isPlayerPlaying,
              isSelected: _selectedValue == value,
              position: isCurrentAudio ? _position : Duration.zero,
              duration: isCurrentAudio ? _duration : Duration.zero,
              onPlayPause: () => _togglePlay(value),
              onSelect: () {
                setState(() => _selectedValue = value);
                box.put("adhanAuteurId", value);
              },
              onSeek: (seconds) {
                if (isCurrentAudio) {
                  _seek(seconds);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
