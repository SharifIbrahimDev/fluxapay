import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxapay/core/theme/app_theme.dart';
import 'package:fluxapay/features/auth/presentation/auth_provider.dart';
import 'package:go_router/go_router.dart';

class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).setPin(_pinController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PIN set successfully')),
        );
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
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
        title: Text('Security Token', style: TextStyle(color: textColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: textColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? AppTheme.backgroundGradient : AppTheme.lightBackgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Create Transaction PIN',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A 4-digit code to authorize all premium assets movements.',
                    style: TextStyle(color: secondaryTextColor, fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 48),
                  
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: isDark 
                        ? AppTheme.glassmorphicDecoration(borderRadius: 32)
                        : AppTheme.lightGlassmorphicDecoration(borderRadius: 32),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _pinController,
                          style: TextStyle(color: textColor, letterSpacing: 12, fontSize: 20, fontWeight: FontWeight.w900),
                          decoration: InputDecoration(
                            labelText: 'NEW PIN',
                            labelStyle: TextStyle(color: secondaryTextColor, letterSpacing: 1, fontSize: 12),
                            prefixIcon: Icon(Icons.lock_rounded, color: AppTheme.primaryColor, size: 20),
                            hintText: '****',
                            hintStyle: TextStyle(color: secondaryTextColor.withValues(alpha: 0.3)),
                          ),
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          maxLength: 4,
                          buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                          validator: (v) => v?.length != 4 ? 'Must be 4 digits' : null,
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _confirmPinController,
                          style: TextStyle(color: textColor, letterSpacing: 12, fontSize: 20, fontWeight: FontWeight.w900),
                          decoration: InputDecoration(
                            labelText: 'CONFIRM PIN',
                            labelStyle: TextStyle(color: secondaryTextColor, letterSpacing: 1, fontSize: 12),
                            prefixIcon: Icon(Icons.verified_user_rounded, color: AppTheme.primaryColor, size: 20),
                            hintText: '****',
                            hintStyle: TextStyle(color: secondaryTextColor.withValues(alpha: 0.3)),
                          ),
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          maxLength: 4,
                          buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                          validator: (v) => v != _pinController.text ? 'PINs do not match' : null,
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
                        padding: const EdgeInsets.symmetric(vertical: 18),
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
                              'ACTIVATE SECURITY PIN',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
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
