import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:muslim_proj/Constants.dart';

class ScrollConfig extends StatefulWidget {
  final Function(int) updateScrollValue;
  final Function(bool)? onAutoScrollToggled;
  const ScrollConfig({super.key, required this.updateScrollValue, this.onAutoScrollToggled});

  @override
  State<ScrollConfig> createState() => _ScrollConfigState();
}

class _ScrollConfigState extends State<ScrollConfig> {
  bool autoScroll = false;
  var box = Hive.box('muslim_proj');

  int scrollValue = 0;

  @override
  void initState() {
    super.initState();

    autoScroll = box.get("autoScroll") ?? false;
    scrollValue = box.get("scrollValue") ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Auto Scroll',
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: KPrimaryColor.withOpacity(.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                padding: const EdgeInsets.all(3),
                child: Stack(
                  children: [

                    Row(
                      children: [
                        _toggleLabel(
                          label: 'ON',
                          active: autoScroll,
                          onTap: () {
                            setState(() {
                              autoScroll = true;
                              box.put("autoScroll", autoScroll);
                            });
                            widget.onAutoScrollToggled?.call(true);
                          },
                        ),
                        _toggleLabel(
                          label: 'OFF',
                          active: !autoScroll,
                          onTap: () {
                            setState(() {
                              autoScroll = false;
                              box.put("autoScroll", autoScroll);
                            });
                            widget.onAutoScrollToggled?.call(false);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: !autoScroll
                ? const SizedBox(width: double.infinity, height: 0)
                : Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Vitesse',
                        style: GoogleFonts.beVietnamPro(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                          color: KPrimaryColor.withOpacity(.2),
                          borderRadius: BorderRadius.circular(8)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Row(
                        children: [
                          _ScaleOnTap(
                            onTap: scrollValue > 0
                                ? () {
                              setState(() {
                                scrollValue = scrollValue - 1;
                                box.put("scrollValue", scrollValue);
                                widget.updateScrollValue(scrollValue);
                              });
                            }
                                : null,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 4),
                                child: Text(
                                  '-',
                                  style: GoogleFonts.beVietnamPro(
                                      color: scrollValue == 0
                                          ? Colors.grey
                                          : KPrimaryColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 4),
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Text(
                                scrollValue.toString(),
                                style: GoogleFonts.beVietnamPro(
                                    fontSize: 18,
                                    color: KPrimaryColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          _ScaleOnTap(
                            onTap: scrollValue < 3
                                ? () {
                              setState(() {
                                scrollValue = scrollValue + 1;
                                box.put("scrollValue", scrollValue);
                                widget.updateScrollValue(scrollValue);
                              });
                            }
                                : null,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 4),
                                child: Text(
                                  '+',
                                  style: GoogleFonts.beVietnamPro(
                                      color: scrollValue == 3
                                          ? Colors.grey
                                          : KPrimaryColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleLabel({required String label, required bool active, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: GoogleFonts.beVietnamPro(
          color: active ? Colors.white : KPrimaryColor,
          fontWeight: active ? FontWeight.w600 : FontWeight.w500,
        ),
        child: Container(
          width: 44,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? KPrimaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8)
          ),
          child: Text(label),
        ),
      ),
    );
  }
}

/// Petit wrapper réutilisable qui anime un léger scale au tap,
/// pour donner un feedback tactile sur les boutons +/-.
class _ScaleOnTap extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget child;
  const _ScaleOnTap({required this.onTap, required this.child});

  @override
  State<_ScaleOnTap> createState() => _ScaleOnTapState();
}

class _ScaleOnTapState extends State<_ScaleOnTap> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: widget.onTap == null ? null : (_) => setState(() => _scale = 0.85),
      onTapUp: widget.onTap == null ? null : (_) => setState(() => _scale = 1.0),
      onTapCancel: widget.onTap == null ? null : () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}