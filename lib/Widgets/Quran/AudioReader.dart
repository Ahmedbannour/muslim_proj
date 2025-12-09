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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: KPrimaryColor,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          children: [
            // ⏯ Play / Pause
            StreamBuilder<PlayerState>(
              stream: _player.playerStateStream,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data?.playing ?? false;

                return InkWell(
                  onTap: () {
                    isPlaying ? _player.pause() : _player.play();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                        child: Icon(
                          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: KPrimaryColor,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(width: 14),

            // Slider + durée
            Expanded(
              child: StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final data = snapshot.data ?? PositionData(Duration.zero, Duration.zero, Duration.zero);

                  final position = data.position;
                  final duration = data.duration;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SliderTheme(
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
                          value: position.inMilliseconds.clamp(0, duration.inMilliseconds).toDouble(),
                          onChanged: (value) {
                            _player.seek(Duration(milliseconds: value.toInt()));
                          },
                        ),
                      ),

                      // time (00:12 / 01:40)
                      Row(
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
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, "0");
    return "${two(d.inMinutes)}:${two(d.inSeconds % 60)}";
  }
}

class PositionData {
  final Duration position;
  final Duration duration;
  final Duration buffered;

  PositionData(this.position, this.duration, this.buffered);
}
