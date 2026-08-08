import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';
import '../models/theme_settings.dart';
import '../providers/theme_provider.dart';
import '../services/theme_service.dart';

class ThemeOnboardingScreen extends StatefulWidget {
  const ThemeOnboardingScreen({super.key});

  @override
  State<ThemeOnboardingScreen> createState() => _ThemeOnboardingScreenState();
}

class _ThemeOnboardingScreenState extends State<ThemeOnboardingScreen>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  ThemePackEnum _selectedPack = ThemePackEnum.freshGreen;
  ThemeModeEnum _selectedMode = ThemeModeEnum.system;
  late AnimationController _backgroundController;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            _AnimatedBackground(controller: _backgroundController),
            SafeArea(
              child: _currentStep == 0
                  ? _buildStep1()
                  : _buildStep2(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Consumer<ThemeProvider>(
      builder: (context, gradientProvider, child) {
        return Column(
          children: [
            _buildWelcomeHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 16),
                  _buildThemePackGrid(gradientProvider),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            _buildStep1Buttons(gradientProvider),
          ],
        );
      },
    );
  }

  Widget _buildStep2() {
    return Consumer<ThemeProvider>(
      builder: (context, gradientProvider, child) {
        return Column(
          children: [
            _buildAppearanceHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 16),
                  _buildAppearanceModeSelector(gradientProvider),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            _buildStep2Buttons(gradientProvider),
          ],
        );
      },
    );
  }

  Widget _buildWelcomeHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Make GharKaKhana Yours',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a style you love.\nYou can always change it later from Settings.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Appearance',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select how you want the app to look.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemePackGrid(ThemeProvider gradientProvider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: ThemePack.packs.length,
      itemBuilder: (context, index) {
        final packEnum = ThemePack.packs.keys.elementAt(index);
        final pack = ThemePack.packs[packEnum]!;
        final isSelected = _selectedPack == packEnum;
        
        return _ThemePackCard(
          pack: pack,
          packEnum: packEnum,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              _selectedPack = packEnum;
            });
            gradientProvider.setThemePack(packEnum);
            gradientProvider.setGradientEnabled(true);
            HapticFeedback.lightImpact();
          },
        );
      },
    );
  }

  Widget _buildAppearanceModeSelector(ThemeProvider gradientProvider) {
    return Column(
      children: [
        _AppearanceModeCard(
          icon: Icons.light_mode,
          title: 'Light',
          description: 'Bright and clean',
          mode: ThemeModeEnum.light,
          selectedMode: _selectedMode,
          onTap: (mode) {
            setState(() {
              _selectedMode = mode;
            });
            gradientProvider.setThemeMode(mode);
            HapticFeedback.lightImpact();
          },
        ),
        const SizedBox(height: 12),
        _AppearanceModeCard(
          icon: Icons.dark_mode,
          title: 'Dark',
          description: 'Easy on the eyes',
          mode: ThemeModeEnum.dark,
          selectedMode: _selectedMode,
          onTap: (mode) {
            setState(() {
              _selectedMode = mode;
            });
            gradientProvider.setThemeMode(mode);
            HapticFeedback.lightImpact();
          },
        ),
        const SizedBox(height: 12),
        _AppearanceModeCard(
          icon: Icons.brightness_4,
          title: 'AMOLED',
          description: 'Pure black for night',
          mode: ThemeModeEnum.amoled,
          selectedMode: _selectedMode,
          onTap: (mode) {
            setState(() {
              _selectedMode = mode;
            });
            gradientProvider.setThemeMode(mode);
            HapticFeedback.lightImpact();
          },
        ),
        const SizedBox(height: 12),
        _AppearanceModeCard(
          icon: Icons.brightness_auto,
          title: 'Follow Device',
          description: 'Automatically switch',
          mode: ThemeModeEnum.system,
          selectedMode: _selectedMode,
          onTap: (mode) {
            setState(() {
              _selectedMode = mode;
            });
            gradientProvider.setThemeMode(mode);
            HapticFeedback.lightImpact();
          },
        ),
      ],
    );
  }

  Widget _buildStep1Buttons(ThemeProvider gradientProvider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () {
                  setState(() {
                    _currentStep = 1;
                  });
                  HapticFeedback.mediumImpact();
                },
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => _handleSkip(gradientProvider),
              child: Text(
                'Skip for now',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2Buttons(ThemeProvider gradientProvider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () => _handleContinue(gradientProvider),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  _currentStep = 0;
                });
                HapticFeedback.lightImpact();
              },
              child: Text(
                'Back',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleContinue(ThemeProvider gradientProvider) async {
    await ThemeService.setFirstLaunchCompleted();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  Future<void> _handleSkip(ThemeProvider gradientProvider) async {
    await gradientProvider.setThemePack(ThemePackEnum.freshGreen);
    await gradientProvider.setThemeMode(ThemeModeEnum.system);
    await gradientProvider.setGradientEnabled(true);
    await ThemeService.setFirstLaunchCompleted();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }
}

class _AnimatedBackground extends StatelessWidget {
  const _AnimatedBackground({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final value = controller.value;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                math.sin(value * math.pi * 2) * 0.3,
                math.cos(value * math.pi * 2) * 0.3 - 0.5,
              ),
              end: Alignment(
                -math.sin(value * math.pi * 2) * 0.3,
                -math.cos(value * math.pi * 2) * 0.3 + 0.5,
              ),
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surfaceContainerHighest,
              ],
            ),
          ),
          child: Stack(
            children: [
              _FloatingBlob(
                controller: controller,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                size: 200,
                offset: 0,
              ),
              _FloatingBlob(
                controller: controller,
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
                size: 150,
                offset: 2,
              ),
              _FloatingBlob(
                controller: controller,
                color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.05),
                size: 180,
                offset: 4,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FloatingBlob extends StatelessWidget {
  const _FloatingBlob({
    required this.controller,
    required this.color,
    required this.size,
    required this.offset,
  });

  final AnimationController controller;
  final Color color;
  final double size;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final value = controller.value;
        final x = math.sin((value * math.pi * 2) + offset) * 50;
        final y = math.cos((value * math.pi * 2) + offset) * 50;
        
        return Positioned(
          left: x + MediaQuery.of(context).size.width / 2 - size / 2,
          top: y + MediaQuery.of(context).size.height / 2 - size / 2,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

class _ThemePackCard extends StatefulWidget {
  const _ThemePackCard({
    required this.pack,
    required this.packEnum,
    required this.isSelected,
    required this.onTap,
  });

  final ThemePack pack;
  final ThemePackEnum packEnum;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_ThemePackCard> createState() => _ThemePackCardState();
}

class _ThemePackCardState extends State<_ThemePackCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    if (widget.isSelected) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_ThemePackCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                color: widget.pack.background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.isSelected
                      ? widget.pack.primary
                      : Colors.transparent,
                  width: 2,
                ),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: widget.pack.primary.withValues(alpha: 0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.pack.emoji,
                              style: const TextStyle(fontSize: 28),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.pack.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _getDescription(widget.packEnum),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      height: 1.2,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: _MiniPhonePreview(pack: widget.pack),
                        ),
                      ],
                    ),
                  ),
                  if (widget.isSelected)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: widget.pack.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getDescription(ThemePackEnum packEnum) {
    switch (packEnum) {
      case ThemePackEnum.freshGreen:
        return 'Fresh and natural for everyday meals.';
      case ThemePackEnum.ocean:
        return 'Modern, clean and calming.';
      case ThemePackEnum.sunrise:
        return 'Bright and energetic.';
      case ThemePackEnum.coffeeHouse:
        return 'Warm and elegant.';
      case ThemePackEnum.roseKitchen:
        return 'Soft and beautiful.';
      case ThemePackEnum.mangoDelight:
        return 'Fresh and vibrant.';
      case ThemePackEnum.indianSpice:
        return 'Inspired by Indian kitchens.';
      case ThemePackEnum.organicLeaf:
        return 'Earthy and organic tones.';
    }
  }
}

