import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxapay/core/theme/app_theme.dart';
import 'package:fluxapay/features/auth/presentation/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final token = await ref.read(authRepositoryProvider).forgotPassword(_emailController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reset instructions sent! Check your email.'),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // In this demo flow, we'll auto-pass the token to the next screen for convenience
        context.push('/reset-password', extra: {
          'email': _emailController.text,
          'token': token,
        });
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Clearance request failed';
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
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.lock_reset_rounded,
                      color: AppTheme.primaryColor,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Recover Access',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your registered email to receive security clearance and reset your credentials.',
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
                          controller: _emailController,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: 'EMAIL ADDRESS',
                            labelStyle: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                            prefixIcon: const Icon(Icons.email_rounded, color: AppTheme.primaryColor, size: 20),
                            hintText: 'john@example.com',
                            hintStyle: TextStyle(color: secondaryTextColor.withValues(alpha: 0.3)),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => v == null || !v.contains('@') ? 'Invalid email' : null,
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
                              'REQUEST CLEARANCE',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () => context.pop(),
                      child: Text(
                        'BACK TO SECURE LOGIN',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
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
