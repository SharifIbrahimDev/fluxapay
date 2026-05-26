import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxapay/core/theme/app_theme.dart';
import 'package:fluxapay/features/admin/presentation/admin_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fluxapay/core/utils/currency_formatter.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(adminUsersProvider);
    final transactionsAsync = ref.watch(adminTransactionsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.lightTextColor;
    final secondaryTextColor = isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Admin Control',
          style: TextStyle(color: textColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: textColor),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: textColor),
            onPressed: () {
              ref.invalidate(adminUsersProvider);
              ref.invalidate(adminTransactionsProvider);
            },
          ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                  title: 'Withdrawal Requests',
                  textColor: textColor,
                  action: TextButton(
                    onPressed: () => context.push('/admin/withdrawals'),
                    child: const Text(
                      'Manage All', 
                      style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _PendingWithdrawalsList(asyncValue: transactionsAsync, isDark: isDark),
                
                const SizedBox(height: 32),
                
                _SectionHeader(
                  title: 'Platform Users (${usersAsync.valueOrNull?.length ?? 0})',
                  textColor: textColor,
                ),
                const SizedBox(height: 16),
                _UsersList(asyncValue: usersAsync, isDark: isDark),
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
  final Widget? action;
  final Color textColor;
  
  const _SectionHeader({required this.title, this.action, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title, 
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

class _PendingWithdrawalsList extends StatelessWidget {
  final AsyncValue asyncValue;
  final bool isDark;
  
  const _PendingWithdrawalsList({required this.asyncValue, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.lightTextColor;
    final secondaryTextColor = isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor;

    return asyncValue.when(
      data: (transactions) {
        final List<dynamic> pending = (transactions as List<dynamic>).where((t) => t.category == 'withdrawal' && t.status == 'pending').toList();
        
        if (pending.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text('No pending withdrawals', style: TextStyle(color: secondaryTextColor)),
            ),
          );
        }
        
        return Column(
          children: pending.take(3).map<Widget>((tx) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: isDark ? AppTheme.glassmorphicDecoration(borderRadius: 16) : AppTheme.lightGlassmorphicDecoration(borderRadius: 16),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.outbound_rounded, color: AppTheme.primaryColor, size: 20),
              ),
              title: Text(
                'Ref: ${tx.reference}', 
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14)
              ),
              subtitle: Text(
                CurrencyFormatter.format(double.tryParse(tx.amount.toString()) ?? 0.0, currency: tx.wallet?['currency']),
                style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w900),
              ),
              trailing: Icon(Icons.chevron_right_rounded, color: secondaryTextColor),
              onTap: () => context.push('/admin/withdrawals'),
            ),
          )).toList(),
        );
      },
      loading: () => const Center(child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(color: AppTheme.primaryColor, strokeWidth: 2),
      )),
      error: (e, s) => Text('Error: $e', style: const TextStyle(color: AppTheme.errorColor)),
    );
  }
}

class _UsersList extends StatelessWidget {
  final AsyncValue asyncValue;
  final bool isDark;
  
  const _UsersList({required this.asyncValue, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.lightTextColor;
    final secondaryTextColor = isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor;

    return asyncValue.when(
      data: (users) {
        if ((users as List<dynamic>).isEmpty) return Text('No users found', style: TextStyle(color: secondaryTextColor));
        return Column(
          children: (users as List<dynamic>).take(5).map<Widget>((user) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: isDark ? AppTheme.glassmorphicDecoration(borderRadius: 16) : AppTheme.lightGlassmorphicDecoration(borderRadius: 16),
            child: ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.primaryGradient,
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Text(user.name[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              title: Text(user.name, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              subtitle: Text(user.email, style: TextStyle(color: secondaryTextColor, fontSize: 12)),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (user.status == 'active' ? AppTheme.successColor : AppTheme.errorColor).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  user.status.toUpperCase(),
                  style: TextStyle(
                    color: user.status == 'active' ? AppTheme.successColor : AppTheme.errorColor,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          )).toList(),
        );
      },
      loading: () => const Center(child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(color: AppTheme.primaryColor, strokeWidth: 2),
      )),
      error: (e, s) => Text('Error loading users', style: const TextStyle(color: AppTheme.errorColor)),
    );
  }
}
