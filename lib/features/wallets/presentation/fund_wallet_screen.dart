import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxapay/core/theme/app_theme.dart';
import 'package:fluxapay/features/wallets/presentation/wallet_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fluxapay/core/utils/currency_formatter.dart';

class FundWalletScreen extends ConsumerStatefulWidget {
  final String currency;
  const FundWalletScreen({super.key, required this.currency});

  @override
  ConsumerState<FundWalletScreen> createState() => _FundWalletScreenState();
}

class _FundWalletScreenState extends ConsumerState<FundWalletScreen> {
  final _amountController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final amount = CurrencyFormatter.parse(_amountController.text);
      await ref.read(walletRepositoryProvider).fund(
            currency: widget.currency,
            amount: amount,
          );

      if (mounted) {
        ref.invalidate(walletsStateProvider);
        ref.invalidate(transactionsProvider);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Wallet funded successfully!'),
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

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            'Fund ${widget.currency} Wallet',
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                     Container(
                      padding: const EdgeInsets.all(32),
                      decoration: isDark 
                          ? AppTheme.glassmorphicDecoration()
                          : AppTheme.lightGlassmorphicDecoration(),
                      child: Column(
                        children: [
                          Text(
                            'Enter Amount', 
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textColor, 
                              fontSize: 32, 
                              fontWeight: FontWeight.w900,
                            ),
                            decoration: InputDecoration(
                              prefixText: '${CurrencyFormatter.getSymbol(widget.currency)} ',
                              prefixStyle: const TextStyle(color: AppTheme.primaryColor),
                              hintText: '0.00',
                              hintStyle: TextStyle(color: textColor.withValues(alpha: 0.2)),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              fillColor: Colors.transparent,
                            ),
                            inputFormatters: [ThousandsSeparatorInputFormatter()],
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Required';
                              final n = CurrencyFormatter.parse(value);
                              if (n <= 0) return 'Invalid amount';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
    
                    const SizedBox(height: 32),
                    Text(
                      'PAYMENT DETAILS', 
                      style: TextStyle(
                        color: isDark ? Colors.white38 : Colors.black26, 
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
    
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: isDark 
                          ? AppTheme.glassmorphicDecoration()
                          : AppTheme.lightGlassmorphicDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           TextFormField(
                            controller: _cardNumberController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: textColor),
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)],
                            decoration: InputDecoration(
                              labelText: 'Card Number',
                              prefixIcon: Icon(
                                Icons.credit_card_rounded, 
                                color: secondaryTextColor
                              ),
                            ),
                            validator: (value) => (value == null || value.length < 16) ? 'Enter 16 digits' : null,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _expiryController,
                                  keyboardType: TextInputType.datetime,
                                  style: TextStyle(color: textColor),
                                  inputFormatters: [LengthLimitingTextInputFormatter(5)],
                                  decoration: InputDecoration(
                                    labelText: 'MM/YY',
                                    prefixIcon: Icon(
                                      Icons.calendar_month_rounded, 
                                      color: secondaryTextColor
                                    ),
                                  ),
                                  validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _cvvController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(color: textColor),
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                                  decoration: InputDecoration(
                                    labelText: 'CVV',
                                    prefixIcon: Icon(
                                      Icons.security_rounded, 
                                      color: secondaryTextColor
                                    ),
                                  ),
                                  validator: (value) => (value == null || value.length < 3) ? 'Enter 3 digits' : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
    
                    const SizedBox(height: 48),
    
                    Container(
                      decoration: AppTheme.gradientDecoration(),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _isLoading 
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text(
                              'Confirm Funding', 
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)
                            ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline, size: 12, color: secondaryTextColor),
                        const SizedBox(width: 4),
                        Text(
                          'Secure Encryption Applied',
                          style: TextStyle(color: secondaryTextColor, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
