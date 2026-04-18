import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  double? _touchY;

  static const _itemWidth = 30.0;
  static const _touchWidth = 60.0;
  static const _maxItemHeight = 24.0;
  static const _minItemHeight = 16.0;

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

  void _selectLetter(Offset localPosition, double itemHeight) {
    if (widget.letters.isEmpty) {
      return;
    }
    final index = (localPosition.dy / itemHeight).floor().clamp(
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
    // Add haptic feedback when letter changes
    if (_activeLetter != letter) {
      HapticFeedback.selectionClick();
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

  double _calculateItemHeight(double availableHeight) {
    if (widget.letters.isEmpty) return _maxItemHeight;
    final idealHeight = availableHeight / widget.letters.length;
    return idealHeight.clamp(_minItemHeight, _maxItemHeight);
  }

  @override
  Widget build(BuildContext context) {
    final activeIndex = _activeLetter == null
        ? -1
        : widget.letters.indexOf(_activeLetter!);
    final barOpacity = widget.isScrolling ? 0.4 : 1.0;

    return SafeArea(
      child: SizedBox(
        width: _touchWidth,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemHeight = _calculateItemHeight(constraints.maxHeight);
            final indicatorTop =
                (activeIndex < 0 ? 0 : activeIndex) * itemHeight;

            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 140),
                  curve: Curves.easeOut,
                  opacity: barOpacity,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onPanStart: (details) {
                      _selectLetter(details.localPosition, itemHeight);
                      setState(() {
                        _touchY = details.localPosition.dy;
                      });
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        _touchY = details.localPosition.dy;
                      });
                      _selectLetter(details.localPosition, itemHeight);
                    },
                    onPanEnd: (_) {
                      setState(() {
                        _activeLetter = null;
                        _touchY = null;
                      });
                      _hidePopup();
                    },
                    onPanCancel: () {
                      setState(() {
                        _activeLetter = null;
                        _touchY = null;
                      });
                      _hidePopup();
                    },
                    onTapDown: (details) {
                      _selectLetter(details.localPosition, itemHeight);
                      _hidePopup(delay: const Duration(milliseconds: 420));
                      Future<void>.delayed(
                        const Duration(milliseconds: 250),
                        () {
                          if (!mounted) return;
                          setState(() => _activeLetter = null);
                        },
                      );
                    },
                    child: SizedBox(
                      width: _touchWidth,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: _itemWidth,
                          child: Stack(
                            children: [
                              if (activeIndex >= 0)
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.easeOut,
                                  left: 0,
                                  top: indicatorTop,
                                  child: Container(
                                    width: 2,
                                    height: itemHeight,
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                  ),
                                ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (
                                    var i = 0;
                                    i < widget.letters.length;
                                    i++
                                  )
                                    SizedBox(
                                      width: _itemWidth,
                                      height: itemHeight,
                                      child: Center(
                                        child: _buildLetterWidget(
                                          i,
                                          activeIndex,
                                          itemHeight,
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
                  ),
                ),
                // Letter popup bubble - moves with touch
                if (_showPopup && _activeLetter != null && _touchY != null)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 50),
                    curve: Curves.easeOut,
                    left: -90, // Curve outward from sidebar
                    top: (_touchY! - 22).clamp(
                      0.0,
                      constraints.maxHeight - 44,
                    ), // Center bubble on touch, keep in bounds
                    child: IgnorePointer(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 150),
                        opacity: _showPopup ? 1.0 : 0.0,
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 150),
                          scale: _showPopup ? 1.0 : 0.8,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(
                                0xFF1C1C1E,
                              ).withValues(alpha: 0.9),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _activeLetter ?? '',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: _activeLetter == '★'
                                    ? AppColors.secondary
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLetterWidget(int index, int activeIndex, double itemHeight) {
    final letter = widget.letters[index];
    final isActive = activeIndex == index;
    final isEnabled = _isEnabledLetter(letter);
    final isStar = letter == '★';

    // Calculate horizontal offset for C-curve effect
    double offsetX = 0.0;
    if (_touchY != null) {
      final letterCenterY = index * itemHeight + itemHeight / 2;
      final distance = (letterCenterY - _touchY!).abs();
      const maxBulge = 34.0;
      final affectRadius = itemHeight * 5.2;

      if (distance < affectRadius) {
        offsetX = -maxBulge * pow(1 - distance / affectRadius, 2);
      }
    }

    // Scale font sizes based on available item height
    final scaleFactor = (itemHeight / _maxItemHeight).clamp(0.6, 1.0);
    double baseFontSize;
    double opacity;

    if (isStar) {
      // Star is always active and in accent color
      baseFontSize = 16;
      opacity = 1.0;
    } else if (!isEnabled) {
      baseFontSize = 12;
      opacity = 0.3;
    } else if (isActive) {
      baseFontSize = 17;
      opacity = 1.0;
    } else {
      baseFontSize = 15;
      opacity = 0.82;
    }

    final fontSize = baseFontSize * scaleFactor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(offsetX, 0, 0),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 95),
        curve: Curves.easeOut,
        scale: isActive ? 1.3 : 1.0,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 95),
          curve: Curves.easeOut,
          opacity: opacity,
          child: Text(
            letter,
            style: TextStyle(
              fontSize: fontSize,
              color: (isStar || isActive) ? AppColors.secondary : Colors.white,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
