import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxapay/core/theme/app_theme.dart';
import 'package:fluxapay/features/auth/presentation/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceiveScreen extends ConsumerWidget {
  const ReceiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final email = user?.email ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    void copyToClipboard() {
      Clipboard.setData(ClipboardData(text: email));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Email address copied to clipboard'),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Receive Money',
          style: TextStyle(color: isDark ? Colors.white : AppTheme.lightTextColor),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new, 
            size: 20,
            color: isDark ? Colors.white : AppTheme.lightTextColor,
          ),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: isDark 
                      ? AppTheme.glassmorphicDecoration(borderRadius: 32)
                      : AppTheme.lightGlassmorphicDecoration(borderRadius: 32),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: QrImageView(
                          data: email,
                          version: QrVersions.auto,
                          size: 200.0,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_rounded,
                            size: 18,
                            color: isDark ? Colors.white60 : Colors.black45,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Scan to pay',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        email,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppTheme.lightTextColor,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      if (user?.accountNumber != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.black12 : AppTheme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? Colors.white24 : AppTheme.primaryColor.withValues(alpha: 0.2)
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Account Number',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    user!.accountNumber!,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                      color: isDark ? Colors.white : AppTheme.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(text: user.accountNumber!));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('Account Number copied!'),
                                          backgroundColor: AppTheme.successColor,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.copy, 
                                      size: 16, 
                                      color: isDark ? Colors.white70 : AppTheme.primaryColor
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  decoration: AppTheme.gradientDecoration(),
                  child: ElevatedButton.icon(
                    onPressed: copyToClipboard,
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy Email Address'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
