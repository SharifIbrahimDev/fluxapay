import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxapay/core/theme/app_theme.dart';
import 'package:fluxapay/features/auth/presentation/auth_provider.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.lightTextColor;
    final secondaryTextColor = isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Personal Profile',
          style: TextStyle(color: textColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: textColor),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: isDark 
                  ? AppTheme.glassmorphicDecoration(borderRadius: 14)
                  : AppTheme.lightGlassmorphicDecoration(borderRadius: 14),
              child: Icon(Icons.settings_rounded, color: secondaryTextColor, size: 20),
            ),
          ),
          const SizedBox(width: 16),
        ],
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
              children: [
                const SizedBox(height: 20),
                 // User Avatar
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.3), 
                        blurRadius: 30, 
                        offset: const Offset(0, 15)
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 54,
                    backgroundColor: isDark ? Colors.black : Colors.white,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.grey[100],
                      child: Text(
                        user?.name.substring(0, 1).toUpperCase() ?? 'U',
                        style: TextStyle(
                          fontSize: 44, 
                          fontWeight: FontWeight.w900, 
                          color: AppTheme.primaryColor,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  user?.name ?? 'Secure User',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? 'authenticating...',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: secondaryTextColor,
                  ),
                ),
                if (user?.accountNumber != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.account_balance_rounded, color: Colors.white, size: 14),
                        const SizedBox(width: 8),
                        Text(
                          'ID: ${user!.accountNumber}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 48),

                // Personal Details
                Container(
                  decoration: isDark 
                      ? AppTheme.glassmorphicDecoration(borderRadius: 24) 
                      : AppTheme.lightGlassmorphicDecoration(borderRadius: 24),
                  child: Column(
                    children: [
                       _ProfileItem(
                         icon: Icons.phone_rounded,
                         title: 'Phone Number',
                         value: user?.phone ?? 'Not set',
                         isDark: isDark,
                         textColor: textColor,
                         secondaryTextColor: secondaryTextColor,
                       ),
                       const Divider(height: 1, indent: 60),
                       _ProfileItem(
                         icon: Icons.verified_user_rounded,
                         title: 'Account Status',
                         value: user?.status.toUpperCase() ?? 'ACTIVE',
                         valueColor: AppTheme.successColor,
                         isDark: isDark,
                         textColor: textColor,
                         secondaryTextColor: secondaryTextColor,
                       ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Security Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shield_rounded, color: secondaryTextColor, size: 14),
                    const SizedBox(width: 8),
                    Text(
                      'Biometric Security Protocol v2.4 Active',
                      style: TextStyle(color: secondaryTextColor, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;
  final bool isDark;
  final Color textColor;
  final Color secondaryTextColor;

  const _ProfileItem({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
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
        style: TextStyle(color: secondaryTextColor, fontSize: 13, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        value, 
        style: TextStyle(color: valueColor ?? textColor, fontWeight: FontWeight.w900, fontSize: 15),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }
}
