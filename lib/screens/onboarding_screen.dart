import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../services/app_service.dart';
import '../state/app_list_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  final AppService _appService = AppService();
  int _page = 0;
  bool _isAdvancing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    try {
      final isar = await ref.read(isarProvider.future);
      await isar.writeTxn(() async {
        await isar.onboardingDbs.put(
          OnboardingDb()
            ..id = 1
            ..hasOnboarded = true,
        );
      });
    } catch (e) {
      debugPrint('Onboarding finish error: $e');
    }
  }

  Future<void> _next() async {
    if (_isAdvancing) {
      return;
    }

    setState(() => _isAdvancing = true);

    if (_page == 2) {
      await _requestMusicWidgetPermissions();
    }

    if (_page >= 2) {
      await _finish();
      if (mounted) {
        setState(() => _isAdvancing = false);
      }
      return;
    }
    await _controller.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );

    if (mounted) {
      setState(() => _isAdvancing = false);
    }
  }

  Future<void> _requestMusicWidgetPermissions() async {
    final notificationsGranted = await _appService
        .requestNotificationPermission();
    if (!mounted) {
      return;
    }

    final listenerEnabled = await _appService.isNotificationListenerEnabled();
    if (!mounted) {
      return;
    }

    if (!listenerEnabled) {
      final openSettings = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enable media controls'),
            content: const Text(
              'Turn on notification access for Stillmax so the music widget can show current track and controls.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Later'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Open Settings'),
              ),
            ],
          );
        },
      );

      if (openSettings == true) {
        await _appService.openNotificationListenerSettings();
      }
    } else if (!notificationsGranted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Notification permission is off. Music controls may be limited.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF11131F), Color(0xFF0E0E13), Color(0xFF19162B)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (value) => setState(() => _page = value),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const _StepCard(
                      logoAsset: 'assets/app-logo.svg',
                      title: 'Welcome to Stillmax',
                      body:
                          'A cinematic Android launcher with glassmorphic depth and focused controls.',
                    ),
                    const _StepCard(
                      icon: Icons.home,
                      title: 'Set as Home App',
                      body:
                          'Press Home and choose Stillmax as your default launcher for the full experience.',
                    ),
                    const _StepCard(
                      icon: Icons.notifications_active,
                      title: 'Enable Notifications',
                      body:
                          'Allow notification access to show unread badges and pull-down status shortcuts.',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.10),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _page == index ? 22 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _page == index
                                  ? AppColors.primary
                                  : AppColors.outline.withValues(alpha: 0.45),
                              borderRadius: BorderRadius.circular(
                                AppRadius.full,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _finish,
                              child: const Text('Skip'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isAdvancing ? null : _next,
                              child: Text(_page == 2 ? 'Start' : 'Continue'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    this.icon,
    this.logoAsset,
    required this.title,
    required this.body,
  }) : assert(icon != null || logoAsset != null);

  final IconData? icon;
  final String? logoAsset;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GlassCard(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (logoAsset != null)
              Center(
                child: Container(
                  width: 148,
                  height: 148,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: SvgPicture.asset(logoAsset!, fit: BoxFit.contain),
                ),
              )
            else
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: AppColors.onPrimaryContainer),
              ),
            const SizedBox(height: 20),
            Text(title, style: AppTypography.headlineSmall),
            const SizedBox(height: 12),
            Text(
              body,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
