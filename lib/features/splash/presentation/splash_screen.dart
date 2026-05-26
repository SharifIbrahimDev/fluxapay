import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxapay/core/theme/app_theme.dart';
import 'package:fluxapay/features/auth/presentation/auth_provider.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // Navigate after animation
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _checkAuthAndNavigate();
      }
    });
  }

  void _checkAuthAndNavigate() {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user != null) {
      if (!user.isPinSet) {
        context.go('/pin-setup');
      } else {
        context.go('/');
      }
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppTheme.backgroundGradient : AppTheme.lightBackgroundGradient,
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   // Animated Logo Container
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppTheme.primaryGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withValues(alpha: 0.4),
                              blurRadius: 40,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.2),
                              blurRadius: 1,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/app_icon.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Brand Name and Slogan
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'FLUXAPAY',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                letterSpacing: 8,
                                fontWeight: FontWeight.w900,
                                color: isDark ? Colors.white : AppTheme.lightTextColor,
                                fontSize: 32,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'SECURE • FAST • GLOBAL',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isDark ? Colors.white38 : AppTheme.lightSecondaryTextColor,
                                letterSpacing: 4,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Footer branding
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'PREMIUM FINTECH SOLUTIONS',
                      style: TextStyle(
                        color: isDark ? Colors.white24 : Colors.black12,
                        fontSize: 10,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
