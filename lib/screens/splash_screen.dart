import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  static const _minSplashDuration = Duration(milliseconds: 3000);
  static const _exitDuration = Duration(milliseconds: 300);
  static const _onboardingCompleteKey = 'gharkakhana_onboarding_complete';

  late final AnimationController _introController;
  late final AnimationController _exitController;
  late final AnimationController _textController;

  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _exitFade;

  // Text animations
  late final List<Animation<double>> _letterAnimations;
  late final Animation<double> _taglineFade;
  late final Animation<Offset> _taglineSlide;

  bool _initialized = false;
  bool _navigated = false;
  bool _didPrecacheLogo = false;
  bool _onboardingComplete = false;
  bool _firstLaunchCompleted = false;
  bool _reduceMotion = false;
  bool _animationCompleted = false;

  static const String _appName = 'GharKaKhana';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      debugPrint('[SplashScreen] Splash animation started');
      unawaited(_introController.forward());
      unawaited(_bootstrap());
    });
  }

  @override
  void dispose() {
    _introController.dispose();
    _exitController.dispose();
    _textController.dispose();
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

    _exitController = AnimationController(vsync: this, duration: _exitDuration);

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Logo animations
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.30, curve: Curves.easeOutCubic),
      ),
    );

    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.30, curve: Curves.easeOutBack),
      ),
    );

    // Letter animations - staggered bounce
    _letterAnimations = List.generate(
      _appName.length,
      (index) {
        final stagger = index * 0.07; // 70ms stagger per letter
        final start = 0.10 + stagger;
        final end = (start + 0.30).clamp(0.0, 1.0);
        
        return Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _textController,
            curve: Interval(start, end, curve: Curves.easeOutBack),
          ),
        );
      },
    );

    // Tagline animations
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.80, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _taglineSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.80, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // Exit animation
    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeInOutCubic),
    );

    // Listen for text animation completion
    _textController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        debugPrint('[SplashScreen] Text animation completed');
        if (mounted) {
          setState(() {
            _animationCompleted = true;
          });
          debugPrint('[SplashScreen] Animation completed flag set, attempting navigation');
          _tryNavigate();
        }
      }
    });
  }

  Future<void> _bootstrap() async {
    debugPrint('[SplashScreen] Bootstrap started');
    // Check first launch FIRST - highest priority
    await _checkFirstLaunchStatus();
    
    // Then check other dependencies
    await _waitForAuthReady();
    await _checkOnboardingStatus();
    await _checkForUpdates();
    
    debugPrint('[SplashScreen] Initialization checks completed');
    
    // Start text animation after logo appears (short delay for visual clarity)
    if (!_reduceMotion) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        debugPrint('[SplashScreen] Starting text animation');
        _textController.forward();
      }
    } else {
      // For reduced motion, mark animation as complete immediately
      if (mounted) {
        setState(() {
          _animationCompleted = true;
        });
      }
    }
    
    if (!mounted) return;
    setState(() => _initialized = true);
    debugPrint('[SplashScreen] Initialization flag set');
    
    // Try navigate now - it will only proceed if animation is also complete
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
    try {
      final updateProvider = context.read<UpdateProvider>();
      await updateProvider.init(); // Ensure version info is loaded
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
      
      // Handle mandatory update (versionCode below minimum)
      if (updateProvider.isMandatoryUpdate) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/mandatory-update');
        }
        return;
      }
      
      // Handle soft update (show dialog but allow navigation)
      // Only show if update is available AND it's not a mandatory update
      if (updateProvider.isUpdateAvailable && !updateProvider.isMandatoryUpdate) {
        if (mounted) {
          _showSoftUpdateDialog(updateProvider);
        }
      }
    } catch (e) {
      // If version check fails, log error but allow app to continue
      // This prevents the app from getting stuck on splash screen
      debugPrint('[SplashScreen] Update check failed: $e');
      // Continue with normal navigation
    }
  }

  void _showSoftUpdateDialog(UpdateProvider updateProvider) {
    final appVersion = updateProvider.appVersion;
    if (appVersion == null) return;
    
    showDialog(
      context: context,
      builder: (context) => UpdateDialog(
        appVersion: appVersion,
        currentVersion: updateProvider.currentVersionName ?? 'Unknown',
        forceUpdate: false,
        onUpdateNow: () {
          Navigator.of(context).pop();
          updateProvider.downloadUpdate(appVersion.downloadUrl);
        },
        onLater: () {
          Navigator.of(context).pop();
          updateProvider.ignoreVersion();
        },
      ),
    );
  }

  void _tryNavigate() {
    // Only navigate if BOTH initialization AND animation are complete
    debugPrint('[SplashScreen] _tryNavigate called - initialized: $_initialized, animationCompleted: $_animationCompleted, navigated: $_navigated');
    if (_navigated || !_initialized || !_animationCompleted) {
      debugPrint('[SplashScreen] Navigation blocked - waiting for both initialization and animation');
      return;
    }
    
    debugPrint('[SplashScreen] Navigation proceeding');
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
    return FadeTransition(
      opacity: _exitFade,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF), // Pure white background
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  _LogoSection(
                    logoOpacity: _logoOpacity,
                    logoScale: _logoScale,
                  ),
                  const SizedBox(height: 48),
                  
                  // Animated App Name - Bouncing Letters
                  _BouncingText(
                    text: _appName,
                    animations: _letterAnimations,
                    reduceMotion: _reduceMotion,
                  ),
                  const SizedBox(height: 32),
                  
                  // Tagline
                  FadeTransition(
                    opacity: _taglineFade,
                    child: SlideTransition(
                      position: _taglineSlide,
                      child: Column(
                        children: [
                          Text(
                            'Fresh Homemade Food',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Made With Love ❤️',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500],
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoSection extends StatelessWidget {
  const _LogoSection({
    required this.logoOpacity,
    required this.logoScale,
  });

  final Animation<double> logoOpacity;
  final Animation<double> logoScale;

  static const _logoSize = 160.0;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: logoOpacity,
      child: ScaleTransition(
        scale: logoScale,
        child: Image.asset(
          _SplashScreenState._logoAsset,
          width: _logoSize,
          height: _logoSize,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}

class _BouncingText extends StatelessWidget {
  const _BouncingText({
    required this.text,
    required this.animations,
    required this.reduceMotion,
  });

  final String text;
  final List<Animation<double>> animations;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    if (reduceMotion) {
      // Show static text for reduced motion
      return Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A1A1A),
          letterSpacing: 1.0,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        text.length,
        (index) => _BouncingLetter(
          letter: text[index],
          animation: animations[index],
        ),
      ),
    );
  }
}

class _BouncingLetter extends StatelessWidget {
  const _BouncingLetter({
    required this.letter,
    required this.animation,
  });

  final String letter;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final value = animation.value;
        
        // Bounce effect: scale 0.85 -> 1.0 -> 1.03 -> 1.0
        final scale = _bounceScale(value);
        // Vertical movement: start below, bounce up, settle
        final yOffset = _bounceOffset(value);
        // Fade in
        final opacity = value.clamp(0.0, 1.0);

        return Transform.translate(
          offset: Offset(0, yOffset),
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: Text(
                letter,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _bounceScale(double value) {
    if (value < 0.5) {
      return 0.85 + (value * 0.3); // 0.85 -> 1.0
    } else if (value < 0.8) {
      return 1.0 + ((value - 0.5) * 0.1); // 1.0 -> 1.03
    } else {
      return 1.03 - ((value - 0.8) * 0.15); // 1.03 -> 1.0
    }
  }

  double _bounceOffset(double value) {
    // Start 20px below, bounce up to -5px, settle at 0
    if (value < 0.5) {
      return 20.0 - (value * 40.0); // 20 -> -20
    } else if (value < 0.8) {
      return -20.0 + ((value - 0.5) * 50.0); // -20 -> -5
    } else {
      return -5.0 + ((value - 0.8) * 25.0); // -5 -> 0
    }
  }
}
