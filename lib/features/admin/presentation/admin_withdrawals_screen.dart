import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxapay/core/theme/app_theme.dart';
import 'package:fluxapay/features/admin/presentation/admin_provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:fluxapay/core/utils/currency_formatter.dart';

class AdminWithdrawalsScreen extends ConsumerWidget {
  const AdminWithdrawalsScreen({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(adminTransactionsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.lightTextColor;
    final secondaryTextColor = isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Manage Withdrawals',
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
          child: transactionsAsync.when(
            data: (transactionsList) {
              final transactions = transactionsList as List<dynamic>;
              final pending = transactions.where((t) => t.category == 'withdrawal' && t.status == 'pending').toList();

              if (pending.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded, 
                        size: 64, 
                        color: isDark ? Colors.white12 : Colors.black12
                      ),
                      const SizedBox(height: 16),
                      Text('No pending withdrawals', style: TextStyle(color: secondaryTextColor)),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: pending.length,
                itemBuilder: (context, index) {
                  final tx = pending[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: isDark 
                        ? AppTheme.glassmorphicDecoration(borderRadius: 24)
                        : AppTheme.lightGlassmorphicDecoration(borderRadius: 24),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          title: Text(
                            'REF: ${tx.reference}', 
                            style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1)
                          ),
                          subtitle: Text(
                            DateFormat('MMM d, y • h:mm a').format(tx.createdAt),
                            style: TextStyle(color: secondaryTextColor, fontSize: 11),
                          ),
                          trailing: Text(
                            CurrencyFormatter.format(double.tryParse(tx.amount.toString()) ?? 0.0, currency: tx.wallet?['currency']),
                            style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w900),
                          ),
                        ),
                        const Divider(height: 1, indent: 20, endIndent: 20),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _DetailRow(label: 'BANK', value: tx.metadata?['bank_name'] ?? 'N/A', secondaryTextColor: secondaryTextColor, textColor: textColor),
                              const SizedBox(height: 12),
                              _DetailRow(label: 'ACCOUNT', value: tx.metadata?['account_number'] ?? 'N/A', secondaryTextColor: secondaryTextColor, textColor: textColor),
                              const SizedBox(height: 24),
                              
                              Container(
                                decoration: AppTheme.gradientDecoration(),
                                child: ElevatedButton(
                                  onPressed: () {
                                    ref.read(adminTransactionsProvider.notifier).approveWithdrawal(tx.reference);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Withdrawal approved successfully'), 
                                        backgroundColor: AppTheme.successColor,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text(
                                    'APPROVE PAYOUT', 
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
            error: (e, s) => Center(child: Text('Error: $e', style: const TextStyle(color: AppTheme.errorColor))),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color secondaryTextColor;
  final Color textColor;
  
  const _DetailRow({required this.label, required this.value, required this.secondaryTextColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label, 
          style: TextStyle(color: secondaryTextColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)
        ),
        Text(
          value, 
          style: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 13)
        ),
      ],
    );
  }
}
