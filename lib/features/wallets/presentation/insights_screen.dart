import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxapay/core/theme/app_theme.dart';
import 'package:fluxapay/features/wallets/presentation/wallet_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fluxapay/core/utils/currency_formatter.dart';

class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  String _selectedCurrency = 'NGN';

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.lightTextColor;
    final secondaryTextColor = isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Financial Analytics',
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
          child: Column(
            children: [
              // Currency Selector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ['NGN', 'USD', 'USDT'].map((currency) {
                      final isSelected = _selectedCurrency == currency;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: Text(currency),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedCurrency = currency);
                          },
                          selectedColor: AppTheme.primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : secondaryTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          showCheckmark: false,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Expanded(
                child: transactionsAsync.when(
                  data: (transactions) {
                    // Filter by debit and currency
                    final filteredTransactions = transactions.where((t) {
                      final walletCurrency = t.wallet?['currency'] as String?;
                      return t.type == 'debit' && walletCurrency == _selectedCurrency;
                    }).toList();
                    
                    if (filteredTransactions.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.analytics_outlined, 
                              size: 64, 
                              color: isDark ? Colors.white12 : Colors.black12
                            ),
                            const SizedBox(height: 16),
                            Text('No analytics for $_selectedCurrency', style: TextStyle(color: secondaryTextColor)),
                          ],
                        ),
                      );
                    }

                    final totals = <String, double>{};
                    double totalSpent = 0;
                    for (var t in filteredTransactions) {
                      totals[t.category] = (totals[t.category] ?? 0) + t.amount;
                      totalSpent += t.amount;
                    }

                    final sections = totals.entries.map((e) {
                      final percentage = totalSpent > 0 ? (e.value / totalSpent) * 100 : 0.0;
                      return PieChartSectionData(
                        color: _getColorForCategory(e.key),
                        value: e.value,
                        title: '${percentage.toStringAsFixed(0)}%',
                        radius: 60,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      );
                    }).toList();

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 320,
                            padding: const EdgeInsets.all(32),
                            decoration: isDark 
                                ? AppTheme.glassmorphicDecoration(borderRadius: 32)
                                : AppTheme.lightGlassmorphicDecoration(borderRadius: 32),
                            child: PieChart(
                              PieChartData(
                                sections: sections,
                                centerSpaceRadius: 50,
                                sectionsSpace: 4,
                                startDegreeOffset: 180,
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                          Text(
                            '$_selectedCurrency SPENDING BREAKDOWN',
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ...totals.entries.map((e) => Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: isDark 
                                ? AppTheme.glassmorphicDecoration(borderRadius: 16)
                                : AppTheme.lightGlassmorphicDecoration(borderRadius: 16),
                            child: ListTile(
                              leading: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _getColorForCategory(e.key),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getColorForCategory(e.key).withValues(alpha: 0.4),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                              title: Text(
                                e.key.replaceAll('_', ' ').toUpperCase(),
                                style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
                              ),
                              trailing: Text(
                                CurrencyFormatter.format(e.value, currency: _selectedCurrency),
                                style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 15),
                              ),
                            ),
                          )),
                        ],
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
                  error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: AppTheme.errorColor))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'transfer': return const Color(0xFF6366F1);
      case 'withdrawal': return const Color(0xFFEF4444);
      case 'conversion': return const Color(0xFFF59E0B);
      case 'funding': return const Color(0xFF10B981);
      default: return const Color(0xFF8B5CF6);
    }
  }
}
