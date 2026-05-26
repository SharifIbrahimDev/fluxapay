import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxapay/core/theme/app_theme.dart';
import 'package:fluxapay/features/auth/presentation/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;
  final String token;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).resetPassword(
        email: widget.email,
        token: widget.token,
        password: _passwordController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset successful! Please login.'),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Password reset failed';
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.lightTextColor;
    final secondaryTextColor = isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? AppTheme.backgroundGradient : AppTheme.lightBackgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: AppTheme.successColor,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Update Security',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Define a new high-entropy password for your premium account.',
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: isDark 
                        ? AppTheme.glassmorphicDecoration(borderRadius: 32)
                        : AppTheme.lightGlassmorphicDecoration(borderRadius: 32),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _passwordController,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: 'NEW PASSWORD',
                            labelStyle: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                            prefixIcon: const Icon(Icons.lock_rounded, color: AppTheme.primaryColor, size: 20),
                            hintText: '••••••••',
                            hintStyle: TextStyle(color: secondaryTextColor.withValues(alpha: 0.3)),
                          ),
                          obscureText: true,
                          validator: (v) => v == null || v.length < 8 ? 'Min 8 characters' : null,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _confirmPasswordController,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: 'CONFIRM NEW PASSWORD',
                            labelStyle: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                            prefixIcon: const Icon(Icons.verified_user_rounded, color: AppTheme.primaryColor, size: 20),
                            hintText: '••••••••',
                            hintStyle: TextStyle(color: secondaryTextColor.withValues(alpha: 0.3)),
                          ),
                          obscureText: true,
                          validator: (v) => v != _passwordController.text ? 'Passwords do not match' : null,
                        ),
                      ],
                    ),
                  ),
                   const SizedBox(height: 48),
                  Container(
                    width: double.infinity,
                    decoration: AppTheme.gradientDecoration(),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              'UPDATE SECURITY VAULT',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
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
