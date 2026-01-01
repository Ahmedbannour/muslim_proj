import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_proj/Constants.dart';

class AdhanItem extends StatelessWidget {
  final String auteur;
  final bool isPlaying;
  final bool isSelected;
  final Duration position;
  final Duration duration;
  final VoidCallback onPlayPause;
  final VoidCallback onSelect;
  final ValueChanged<double> onSeek;

  const AdhanItem({
    super.key,
    required this.auteur,
    required this.isPlaying,
    required this.isSelected,
    required this.position,
    required this.duration,
    required this.onPlayPause,
    required this.onSelect,
    required this.onSeek,
  });

  String _formatDuration(Duration d) {
    if (d == Duration.zero) return '00:00';
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final hasAudio = duration > Duration.zero || isPlaying;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isPlaying
            ? KPrimaryColor.withOpacity(0.12)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isSelected
            ? Border.all(color: KPrimaryColor, width: 2)
            : Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: isPlaying
                ? KPrimaryColor.withOpacity(0.15)
                : Colors.black.withOpacity(.05),
            blurRadius: isPlaying ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // ☑️ CHECKBOX
              Checkbox(
                value: isSelected,
                activeColor: KPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: (_) => onSelect(),
              ),

              const SizedBox(width: 8),

              // 📝 Nom de l'auteur
              Expanded(
                child: Text(
                  auteur,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 15,
                    fontWeight: isPlaying ? FontWeight.w700 : FontWeight.w600,
                    color: isPlaying ? KPrimaryColor : Colors.black87,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // ▶️ BOUTON PLAY/PAUSE
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: onPlayPause,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: KPrimaryColor.withOpacity(isPlaying ? 0.15 : 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 26,
                      color: KPrimaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 🎵 SLIDER ET DURÉES
          if (hasAudio) ...[
            const SizedBox(height: 12),

            // Slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3.5,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                activeTrackColor: KPrimaryColor,
                inactiveTrackColor: KPrimaryColor.withOpacity(0.2),
                thumbColor: KPrimaryColor,
                overlayColor: KPrimaryColor.withOpacity(0.2),
              ),
              child: Slider(
                min: 0,
                max: duration.inSeconds > 0 ? duration.inSeconds.toDouble() : 1,
                value: duration.inSeconds > 0
                    ? position.inSeconds.clamp(0, duration.inSeconds).toDouble()
                    : 0,
                onChanged: duration.inSeconds > 0 ? onSeek : null,
              ),
            ),

            // Durées
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(position),
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    _formatDuration(duration),
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
