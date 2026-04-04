import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

typedef OnLetterChanged = void Function(String letter);

class AlphabetSidebar extends StatefulWidget {
  const AlphabetSidebar({
    super.key,
    required this.letters,
    required this.availableLetters,
    required this.onLetterChanged,
    required this.fontScaleFactor,
    required this.isScrolling,
  });

  final List<String> letters;
  final Set<String> availableLetters;
  final OnLetterChanged onLetterChanged;
  final double fontScaleFactor;
  final bool isScrolling;

  @override
  State<AlphabetSidebar> createState() => _AlphabetSidebarState();
}

class _AlphabetSidebarState extends State<AlphabetSidebar> {
  String? _activeLetter;
  bool _showPopup = false;
  int _version = 0;

  static const _itemHeight = 28.0;
  static const _itemWidth = 22.0;

  bool _isEnabledLetter(String letter) =>
      widget.availableLetters.contains(letter);

  void _hidePopup({Duration delay = const Duration(milliseconds: 120)}) {
    final localVersion = ++_version;
    Future<void>.delayed(delay, () {
      if (!mounted || localVersion != _version) {
        return;
      }
      setState(() {
        _showPopup = false;
      });
    });
  }

  void _selectLetter(Offset localPosition) {
    if (widget.letters.isEmpty) {
      return;
    }
    final index = (localPosition.dy / _itemHeight).floor().clamp(
      0,
      widget.letters.length - 1,
    );
    final letter = widget.letters[index];
    if (!_isEnabledLetter(letter)) {
      return;
    }
    if (_activeLetter == letter && _showPopup) {
      return;
    }
    _version++;
    setState(() {
      _activeLetter = letter;
      _showPopup = true;
    });
    widget.onLetterChanged(letter);
  }

  @override
  void dispose() {
    super.dispose();
  }

  double _cellScaleForIndex(int index, int activeIndex) {
    final distance = (index - activeIndex).abs();
    if (distance == 0) return 1.14;
    if (distance == 1) return 1.06;
    if (distance == 2) return 1.02;
    return 1.0;
  }

  double _cellOpacityForIndex(int index, int activeIndex) {
    final distance = (index - activeIndex).abs();
    if (distance == 0) return 1.0;
    if (distance == 1) return 0.88;
    if (distance == 2) return 0.72;
    return 0.6;
  }

  @override
  Widget build(BuildContext context) {
    final activeIndex = _activeLetter == null
        ? -1
        : widget.letters.indexOf(_activeLetter!);
    final barOpacity = widget.isScrolling ? 0.4 : 1.0;
    final indicatorTop =
        (activeIndex < 0 ? 0 : activeIndex) * _itemHeight +
        (_itemHeight - 18) / 2;

    return Positioned(
      right: 2,
      top: 152,
      bottom: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            opacity: barOpacity,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onVerticalDragStart: (details) =>
                  _selectLetter(details.localPosition),
              onVerticalDragUpdate: (details) =>
                  _selectLetter(details.localPosition),
              onVerticalDragEnd: (_) {
                setState(() => _activeLetter = null);
                _hidePopup();
              },
              onVerticalDragCancel: () {
                setState(() => _activeLetter = null);
                _hidePopup();
              },
              onTapDown: (details) {
                _selectLetter(details.localPosition);
                _hidePopup(delay: const Duration(milliseconds: 420));
                Future<void>.delayed(const Duration(milliseconds: 250), () {
                  if (!mounted) {
                    return;
                  }
                  setState(() => _activeLetter = null);
                });
              },
              child: SizedBox(
                width: _itemWidth,
                child: Stack(
                  children: [
                    if (activeIndex >= 0)
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 110),
                        curve: Curves.easeOut,
                        right: 0,
                        top: indicatorTop,
                        child: Container(
                          width: 2,
                          height: 18,
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < widget.letters.length; i++)
                          SizedBox(
                            width: _itemWidth,
                            height: _itemHeight,
                            child: Center(
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 95),
                                curve: Curves.easeOut,
                                scale: activeIndex < 0
                                    ? 1
                                    : _cellScaleForIndex(i, activeIndex),
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 95),
                                  curve: Curves.easeOut,
                                  opacity: _isEnabledLetter(widget.letters[i])
                                      ? (activeIndex < 0
                                            ? 0.88
                                            : _cellOpacityForIndex(
                                                i,
                                                activeIndex,
                                              ))
                                      : 0.22,
                                  child: Text(
                                    widget.letters[i],
                                    style: AppTypography.labelSmall.copyWith(
                                      fontSize: 12 * widget.fontScaleFactor,
                                      color: activeIndex == i
                                          ? AppColors.secondary
                                          : AppColors.onSurfaceVariant,
                                      fontWeight: activeIndex == i
                                          ? FontWeight.w800
                                          : FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              opacity: _showPopup && _activeLetter != null ? 1 : 0,
              child: Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surface.withValues(alpha: 0.9),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.45),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _activeLetter ?? '',
                    style: AppTypography.titleLarge.copyWith(
                      fontSize: 22 * widget.fontScaleFactor,
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
