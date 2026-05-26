import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxapay/core/theme/app_theme.dart';
import 'package:fluxapay/features/wallets/presentation/wallet_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fluxapay/core/utils/currency_formatter.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.lightTextColor;
    final secondaryTextColor = isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Account Activity',
          style: TextStyle(color: textColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: textColor),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.insights_rounded, color: textColor),
             tooltip: 'Insights',
            onPressed: () => context.push('/insights'),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? AppTheme.backgroundGradient : AppTheme.lightBackgroundGradient,
        ),
        child: SafeArea(
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  indicatorColor: AppTheme.primaryColor,
                  indicatorWeight: 3,
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: secondaryTextColor,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                  tabs: const [
                    Tab(text: 'ALL'),
                    Tab(text: 'INCOMING'),
                    Tab(text: 'OUTGOING'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _TransactionList(filter: 'all', asyncValue: transactionsAsync, isDark: isDark),
                      _TransactionList(filter: 'credit', asyncValue: transactionsAsync, isDark: isDark),
                      _TransactionList(filter: 'debit', asyncValue: transactionsAsync, isDark: isDark),
                    ],
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

class _TransactionList extends StatelessWidget {
  final String filter;
  final AsyncValue asyncValue;
  final bool isDark;

  const _TransactionList({required this.filter, required this.asyncValue, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.lightTextColor;
    final secondaryTextColor = isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor;

    return asyncValue.when(
      data: (transactions) {
        final List<dynamic> filteredList = filter == 'all'
            ? transactions as List<dynamic>
            : (transactions as List<dynamic>).where((t) => t.type == filter).toList();

        if (filteredList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_rounded, 
                  size: 64, 
                  color: isDark ? Colors.white12 : Colors.black12
                ),
                const SizedBox(height: 16),
                Text(
                  'No transactions found', 
                  style: TextStyle(color: secondaryTextColor)
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            final tx = filteredList[index];
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
                        isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
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
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
      error: (e, _) => Center(child: Text('Error: $e', style: TextStyle(color: AppTheme.errorColor))),
    );
  }
}
