import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxapay/core/theme/app_theme.dart';
import 'package:fluxapay/features/auth/presentation/auth_provider.dart';
import 'package:fluxapay/features/wallets/presentation/wallet_provider.dart';
import 'package:fluxapay/shared/models/wallet_model.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fluxapay/core/utils/currency_formatter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.9);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final walletsAsync = ref.watch(walletsStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.lightTextColor;
    final secondaryTextColor = isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppTheme.backgroundGradient : AppTheme.lightBackgroundGradient,
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => ref.read(walletsStateProvider.notifier).refresh(),
            color: AppTheme.primaryColor,
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              slivers: [
                // App Bar / Greeting
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Premium Portal',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.name ?? 'User',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () => context.push('/profile'),
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppTheme.primaryGradient,
                            ),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: isDark ? Colors.black : Colors.white,
                              child: Text(
                                user?.name.substring(0, 1).toUpperCase() ?? 'U',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.primaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Wallets Carousel
                SliverToBoxAdapter(
                  child: walletsAsync.when(
                    data: (wallets) {
                      if (wallets.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Container(
                            height: 180,
                            width: double.infinity,
                            decoration: isDark ? AppTheme.glassmorphicDecoration() : AppTheme.lightGlassmorphicDecoration(),
                            child: Center(child: Text('Initialize your first wallet', style: TextStyle(color: secondaryTextColor))),
                          ),
                        );
                      }
                      return Column(
                        children: [
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 200,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: wallets.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                                  child: WalletCard(wallet: wallets[index]),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          SmoothPageIndicator(
                            controller: _pageController,
                            count: wallets.length,
                            effect: ExpandingDotsEffect(
                              dotHeight: 6,
                              dotWidth: 6,
                              activeDotColor: AppTheme.primaryColor,
                              dotColor: isDark ? Colors.white24 : Colors.black12,
                              expansionFactor: 3,
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 80.0),
                      child: Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
                    ),
                    error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: AppTheme.errorColor))),
                  ),
                ),

                // Quick Actions
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _QuickActionButton(
                          icon: Icons.send_rounded,
                          label: 'Send',
                          onTap: () => context.push('/send'),
                          isDark: isDark,
                        ),
                        _QuickActionButton(
                          icon: Icons.vertical_align_bottom_rounded,
                          label: 'Receive',
                          onTap: () => context.push('/receive'),
                          isDark: isDark,
                        ),
                        _QuickActionButton(
                          icon: Icons.currency_exchange_rounded,
                          label: 'Convert',
                          onTap: () => context.push('/convert'),
                          isDark: isDark,
                        ),
                         _QuickActionButton(
                          icon: Icons.insights_rounded,
                          label: 'Insights',
                          onTap: () => context.push('/insights'),
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ),

                // Recent Activity Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'RECENT ACTIVITY',
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push('/activity'),
                          child: const Text(
                            'VIEW ALL', 
                            style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.5)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const TransactionsList(),
                
                const SliverToBoxAdapter(child: SizedBox(height: 60)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: isDark ? null : AppTheme.primaryGradient,
              color: isDark ? Colors.white.withValues(alpha: 0.08) : null,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : AppTheme.primaryColor).withValues(alpha: 0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.white70 : AppTheme.lightTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class WalletCard extends StatelessWidget {
  final WalletModel wallet;
  const WalletCard({super.key, required this.wallet});

   Color _getCurrencyColor(String currency) {
    switch (currency) {
      case 'NGN': return const Color(0xFF10B981);
      case 'USD': return const Color(0xFF3B82F6);
      case 'USDT': return const Color(0xFF00A3A3);
      default: return AppTheme.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyColor = _getCurrencyColor(wallet.currency);

    return GestureDetector(
      onTap: () => context.push('/wallet/${wallet.currency}'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              currencyColor,
              currencyColor.withValues(alpha: 0.7),
            ],
             begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
             BoxShadow(
              color: currencyColor.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    wallet.currency,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5),
                  ),
                ),
                Icon(
                 wallet.currency == 'USDT' ? Icons.currency_bitcoin_rounded : Icons.payments_rounded, 
                 color: Colors.white.withValues(alpha: 0.4), 
                 size: 28
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CURRENT BALANCE',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
                ),
                const SizedBox(height: 6),
                Text(
                  CurrencyFormatter.format(wallet.balance, currency: wallet.currency),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionsList extends ConsumerWidget {
  const TransactionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(transactionsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.lightTextColor;
    final secondaryTextColor = isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor;

    return txAsync.when(
      data: (transactions) {
        if (transactions.isEmpty) {
           return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Text(
                  'No recent activity to display',
                  style: TextStyle(color: secondaryTextColor),
                ),
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final tx = transactions[index];
                final isCredit = tx.type == 'credit';
                final date = DateFormat('MMM dd, HH:mm').format(tx.createdAt);

                return GestureDetector(
                  onTap: () => context.push('/transaction-details', extra: tx),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: isDark 
                        ? AppTheme.glassmorphicDecoration(borderRadius: 20)
                        : AppTheme.lightGlassmorphicDecoration(borderRadius: 20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (isCredit ? AppTheme.successColor : AppTheme.errorColor).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                           child: Icon(
                            isCredit ? Icons.add_rounded : Icons.remove_rounded,
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
                                tx.description ?? tx.category,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                               const SizedBox(height: 4),
                              Text(
                                date.toUpperCase(),
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                           '${isCredit ? '+' : '-'}${CurrencyFormatter.format(tx.amount, currency: tx.wallet?['currency'])}',
                          style: TextStyle(
                            color: isCredit ? AppTheme.successColor : AppTheme.errorColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: transactions.length > 5 ? 5 : transactions.length,
            ),
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(child: SizedBox()),
      error: (e, _) => const SliverToBoxAdapter(child: SizedBox()),
    );
  }
}
