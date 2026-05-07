import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

typedef OnLetterChanged = void Function(String letter);
typedef OnSidebarInteractionStart = void Function();
typedef OnSidebarInteractionEnd = void Function(String? releasedLetter);

class AlphabetSidebar extends StatefulWidget {
  const AlphabetSidebar({
    super.key,
    required this.letters,
    required this.availableLetters,
    required this.onLetterChanged,
    required this.fontScaleFactor,
    required this.isScrolling,
    this.onLetterTap,
    this.onLetterPreview,
    this.onInteractionStart,
    this.onInteractionEnd,
    this.underflowLetter,
    this.touchWidth = baseTouchWidth,
    this.itemWidth = defaultItemWidth,
    this.rightInset = 0.0,
    this.edgeActivationSlop = defaultEdgeActivationSlop,
    this.externallyActiveLetter,
  });

  static const double baseTouchWidth = 44.0;
  static const double defaultItemWidth = 30.0;
  static const double defaultEdgeActivationSlop = 24.0;

  final List<String> letters;
  final Set<String> availableLetters;
  final OnLetterChanged onLetterChanged;
  final double fontScaleFactor;
  final bool isScrolling;
  final ValueChanged<String>? onLetterTap;
  final ValueChanged<String>? onLetterPreview;
  final OnSidebarInteractionStart? onInteractionStart;
  final OnSidebarInteractionEnd? onInteractionEnd;
  final String? underflowLetter;
  final double touchWidth;
  final double itemWidth;
  final double rightInset;
  final double edgeActivationSlop;
  final String? externallyActiveLetter;

  @override
  State<AlphabetSidebar> createState() => _AlphabetSidebarState();
}

class _AlphabetSidebarState extends State<AlphabetSidebar> {
  String? _activeLetter;
  bool _showPopup = false;
  int _version = 0;
  double? _touchY;
  int? _activePointerId;

  static const _maxItemHeight = 24.0;
  static const _minItemHeight = 16.0;

  Duration get _interactionAnimationDuration => _activePointerId == null
      ? const Duration(milliseconds: 100)
      : Duration.zero;

  double get _effectiveTouchWidth =>
      widget.touchWidth + widget.rightInset + widget.edgeActivationSlop;

  bool _isEnabledLetter(String letter) =>
      widget.availableLetters.contains(letter);

  void _updateTouchY(double nextY) {
    if (_touchY == nextY) {
      return;
    }
    setState(() {
      _touchY = nextY;
    });
  }

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

  String? _letterFromPosition(Offset localPosition, double itemHeight) {
    if (widget.letters.isEmpty) {
      return null;
    }
    if (localPosition.dy < 0 && widget.underflowLetter != null) {
      return widget.underflowLetter;
    }
    final lettersHeight = widget.letters.length * itemHeight;
    if (localPosition.dy >= lettersHeight) {
      return null;
    }
    final index = (localPosition.dy / itemHeight).floor().clamp(
      0,
      widget.letters.length - 1,
    );
    return widget.letters[index];
  }

  void _setActiveLetter(String letter) {
    if (_activeLetter == letter) {
      if (!_showPopup) {
        _version++;
        setState(() {
          _showPopup = true;
        });
      }
      return;
    }

    // Add haptic feedback when letter changes
    HapticFeedback.selectionClick();
    _version++;
    setState(() {
      _activeLetter = letter;
      _showPopup = true;
    });
  }

  void _previewLetter(Offset localPosition, double itemHeight) {
    final letter = _letterFromPosition(localPosition, itemHeight);
    if (letter == null || !_isEnabledLetter(letter)) {
      return;
    }

    if (_activeLetter == letter && _showPopup) {
      return;
    }

    _setActiveLetter(letter);
    final handler = widget.onLetterPreview ?? widget.onLetterChanged;
    handler(letter);
  }

  void _startPointerInteraction(PointerDownEvent event, double itemHeight) {
    if (_activePointerId != null && _activePointerId != event.pointer) {
      return;
    }
    _activePointerId = event.pointer;
    widget.onInteractionStart?.call();
    _updateTouchY(event.localPosition.dy);
    _previewLetter(event.localPosition, itemHeight);
  }

  void _updatePointerInteraction(PointerMoveEvent event, double itemHeight) {
    if (_activePointerId != event.pointer) {
      return;
    }
    _updateTouchY(event.localPosition.dy);
    _previewLetter(event.localPosition, itemHeight);
  }

