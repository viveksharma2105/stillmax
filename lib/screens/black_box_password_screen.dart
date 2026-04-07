import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_service.dart';
import '../state/app_list_provider.dart';
import '../theme/app_theme.dart';
import 'black_box_vault_screen.dart';

enum BlackBoxMode { setup, verify, change }

class BlackBoxPasswordScreen extends ConsumerStatefulWidget {
  const BlackBoxPasswordScreen({super.key, required this.mode});

  final BlackBoxMode mode;

  @override
  ConsumerState<BlackBoxPasswordScreen> createState() =>
      _BlackBoxPasswordScreenState();
}

class _BlackBoxPasswordScreenState extends ConsumerState<BlackBoxPasswordScreen>
    with TickerProviderStateMixin {
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  String _errorMessage = '';
  bool _showSuccessMessage = false;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _successController;
  late Animation<double> _successAnimation;
  StreamSubscription<void>? _homeSubscription;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween(
      begin: 0.0,
      end: 10.0,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _successAnimation = Tween(
      begin: 1.0,
      end: 1.2,
    ).chain(CurveTween(curve: Curves.easeOut)).animate(_successController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final appService = ref.read(appServiceProvider);
      _homeSubscription = appService.onHomePressed.listen((_) {
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      });
    });
  }

  @override
  void dispose() {
    _homeSubscription?.cancel();
    _shakeController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void _onNumberTap(String number) {
    HapticFeedback.lightImpact();
    if (_pin.length < 6) {
      setState(() {
        _pin += number;
        _errorMessage = '';
      });
      if (_pin.length == 6) {
        _handlePinComplete();
      }
    }
  }

  void _onBackspace() {
    HapticFeedback.lightImpact();
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _errorMessage = '';
      });
    }
  }

  Future<void> _handlePinComplete() async {
    final notifier = ref.read(blackBoxNotifierProvider);

    switch (widget.mode) {
      case BlackBoxMode.setup:
        if (!_isConfirming) {
          setState(() {
            _confirmPin = _pin;
            _pin = '';
            _isConfirming = true;
          });
        } else {
          if (_pin == _confirmPin) {
            try {
              await notifier.setPassword(_pin);
              if (!mounted) return;
              HapticFeedback.mediumImpact();
              setState(() => _showSuccessMessage = true);
              _successController.forward(from: 0);
              await Future.delayed(const Duration(milliseconds: 800));
              if (!mounted) return;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const BlackBoxVaultScreen(showWelcome: true),
                ),
              );
            } catch (e) {
              if (!mounted) return;
              HapticFeedback.heavyImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to save PIN')),
              );
              return;
            }
          } else {
            HapticFeedback.heavyImpact();
            _shakeController.forward(from: 0);
            setState(() {
              _errorMessage = 'PINs do not match. Try again.';
              _pin = '';
              _confirmPin = '';
              _isConfirming = false;
            });
          }
        }
        break;

      case BlackBoxMode.verify:
        final valid = await notifier.verifyPassword(_pin);
        if (!mounted) return;
        if (valid) {
          HapticFeedback.mediumImpact();
          _successController.forward(from: 0);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const BlackBoxVaultScreen()),
          );
        } else {
          HapticFeedback.heavyImpact();
          _shakeController.forward(from: 0);
          setState(() {
            _errorMessage = 'Incorrect PIN';
            _pin = '';
          });
        }
        break;

      case BlackBoxMode.change:
        if (!_isConfirming) {
          // First verify old PIN
          final valid = await notifier.verifyPassword(_pin);
          if (!mounted) return;
          if (valid) {
            HapticFeedback.mediumImpact();
            setState(() {
              _pin = '';
              _isConfirming = true;
            });
          } else {
            HapticFeedback.heavyImpact();
            _shakeController.forward(from: 0);
            setState(() {
              _errorMessage = 'Incorrect current PIN';
              _pin = '';
            });
          }
        } else if (_confirmPin.isEmpty) {
          setState(() {
            _confirmPin = _pin;
            _pin = '';
          });
        } else {
          if (_pin == _confirmPin) {
            try {
              await notifier.setPassword(_pin);
              if (!mounted) return;
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PIN changed successfully')),
              );
              Navigator.of(context).pop();
            } catch (e) {
              if (!mounted) return;
              HapticFeedback.heavyImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to save PIN')),
              );
              return;
            }
          } else {
            HapticFeedback.heavyImpact();
            _shakeController.forward(from: 0);
            setState(() {
              _errorMessage = 'PINs do not match. Try again.';
              _pin = '';
              _confirmPin = '';
            });
          }
        }
        break;
    }
  }

  String get _title {
    switch (widget.mode) {
      case BlackBoxMode.setup:
        return _isConfirming ? 'Confirm PIN' : 'Set Black Box PIN';
      case BlackBoxMode.verify:
        return 'Enter PIN';
      case BlackBoxMode.change:
        if (!_isConfirming) return 'Enter Current PIN';
        if (_confirmPin.isEmpty) return 'Enter New PIN';
        return 'Confirm New PIN';
    }
  }

  String get _subtitle {
    switch (widget.mode) {
      case BlackBoxMode.setup:
        return _isConfirming
            ? 'Enter the same PIN again'
            : 'Create a 6-digit PIN to protect your hidden apps';
      case BlackBoxMode.verify:
        return 'Enter your 6-digit PIN';
      case BlackBoxMode.change:
        if (!_isConfirming) return 'Verify your identity';
        if (_confirmPin.isEmpty) return 'Choose a new 6-digit PIN';
        return 'Enter the same PIN again';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Lock icon
            AnimatedBuilder(
              animation: _successAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _showSuccessMessage ? _successAnimation.value : 1.0,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _showSuccessMessage
                          ? Colors.green.withValues(alpha: 0.15)
                          : AppColors.secondary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _showSuccessMessage ? Icons.check : Icons.lock_outline,
                      size: 40,
                      color: _showSuccessMessage
                          ? Colors.green
                          : AppColors.secondary,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            // Title
            Text(
              _showSuccessMessage ? 'PIN Set!' : _title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _showSuccessMessage ? 'Your Black Box is ready' : _subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // PIN dots
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      final filled = index < _pin.length;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeOut,
                        width: 16,
                        height: 16,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: filled
                              ? AppColors.secondary
                              : Colors.white.withValues(alpha: 0.2),
                          border: filled
                              ? null
                              : Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
            // Error message
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                style: TextStyle(fontSize: 14, color: AppColors.error),
              ),
            ],
            const Spacer(),
            // Number pad
            _buildNumberPad(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          _buildNumberRow(['1', '2', '3']),
          const SizedBox(height: 16),
          _buildNumberRow(['4', '5', '6']),
          const SizedBox(height: 16),
          _buildNumberRow(['7', '8', '9']),
          const SizedBox(height: 16),
          _buildBottomRow(),
        ],
      ),
    );
  }

  Widget _buildNumberRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((n) => _buildNumberButton(n)).toList(),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(width: 72, height: 72), // Empty space
        _buildNumberButton('0'),
        _buildBackspaceButton(),
      ],
    );
  }

  Widget _buildNumberButton(String number) {
    return InkWell(
      onTap: () => _onNumberTap(number),
      borderRadius: BorderRadius.circular(36),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return InkWell(
      onTap: _onBackspace,
      borderRadius: BorderRadius.circular(36),
      child: Container(
        width: 72,
        height: 72,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            size: 28,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
