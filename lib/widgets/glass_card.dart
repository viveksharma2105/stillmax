import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Glassmorphism card widget implementing the design system's frosted glass aesthetic.
///
/// Matches the spec from DESIGN.md:
/// - Dark frosted background: rgba(19,19,24,0.7)
/// - Backdrop blur: 20px
/// - Subtle white border: 10% opacity (ghost border)
/// - Rounded corners: 24px (lg) by default
///
/// Usage:
/// ```dart
/// GlassCard(
///   child: Text('Frosted content'),
///   padding: EdgeInsets.all(16),
/// )
/// ```
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.blurIntensity = 20.0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double blurIntensity;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(AppRadius.lg);
    final effectiveBackgroundColor =
        backgroundColor ?? AppColors.glassDark; // rgba(19,19,24,0.7)
    final effectiveBorderColor =
        borderColor ?? Colors.white.withValues(alpha: 0.1); // Ghost border

    Widget content = ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurIntensity, sigmaY: blurIntensity),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: effectiveBorderRadius,
            border: Border.all(color: effectiveBorderColor, width: borderWidth),
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: effectiveBorderRadius,
        // Primary-tinted ripple at 12% opacity (per design spec)
        splashColor: AppColors.primary.withValues(alpha: 0.12),
        highlightColor: AppColors.primary.withValues(alpha: 0.08),
        child: content,
      );
    }

    return content;
  }
}

/// Lighter glass variant for secondary UI elements
/// Uses rgba(255,255,255,0.03) with 10px blur
class GlassCardLight extends StatelessWidget {
  const GlassCardLight({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: padding,
      borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.md),
      blurIntensity: 10.0,
      backgroundColor: AppColors.glassLight, // rgba(255,255,255,0.03)
      borderColor: Colors.white.withValues(alpha: 0.05),
      onTap: onTap,
      child: child,
    );
  }
}

/// Animated glass card with scale-down effect on press
/// Matches prototype behavior: scale to 98% and increase blur intensity
class AnimatedGlassCard extends StatefulWidget {
  const AnimatedGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  @override
  State<AnimatedGlassCard> createState() => _AnimatedGlassCardState();
}

class _AnimatedGlassCardState extends State<AnimatedGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _blurAnimation = Tween<double>(
      begin: 20.0,
      end: 24.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GlassCard(
              padding: widget.padding,
              borderRadius: widget.borderRadius,
              blurIntensity: _blurAnimation.value,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}
