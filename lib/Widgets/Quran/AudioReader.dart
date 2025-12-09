import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
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
            (position, duration, buffered) =>
            PositionData(position, duration ?? Duration.zero, buffered),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(14),
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
                child: Icon(
                  isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                  size: 42,
                  color: Colors.white,
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
                final data = snapshot.data ??
                    PositionData(Duration.zero, Duration.zero, Duration.zero);

                final position = data.position;
                final duration = data.duration;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3,
                        thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: SliderComponentShape.noOverlay,
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.white24,
                        thumbColor: Colors.white,
                      ),
                      child: Slider(
                        min: 0,
                        max: duration.inMilliseconds.toDouble(),
                        value: position.inMilliseconds
                            .clamp(0, duration.inMilliseconds)
                            .toDouble(),
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
