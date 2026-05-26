import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxapay/core/theme/app_theme.dart';
import 'package:fluxapay/core/theme/theme_provider.dart';
import 'package:fluxapay/features/auth/presentation/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fluxapay/core/services/biometric_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isBiometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricState();
  }

  Future<void> _loadBiometricState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isBiometricEnabled = prefs.getBool('biometric_enabled') ?? false;
    });
  }

  Future<void> _toggleBiometric(bool value) async {
    final biometricService = ref.read(biometricServiceProvider);
    
    if (value) {
      final available = await biometricService.isBiometricsAvailable();
      if (!available) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Biometrics not available on this device.')),
          );
        }
        return;
      }

      final authenticated = await biometricService.authenticate();
      if (!authenticated) return;

      // Ask for password to store it securely for future logins
      if (mounted) {
        final password = await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            final controller = TextEditingController();
            return AlertDialog(
              title: const Text('Enable Biometric Login'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     const Text('Please enter your account password to securely enable biometric login.'),
                     const SizedBox(height: 16),
                     TextField(
                       controller: controller,
                       obscureText: true,
                       decoration: const InputDecoration(
                         labelText: 'Password',
                         border: OutlineInputBorder(),
                       ),
                     ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, controller.text),
                  child: const Text('Enable'),
                ),
              ],
            );
          },
        );

        if (password != null && password.isNotEmpty) {
          try {
            await ref.read(authStateProvider.notifier).enableBiometric(password);
            setState(() => _isBiometricEnabled = true);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Biometric login enabled successfully!'), backgroundColor: AppTheme.successColor),
              );
            }
          } catch (e) {
            if (mounted) {
               ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to enable biometrics: $e'), backgroundColor: AppTheme.errorColor),
              );
            }
          }
        }
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('biometric_enabled', false);
      await ref.read(authRepositoryProvider).clearBiometricCredentials();
      setState(() => _isBiometricEnabled = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);
    final textColor = isDark ? Colors.white : AppTheme.lightTextColor;
    final secondaryTextColor = isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: textColor),
        ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(title: 'PREFERENCES', textColor: secondaryTextColor),
                const SizedBox(height: 12),
                Container(
                  decoration: isDark 
                      ? AppTheme.glassmorphicDecoration(borderRadius: 24) 
                      : AppTheme.lightGlassmorphicDecoration(borderRadius: 24),
                  child: Column(
                    children: [
                       _SettingsTile(
                        icon: themeMode == ThemeMode.dark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        title: 'Dark Display Mode',
                        isDark: isDark,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                        trailing: Switch(
                          value: themeMode == ThemeMode.dark,
                          onChanged: (val) => ref.read(themeModeProvider.notifier).toggleTheme(val),
                          activeColor: AppTheme.primaryColor,
                        ),
                      ),
                      const Divider(height: 1, indent: 60),
                      _SettingsTile(
                        icon: Icons.notifications_active_rounded,
                        title: 'Push Notifications',
                        isDark: isDark,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                        trailing: Switch(
                          value: true, 
                          onChanged: (v) {},
                          activeColor: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                _SectionHeader(title: 'SECURITY', textColor: secondaryTextColor),
                const SizedBox(height: 12),
                Container(
                  decoration: isDark 
                      ? AppTheme.glassmorphicDecoration(borderRadius: 24) 
                      : AppTheme.lightGlassmorphicDecoration(borderRadius: 24),
                  child: Column(
                    children: [
                       _SettingsTile(
                        icon: Icons.key_rounded,
                        title: 'Change Transaction PIN',
                        onTap: () => context.push('/change-pin'),
                        isDark: isDark,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                      ),
                      const Divider(height: 1, indent: 60),
                      _SettingsTile(
                        icon: Icons.fingerprint_rounded,
                        title: 'Biometric Unlock',
                        isDark: isDark,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                        trailing: Switch(
                          value: _isBiometricEnabled,
                          onChanged: _toggleBiometric,
                          activeColor: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                _SectionHeader(title: 'DATA & PRIVACY', textColor: secondaryTextColor),
                const SizedBox(height: 12),
                Container(
                  decoration: isDark 
                      ? AppTheme.glassmorphicDecoration(borderRadius: 24) 
                      : AppTheme.lightGlassmorphicDecoration(borderRadius: 24),
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.privacy_tip_rounded,
                        title: 'Privacy Policy',
                        onTap: () {},
                        isDark: isDark,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                      ),
                      const Divider(height: 1, indent: 60),
                       _SettingsTile(
                        icon: Icons.gavel_rounded,
                        title: 'Terms of Service',
                        onTap: () {},
                        isDark: isDark,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                _SectionHeader(title: 'MANAGEMENT', textColor: secondaryTextColor),
                const SizedBox(height: 12),
                Container(
                  decoration: isDark 
                      ? AppTheme.glassmorphicDecoration(borderRadius: 24) 
                      : AppTheme.lightGlassmorphicDecoration(borderRadius: 24),
                  child: _SettingsTile(
                    icon: Icons.admin_panel_settings_rounded,
                    title: 'Admin Control Hub',
                    onTap: () => context.push('/admin/dashboard'),
                    trailing: const Icon(Icons.verified_rounded, color: Colors.amber, size: 18),
                    isDark: isDark,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Logout Button
                InkWell(
                  onTap: () {
                     ref.read(authStateProvider.notifier).logout();
                     context.go('/login');
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.errorColor.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout_rounded, color: AppTheme.errorColor, size: 20),
                        const SizedBox(width: 12),
                        const Text(
                          'Sign Out of Session', 
                          style: TextStyle(color: AppTheme.errorColor, fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 0.5)
                        ),
                      ],
                    ),
                  ),
                ),
                 const SizedBox(height: 32),
                 Center(
                   child: Column(
                     children: [
                       Text(
                         'FLUXAPAY PREMIUM',
                         style: TextStyle(
                           color: secondaryTextColor.withValues(alpha: 0.6), 
                           fontSize: 10,
                           fontWeight: FontWeight.w900,
                           letterSpacing: 2,
                          ),
                       ),
                       const SizedBox(height: 4),
                       Text(
                         'Build 1.0.0 (Release Alpha)',
                         style: TextStyle(
                           color: secondaryTextColor.withValues(alpha: 0.4), 
                           fontSize: 10
                          ),
                       ),
                     ],
                   ),
                 ),
                 const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color textColor;
  const _SectionHeader({required this.title, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isDark;
  final Color textColor;
  final Color secondaryTextColor;

  const _SettingsTile({
    required this.icon, 
    required this.title, 
    this.onTap, 
    this.trailing,
    required this.isDark,
    required this.textColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppTheme.primaryColor, size: 20),
      ),
      title: Text(
        title, 
        style: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 14)
      ),
      trailing: trailing ?? Icon(Icons.chevron_right_rounded, color: secondaryTextColor, size: 20),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
    );
  }
}
