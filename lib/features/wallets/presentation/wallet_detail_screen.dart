import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxapay/core/theme/app_theme.dart';
import 'package:fluxapay/features/wallets/presentation/wallet_provider.dart';
import 'package:fluxapay/shared/models/wallet_model.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fluxapay/core/utils/currency_formatter.dart';

class WalletDetailScreen extends ConsumerWidget {
  final String currency;
  const WalletDetailScreen({super.key, required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsAsync = ref.watch(walletsStateProvider);
    final transactionsAsync = ref.watch(transactionsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.lightTextColor;
    final secondaryTextColor = isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          '$currency Wallet',
          style: TextStyle(color: textColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: textColor),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner_rounded, color: textColor),
            onPressed: () {
               context.push('/receive');
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppTheme.backgroundGradient : AppTheme.lightBackgroundGradient,
        ),
        child: walletsAsync.when(
          data: (wallets) {
            final wallet = wallets.firstWhere(
              (w) => w.currency == currency,
              orElse: () => WalletModel(
                id: 0,
                currency: currency,
                balance: 0,
                status: 'inactive',
              ),
            );

            return SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(walletsStateProvider);
                  return ref.invalidate(transactionsProvider);
                },
                color: AppTheme.primaryColor,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // Wallet Balance Hero Card
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Hero(
                          tag: 'wallet_$currency',
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: AppTheme.gradientDecoration(),
                            child: Column(
                              children: [
                                Text(
                                  '$currency Balance',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  CurrencyFormatter.format(wallet.balance, currency: wallet.currency),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 42,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _ActionButton(
                                      icon: Icons.add_rounded,
                                      label: 'Add',
                                      onTap: () => context.push('/fund/$currency'),
                                      isDark: isDark,
                                    ),
                                    _ActionButton(
                                      icon: Icons.swap_horiz_rounded,
                                      label: 'Convert',
                                      onTap: () => context.push('/convert'),
                                      isDark: isDark,
                                    ),
                                    _ActionButton(
                                      icon: Icons.arrow_upward_rounded,
                                      label: 'Send',
                                      onTap: () => context.push('/send'),
                                      isDark: isDark,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Transactions Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Activity History',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Filtered: $currency',
                                style: TextStyle(color: secondaryTextColor, fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Filtered Transactions
                    transactionsAsync.when(
                      data: (transactions) {
                        // Filter transactions for this wallet/currency
                        final filteredTxs = transactions.where((tx) => tx.wallet?['currency'] == currency).toList();
                        
                        if (filteredTxs.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(64.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.receipt_long_rounded, 
                                      size: 64, 
                                      color: isDark ? Colors.white12 : Colors.black12
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No transactions for $currency yet',
                                      style: TextStyle(color: secondaryTextColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        return SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final tx = filteredTxs[index];
                                final isCredit = tx.type == 'credit';
                                final date = DateFormat('MMM d, y • h:mm a').format(tx.createdAt);

                                return GestureDetector(
                                  onTap: () => context.push('/transaction-details', extra: tx),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: isDark 
                                        ? AppTheme.glassmorphicDecoration(borderRadius: 16)
                                        : AppTheme.lightGlassmorphicDecoration(borderRadius: 16),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: (isCredit ? AppTheme.successColor : AppTheme.errorColor)
                                                .withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                                            color: isCredit ? AppTheme.successColor : AppTheme.errorColor,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                tx.description ?? tx.category.replaceAll('_', ' ').toUpperCase(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                date,
                                                style: TextStyle(
                                                  color: secondaryTextColor,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${isCredit ? '+' : '-'}${CurrencyFormatter.format(tx.amount, currency: tx.wallet?['currency'])}',
                                              style: TextStyle(
                                                color: isCredit ? AppTheme.successColor : AppTheme.errorColor,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: (tx.status == 'successful' || tx.status == 'completed' 
                                                    ? AppTheme.successColor 
                                                    : Colors.orange).withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                tx.status.toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.bold,
                                                  color: tx.status == 'successful' || tx.status == 'completed' 
                                                      ? AppTheme.successColor 
                                                      : Colors.orange,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              childCount: filteredTxs.length,
                            ),
                          ),
                        );
                      },
                      loading: () => const SliverToBoxAdapter(
                        child: Center(child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(color: AppTheme.primaryColor),
                        )),
                      ),
                      error: (e, _) => SliverToBoxAdapter(child: Center(child: Text('Error loading transactions', style: TextStyle(color: AppTheme.errorColor)))),
                    ),
                    
                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
          error: (e, _) => Center(child: Text('Error loading wallet details', style: TextStyle(color: AppTheme.errorColor))),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

