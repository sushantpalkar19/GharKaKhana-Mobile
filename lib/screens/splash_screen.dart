import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/theme.dart';
import '../providers/auth_provider.dart';
import '../providers/update_provider.dart';
import '../services/theme_service.dart';
import '../widgets/update_dialog.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const _logoAsset = 'assets/branding/logo.png';
  static const _minSplashDuration = Duration(milliseconds: 2500);
  static const _exitDuration = Duration(milliseconds: 300);
  static const _onboardingCompleteKey = 'gharkakhana_onboarding_complete';

  late final AnimationController _introController;
  late final AnimationController _backgroundController;
  late final AnimationController _exitController;

  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFloat;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<Offset> _subtitleSlide;
  late final Animation<double> _loadingFade;
  late final Animation<double> _exitFade;

  bool _initialized = false;
  bool _navigated = false;
  bool _didPrecacheLogo = false;
  bool _onboardingComplete = false;
  bool _firstLaunchCompleted = false;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_reduceMotion) {
        _backgroundController.repeat();
      }
      unawaited(_introController.forward());
      unawaited(_bootstrap());
    });
  }

  @override
  void dispose() {
    _introController.dispose();
    _backgroundController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.of(context).disableAnimations;
    if (_didPrecacheLogo) return;
    _didPrecacheLogo = true;
    precacheImage(const AssetImage(_logoAsset), context);
  }

  void _setupAnimations() {
    _introController = AnimationController(
      vsync: this,
      duration: _minSplashDuration,
    );

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    _exitController = AnimationController(vsync: this, duration: _exitDuration);

    // Logo animations
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.36, 0.60, curve: Curves.easeOutCubic),
      ),
    );

    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.36, 0.60, curve: Curves.easeOutBack),
      ),
    );

    _logoFloat = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.60, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Title animations
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.72, 0.88, curve: Curves.easeOutCubic),
      ),
    );

    _titleSlide =
        Tween<Offset>(begin: const Offset(0.0, 0.20), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _introController,
            curve: const Interval(0.72, 0.88, curve: Curves.easeOutCubic),
          ),
        );

    // Subtitle animations
    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.88, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _subtitleSlide =
        Tween<Offset>(begin: const Offset(0.0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _introController,
            curve: const Interval(0.88, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    // Loading animation
    _loadingFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.88, 1.0, curve: Curves.easeOut),
      ),
    );

    // Exit animation
    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeInOutCubic),
    );
  }

  Future<void> _bootstrap() async {
    // Check first launch FIRST - highest priority
    await _checkFirstLaunchStatus();
    
    // Then check other dependencies
    await _waitForAuthReady();
    await _checkOnboardingStatus();
    await _checkForUpdates();
    
    if (!mounted) return;
    setState(() => _initialized = true);
    _tryNavigate();
  }

  Future<void> _waitForAuthReady() async {
    final auth = context.read<AuthProvider>();
    await auth.init();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _onboardingComplete = prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  Future<void> _checkFirstLaunchStatus() async {
    _firstLaunchCompleted = !(await ThemeService.isFirstLaunch());
  }

  Future<void> _checkForUpdates() async {
    final updateProvider = context.read<UpdateProvider>();
    await updateProvider.checkForUpdate();
    
    // Handle maintenance mode
    if (updateProvider.appVersion?.maintenanceMode == true) {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/maintenance',
          arguments: {'message': updateProvider.appVersion?.maintenanceMessage},
        );
      }
      return;
    }
    
    // Handle force update
    if (updateProvider.isUpdateAvailable && updateProvider.appVersion?.forceUpdate == true) {
      if (mounted) {
        _showForceUpdateDialog(updateProvider);
      }
      return;
    }
    
    // Handle soft update (show dialog but allow navigation)
    if (updateProvider.isUpdateAvailable && updateProvider.appVersion?.forceUpdate == false) {
      if (mounted) {
        _showSoftUpdateDialog(updateProvider);
      }
    }
  }

  void _showForceUpdateDialog(UpdateProvider updateProvider) {
    final appVersion = updateProvider.appVersion;
    if (appVersion == null) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: UpdateDialog(
          appVersion: appVersion,
          currentVersion: '1.0.0', // TODO: Get from package_info
          forceUpdate: true,
          onUpdateNow: () {
            // TODO: Implement download and install
            Navigator.of(context).pop();
          },
          onLater: () {}, // Disabled for force update
        ),
      ),
    );
  }

  void _showSoftUpdateDialog(UpdateProvider updateProvider) {
    final appVersion = updateProvider.appVersion;
    if (appVersion == null) return;
    
    showDialog(
      context: context,
      builder: (context) => UpdateDialog(
        appVersion: appVersion,
        currentVersion: '1.0.0', // TODO: Get from package_info
        forceUpdate: false,
        onUpdateNow: () {
          // TODO: Implement download and install
          Navigator.of(context).pop();
        },
        onLater: () {
          Navigator.of(context).pop();
          updateProvider.ignoreVersion();
        },
      ),
    );
  }

  void _tryNavigate() {
    if (_navigated || !_initialized) return;
    
    // Check if force update dialog is blocking navigation
    final updateProvider = context.read<UpdateProvider>();
    if (updateProvider.isUpdateAvailable && updateProvider.appVersion?.forceUpdate == true) {
      // Don't navigate if force update dialog is shown
      return;
    }
    
    _navigated = true;
    _exitController.forward().then((_) {
      if (!mounted) return;
      
      // Check if theme onboarding is needed (first launch)
      if (!_firstLaunchCompleted) {
        Navigator.pushReplacementNamed(context, '/theme-onboarding');
        return;
      }
      
      // Check if onboarding is needed
      if (!_onboardingComplete) {
        Navigator.pushReplacementNamed(context, '/onboarding');
        return;
      }
      
      // Role-based auth flow
      final auth = context.read<AuthProvider>();
      if (auth.isAuthenticated) {
        final dashboardRoute = auth.getDashboardRoute();
        Navigator.pushReplacementNamed(context, dashboardRoute);
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeExtension = AppThemeExtension.of(context);
    final gradientEnabled = themeExtension.gradientEnabled;
    final themePack = themeExtension.themePack;
    
    return FadeTransition(
      opacity: _exitFade,
      child: Scaffold(
        backgroundColor: themePack.background,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Animated Background
            if (!_reduceMotion && gradientEnabled)
              _AnimatedGradientBackground(
                controller: _backgroundController,
                gradient: themeExtension.gradient,
              ),
            
            // Floating Particles
            if (!_reduceMotion)
              _FloatingParticles(
                controller: _backgroundController,
                color: themePack.primary,
              ),
            
            // Content
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    _LogoSection(
                      controller: _introController,
                      logoOpacity: _logoOpacity,
                      logoScale: _logoScale,
                      logoFloat: _logoFloat,
                    ),
                    const SizedBox(height: 32),
                    
                    // Title
                    SlideTransition(
                      position: _titleSlide,
                      child: FadeTransition(
                        opacity: _titleFade,
                        child: Text(
                          'GharKaKhana',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Subtitle
                    SlideTransition(
                      position: _subtitleSlide,
                      child: FadeTransition(
                        opacity: _subtitleFade,
                        child: Text(
                          'Fresh Homemade Food\nMade With Love ❤️',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Loading Indicator
            Positioned(
              left: 0,
              right: 0,
              bottom: 80,
              child: FadeTransition(
                opacity: _loadingFade,
                child: _PremiumLoadingDots(
                  controller: _introController,
                  color: themePack.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoSection extends StatelessWidget {
  const _LogoSection({
    required this.controller,
    required this.logoOpacity,
    required this.logoScale,
    required this.logoFloat,
  });

  final AnimationController controller;
  final Animation<double> logoOpacity;
  final Animation<double> logoScale;
  final Animation<double> logoFloat;

  static const _stageSize = 224.0;
  static const _logoSize = 176.0;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox.square(
        dimension: _stageSize,
        child: FadeTransition(
          opacity: logoOpacity,
          child: ScaleTransition(
            scale: logoScale,
            child: AnimatedBuilder(
              animation: logoFloat,
              builder: (context, child) {
                final floatOffset = math.sin(logoFloat.value * math.pi * 2) * 8;
                return Transform.translate(
                  offset: Offset(0, -floatOffset),
                  child: child,
                );
              },
              child: Image.asset(
                _SplashScreenState._logoAsset,
                width: _logoSize,
                height: _logoSize,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                isAntiAlias: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedGradientBackground extends StatelessWidget {
  const _AnimatedGradientBackground({
    required this.controller,
    required this.gradient,
  });

  final AnimationController controller;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final value = controller.value;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient.colors,
              begin: Alignment(
                math.sin(value * math.pi * 2) * 0.5,
                math.cos(value * math.pi * 2) * 0.5 - 0.5,
              ),
              end: Alignment(
                -math.sin(value * math.pi * 2) * 0.5,
                -math.cos(value * math.pi * 2) * 0.5 + 0.5,
              ),
              stops: gradient.stops,
            ),
          ),
        );
      },
    );
  }
}

class _FloatingParticles extends StatelessWidget {
  const _FloatingParticles({
    required this.controller,
    required this.color,
  });

  final AnimationController controller;
  final Color color;

  static const _particleCount = 15;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          children: List.generate(_particleCount, (index) {
            final value = controller.value;
            final angle = (index / _particleCount) * math.pi * 2;
            final radius = 100 + math.sin(value * math.pi * 2 + angle) * 50;
            final x = math.cos(angle + value * 0.5) * radius;
            final y = math.sin(angle + value * 0.5) * radius;
            final opacity = (math.sin(value * math.pi * 2 + angle) + 1) / 2 * 0.08;
            
            return Positioned(
              left: x + MediaQuery.of(context).size.width / 2,
              top: y + MediaQuery.of(context).size.height / 2,
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 4 + index % 3 * 2,
                  height: 4 + index % 3 * 2,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _PremiumLoadingDots extends StatelessWidget {
  const _PremiumLoadingDots({required this.controller, required this.color});

  final AnimationController controller;
  final Color color;

  static const _dotSize = 8.0;
  static const _activeStart = 0.88;
  static const _activeEnd = 1.0;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final progress =
              ((controller.value - _activeStart) / (_activeEnd - _activeStart))
                  .clamp(0.0, 1.0);

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final pulse = _dotPulse(progress, index);
              final opacity = 0.35 + pulse * 0.65;
              final scale = 1.0 + pulse * 0.3;
              final offset = -pulse * 6.0;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Transform.translate(
                  offset: Offset(0, offset),
                  child: Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: SizedBox.square(
                        dimension: _dotSize,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  double _dotPulse(double progress, int index) {
    final delayed = (progress * 1.2 - index * 0.15).clamp(0.0, 1.0);
    if (delayed <= 0.0 || delayed >= 1.0) return 0.0;
    return math.sin(delayed * math.pi);
  }
}
