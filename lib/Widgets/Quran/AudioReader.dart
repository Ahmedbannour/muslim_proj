import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:rxdart/rxdart.dart';

class AudioReader extends StatefulWidget {
  final String url;

  const AudioReader({super.key, required this.url});

  @override
  State<AudioReader> createState() => _AudioReaderState();
}


class _AudioReaderState extends State<AudioReader> {
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();

    print('url : ${widget.url}');
    _player = AudioPlayer();
    _loadAudio(widget.url);
  }

  @override
  void didUpdateWidget(covariant AudioReader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url) {
      _loadAudio(widget.url);
    }
  }

  Future<void> _loadAudio(String url) async {
    try {
      await _player.setUrl(url);
    } catch (e) {
      // Utilisez le widget pour imprimer l'erreur, comme dans votre code original
      debugPrint("Erreur audio : $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  /// Stream combinant position / durée / buffered
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration?, Duration, PositionData>(
        _player.positionStream,
        _player.durationStream,
        _player.bufferedPositionStream,
            (position, duration, buffered) => PositionData(position, duration ?? Duration.zero, buffered),
      );

  // --- Méthode d'aide pour le formatage du temps ---
  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, "0");
    return "${two(d.inMinutes)}:${two(d.inSeconds % 60)}";
  }

  // --- Méthode d'aide pour construire le bouton Play/Pause ---
  Widget _buildPlayPauseButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Center(
            child: Icon(
              icon,
              color: KPrimaryColor,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
  // -----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: KPrimaryColor,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ⏯ Play / Pause (avec logique de réinitialisation)
              StreamBuilder<PlayerState>(
                stream: _player.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final processingState = playerState?.processingState;
                  final isPlaying = playerState?.playing ?? false;

                  // ⚠️ CORRECTION : Si la lecture est terminée, réinitialiser la position.
                  if (processingState == ProcessingState.completed) {
                    // Réinitialise la position à zéro et affiche le bouton Play
                    _player.seek(Duration.zero);
                    _player.pause();
                    return _buildPlayPauseButton(
                      Icons.play_arrow_rounded, () {
                        _player.play(); // Redémarre la lecture
                      },
                    );
                  }

                  // Cas normal : Lecture/Pause
                  return _buildPlayPauseButton(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        () {
                      isPlaying ? _player.pause() : _player.play();
                    },
                  );
                },
              ),


              // Slider + durée
              Expanded(
                child: StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final data = snapshot.data ?? PositionData(Duration.zero, Duration.zero, Duration.zero);

                    final position = data.position;
                    final duration = data.duration;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                                trackHeight: 4,
                                thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 6,
                                    disabledThumbRadius: 2,
                                    elevation: 5,
                                    pressedElevation: 8
                                ),
                                overlayShape: SliderComponentShape.noOverlay,
                                activeTrackColor: Colors.white,
                                inactiveTrackColor: Colors.white24,
                                thumbColor: Colors.white,
                                minThumbSeparation: 6,
                                allowedInteraction: SliderInteraction.tapAndSlide
                            ),
                            child: Slider(
                              min: 0,
                              max: duration.inMilliseconds.toDouble(),
                              // Utilise .clamp() pour s'assurer que la position ne dépasse pas la durée
                              value: position.inMilliseconds.clamp(0, duration.inMilliseconds).toDouble(),
                              onChanged: (value) {
                                _player.seek(Duration(milliseconds: value.toInt()));
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 4),
                        // time (00:12 / 01:40)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _format(position),
                                style:
                                const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                              Text(
                                _format(duration),
                                style:
                                const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Classe PositionData (inchangée)
class PositionData {
  final Duration position;
  final Duration duration;
  final Duration buffered;

  PositionData(this.position, this.duration, this.buffered);
}