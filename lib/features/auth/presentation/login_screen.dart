import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxapay/core/theme/app_theme.dart';
import 'package:fluxapay/features/auth/presentation/auth_provider.dart';
import 'package:fluxapay/core/services/biometric_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
    _checkBiometrics();
  }

  bool _isBiometricAvailable = false;

  Future<void> _checkBiometrics() async {
    final available = await ref.read(biometricServiceProvider).isBiometricsAvailable();
    if (mounted) {
      setState(() {
        _isBiometricAvailable = available;
      });
    }
  }

  Future<void> _loginWithBiometrics() async {
    final authenticated = await ref.read(biometricServiceProvider).authenticate();
    if (authenticated) {
      setState(() => _isLoading = true);
      try {
        await ref.read(authStateProvider.notifier).loginWithBiometrics();
      } catch (e) {
        if (mounted) {
          String errorMessage = 'Biometric login failed';
          if (e is DioException) {
            errorMessage = e.response?.data['message'] ?? e.message ?? errorMessage;
          } else {
            errorMessage = e.toString();
          }
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text(errorMessage), 
               backgroundColor: AppTheme.errorColor,
               behavior: SnackBarBehavior.floating,
             ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    print('Attempting login for: ${_emailController.text.trim()}');
    try {
      await ref.read(authStateProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text, // Don't trim password
          );
      print('Login successful');
    } catch (e) {
      print('Login error details: $e');
      String errorMessage = 'Sign in failed';
      
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
          errorMessage = 'Connection timeout. Is the server running and reachable?';
        } else if (e.type == DioExceptionType.connectionError) {
          errorMessage = 'Connection refused. Check your firewall and network.';
        } else {
          errorMessage = e.response?.data['message'] ?? e.message ?? errorMessage;
        }
      } else {
        errorMessage = e.toString();
      }

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.lightTextColor;
    final secondaryTextColor = isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor;
    
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? AppTheme.backgroundGradient : AppTheme.lightBackgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo/Brand Section
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withValues(alpha: 0.3),
                            blurRadius: 40,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/app_icon.png',
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          ),
                        ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Welcome Text
                    Text(
                      'FluxaPay',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Access your premium fintech portal',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 48),
                    
                    // Login Form Card
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: isDark 
                          ? AppTheme.glassmorphicDecoration(borderRadius: 32)
                          : AppTheme.lightGlassmorphicDecoration(borderRadius: 32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              style: TextStyle(color: textColor),
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                                labelStyle: TextStyle(color: secondaryTextColor),
                                prefixIcon: Icon(
                                  Icons.email_rounded,
                                  color: AppTheme.primaryColor.withValues(alpha: 0.7),
                                  size: 20,
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Required';
                                if (!v.contains('@')) return 'Invalid email';
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            
                            TextFormField(
                              controller: _passwordController,
                              style: TextStyle(color: textColor),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(color: secondaryTextColor),
                                prefixIcon: Icon(
                                  Icons.lock_rounded,
                                  color: AppTheme.primaryColor.withValues(alpha: 0.7),
                                  size: 20,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    color: secondaryTextColor,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                                ),
                              ),
                              obscureText: _obscurePassword,
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Required';
                                if (v.length < 6) return 'Min 6 characters';
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => context.push('/forgot-password'),
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(color: AppTheme.primaryColor, fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 24),

                            if (_isBiometricAvailable)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 32.0),
                                child: InkWell(
                                  onTap: _loginWithBiometrics,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppTheme.primaryColor.withValues(alpha: 0.05),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.fingerprint_rounded, color: AppTheme.primaryColor, size: 28),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Quick Biometric Login',
                                          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            
                            Container(
                              width: double.infinity,
                              decoration: AppTheme.gradientDecoration(),
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Secure Sign In',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "New to FluxaPay? ",
                          style: TextStyle(color: secondaryTextColor),
                        ),
                        TextButton(
                          onPressed: () => context.push('/register'),
                          child: ShaderMask(
                            shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
                            child: const Text(
                              'Create Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
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
    );
  }
}