class _MiniPhonePreview extends StatelessWidget {
  const _MiniPhonePreview({required this.pack});

  final ThemePack pack;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [pack.primary, pack.secondary],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 6,
                    width: 30,
                    decoration: BoxDecoration(
                      color: pack.primary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    height: 5,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 12,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: pack.button,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.black.withValues(alpha: 0.08),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  Icons.home,
                  size: 10,
                  color: pack.primary,
                ),
                Icon(
                  Icons.search,
                  size: 10,
                  color: Colors.black.withValues(alpha: 0.25),
                ),
                Icon(
                  Icons.bookmark,
                  size: 10,
                  color: Colors.black.withValues(alpha: 0.25),
                ),
                Icon(
                  Icons.person,
                  size: 10,
                  color: Colors.black.withValues(alpha: 0.25),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppearanceModeCard extends StatefulWidget {
  const _AppearanceModeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.mode,
    required this.selectedMode,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final ThemeModeEnum mode;
  final ThemeModeEnum selectedMode;
  final Function(ThemeModeEnum) onTap;

  @override
  State<_AppearanceModeCard> createState() => _AppearanceModeCardState();
}

class _AppearanceModeCardState extends State<_AppearanceModeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    if (widget.selectedMode == widget.mode) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_AppearanceModeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedMode != oldWidget.selectedMode) {
      if (widget.selectedMode == widget.mode) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.selectedMode == widget.mode;
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: () => widget.onTap(widget.mode),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      widget.icon,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                      size: 22,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
