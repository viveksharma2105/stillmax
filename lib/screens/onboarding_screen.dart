import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  int _page = 0;

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
    if (_page >= 2) {
      await _finish();
      return;
    }
    await _controller.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
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
                  children: const [
                    _StepCard(
                      icon: Icons.rocket_launch,
                      title: 'Welcome to Stillmax',
                      body:
                          'A cinematic Android launcher with glassmorphic depth and focused controls.',
                    ),
                    _StepCard(
                      icon: Icons.home,
                      title: 'Set as Home App',
                      body:
                          'Press Home and choose Stillmax as your default launcher for the full experience.',
                    ),
                    _StepCard(
                      icon: Icons.notifications_active,
                      title: 'Enable Notifications',
                      body:
                          'Allow notification access to show unread badges and pull-down status shortcuts.',
                    ),
                  ],
                ),
              ),
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
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
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
                        onPressed: _next,
                        child: Text(_page == 2 ? 'Start' : 'Continue'),
                      ),
                    ),
                  ],
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
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
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
