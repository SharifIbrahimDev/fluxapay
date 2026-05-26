import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxapay/core/theme/app_theme.dart';
import 'package:fluxapay/features/auth/presentation/auth_provider.dart';
import 'package:dio/dio.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
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
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(authStateProvider.notifier).register(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _phoneController.text.trim(),
            _passwordController.text.trim(),
          );
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Registration failed';
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      'Join FluxaPay',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Universal premium assets management',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 48),
                    
                    // Register Form Card
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
                              controller: _nameController,
                              style: TextStyle(color: textColor),
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                labelStyle: TextStyle(color: secondaryTextColor),
                                prefixIcon: Icon(
                                  Icons.person_rounded,
                                  color: AppTheme.primaryColor.withValues(alpha: 0.7),
                                  size: 20,
                                ),
                              ),
                              validator: (v) =>
                                  (v == null || v.isEmpty) ? 'Required' : null,
                            ),
                            const SizedBox(height: 24),
                            
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
                              controller: _phoneController,
                              style: TextStyle(color: textColor),
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                labelStyle: TextStyle(color: secondaryTextColor),
                                prefixIcon: Icon(
                                  Icons.phone_rounded,
                                  color: AppTheme.primaryColor.withValues(alpha: 0.7),
                                  size: 20,
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (v) =>
                                  (v == null || v.isEmpty) ? 'Required' : null,
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
                            const SizedBox(height: 48),
                            
                            Container(
                              width: double.infinity,
                              decoration: AppTheme.gradientDecoration(),
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _register,
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
                                        'Create FluxaPay Account',
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
                          'Already a member? ',
                          style: TextStyle(color: secondaryTextColor),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: ShaderMask(
                            shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
                            child: const Text(
                              'Sign In',
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
