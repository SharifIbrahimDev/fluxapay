import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxapay/core/theme/app_theme.dart';
import 'package:fluxapay/features/auth/presentation/auth_provider.dart';
import 'package:go_router/go_router.dart';

class ChangePinScreen extends ConsumerStatefulWidget {
  const ChangePinScreen({super.key});

  @override
  ConsumerState<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends ConsumerState<ChangePinScreen> {
  final _oldPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authRepositoryProvider).changePin(
            _oldPinController.text,
            _newPinController.text,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('PIN updated successfully!'),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
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
        title: Text('Security Update', style: TextStyle(color: textColor)),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   const SizedBox(height: 20),
                   Text(
                     'Transaction PIN',
                     style: TextStyle(
                       color: textColor,
                       fontSize: 28,
                       fontWeight: FontWeight.w900,
                       letterSpacing: -0.5,
                     ),
                   ),
                   const SizedBox(height: 8),
                   Text(
                     'Update your authorization code for secure movements.',
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
                         _PinInput(
                           controller: _oldPinController,
                           label: 'CURRENT PIN',
                           isDark: isDark,
                           textColor: textColor,
                           secondaryTextColor: secondaryTextColor,
                         ),
                         const SizedBox(height: 32),
                         _PinInput(
                           controller: _newPinController,
                           label: 'NEW PIN',
                           isDark: isDark,
                           textColor: textColor,
                           secondaryTextColor: secondaryTextColor,
                         ),
                         const SizedBox(height: 32),
                         _PinInput(
                           controller: _confirmPinController,
                           label: 'CONFIRM NEW PIN',
                           isDark: isDark,
                           textColor: textColor,
                           secondaryTextColor: secondaryTextColor,
                           validator: (value) {
                             if (value != _newPinController.text) return 'PINs do not match';
                             return null;
                           },
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
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text(
                            'UPDATE SECURITY PIN', 
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1)
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

class _PinInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final bool isDark;
  final Color textColor;
  final Color secondaryTextColor;

  const _PinInput({
    required this.controller, 
    required this.label, 
    this.validator,
    required this.isDark,
    required this.textColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      obscureText: true,
      style: TextStyle(color: textColor, letterSpacing: 12, fontSize: 20, fontWeight: FontWeight.w900),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: secondaryTextColor, letterSpacing: 1, fontSize: 11, fontWeight: FontWeight.bold),
        prefixIcon: Icon(Icons.lock_rounded, color: AppTheme.primaryColor, size: 20),
        hintText: '****',
        hintStyle: TextStyle(color: secondaryTextColor.withValues(alpha: 0.3)),
      ),
      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
      validator: validator ?? (value) => (value == null || value.length != 4) ? 'Enter 4-digit PIN' : null,
    );
  }
}