  void _finishPointerInteraction(
    int pointerId, {
    Offset? localPosition,
    double? itemHeight,
    bool triggerTap = false,
  }) {
    if (_activePointerId != pointerId) {
      return;
    }

    if (localPosition != null && itemHeight != null) {
      _updateTouchY(localPosition.dy);
      _previewLetter(localPosition, itemHeight);
    }

    final completedLetter = _activeLetter;
    _activePointerId = null;

    if (triggerTap && completedLetter == '#') {
      final handler = widget.onLetterTap ?? widget.onLetterChanged;
      handler(completedLetter!);
    }

    _endInteraction(completedLetter);
  }

  void _endInteraction(String? completedLetter) {
    setState(() {
      _activeLetter = null;
      _touchY = null;
    });
    _hidePopup();
    widget.onInteractionEnd?.call(completedLetter);
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
    final displayedActiveLetter = _activePointerId != null
        ? _activeLetter
        : (widget.externallyActiveLetter ?? _activeLetter);
    final activeIndex = displayedActiveLetter == null
        ? -1
        : widget.letters.indexOf(displayedActiveLetter);
    final barOpacity = widget.isScrolling ? 0.4 : 1.0;

    return SafeArea(
      child: SizedBox(
        width: _effectiveTouchWidth,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemHeight = _calculateItemHeight(constraints.maxHeight);
            final indicatorTop =
                (activeIndex < 0 ? 0 : activeIndex) * itemHeight;
            final interactionAnimationDuration = _interactionAnimationDuration;

            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 140),
                  curve: Curves.easeOut,
                  opacity: barOpacity,
                  child: Listener(
                    behavior: HitTestBehavior.translucent,
                    onPointerDown: (event) =>
                        _startPointerInteraction(event, itemHeight),
                    onPointerMove: (event) =>
                        _updatePointerInteraction(event, itemHeight),
                    onPointerUp: (event) => _finishPointerInteraction(
                      event.pointer,
                      localPosition: event.localPosition,
                      itemHeight: itemHeight,
                      triggerTap: true,
                    ),
                    onPointerCancel: (event) =>
                        _finishPointerInteraction(event.pointer),
                    child: SizedBox(
                      width: _effectiveTouchWidth,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: widget.rightInset),
                          child: SizedBox(
                            width: widget.itemWidth,
                            child: Stack(
                              children: [
                                if (activeIndex >= 0)
                                  AnimatedPositioned(
                                    duration: interactionAnimationDuration,
                                    curve: Curves.easeOut,
                                    left: 0,
                                    top: indicatorTop,
                                    child: Container(
                                      width: 2,
                                      height: itemHeight,
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary,
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
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
                                        width: widget.itemWidth,
                                        height: itemHeight,
                                        child: Center(
                                          child: _buildLetterWidget(
                                            i,
                                            activeIndex,
                                            itemHeight,
                                            interactionAnimationDuration,
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
                ),
                // Letter popup bubble - moves with touch
                if (_showPopup && _activeLetter != null && _touchY != null)
                  AnimatedPositioned(
                    duration: interactionAnimationDuration,
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
                            child: _activeLetter == '#'
                                ? const Icon(
                                    Icons.settings_rounded,
                                    size: 20,
                                    color: Colors.white,
                                  )
                                : Text(
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

  Widget _buildLetterWidget(
    int index,
    int activeIndex,
    double itemHeight,
    Duration animationDuration,
  ) {
    final letter = widget.letters[index];
    final isActive = activeIndex == index;
    final isEnabled = _isEnabledLetter(letter);
    final isStar = letter == '★';
    final isSettings = letter == '#';

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

    if (isStar || isSettings) {
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
      duration: animationDuration,
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(offsetX, 0, 0),
      child: AnimatedScale(
        duration: animationDuration,
        curve: Curves.easeOut,
        scale: isActive ? 1.3 : 1.0,
        child: AnimatedOpacity(
          duration: animationDuration,
          curve: Curves.easeOut,
          opacity: opacity,
          child: isSettings
              ? Icon(
                  Icons.settings_rounded,
                  size: (15 * scaleFactor).clamp(11.0, 16.0),
                  color: isActive ? AppColors.secondary : Colors.white,
                )
              : Text(
                  letter,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: (isStar || isActive)
                        ? AppColors.secondary
                        : Colors.white,
                    fontWeight: isActive ? FontWeight.w800 : FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }
}
