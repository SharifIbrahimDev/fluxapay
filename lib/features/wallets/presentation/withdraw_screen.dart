import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxapay/core/theme/app_theme.dart';
import 'package:fluxapay/features/wallets/presentation/wallet_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fluxapay/core/utils/currency_formatter.dart';

class WithdrawScreen extends ConsumerStatefulWidget {
  final String currency;
  const WithdrawScreen({super.key, required this.currency});

  @override
  ConsumerState<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends ConsumerState<WithdrawScreen> {
  final _amountController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _resolvedAccountName;
  bool _isResolving = false;

  @override
  void initState() {
    super.initState();
    _accountNumberController.addListener(_onAccountChanged);
  }

  void _onAccountChanged() {
    final val = _accountNumberController.text;
    if (val.length == 10) {
      _resolveAccount(val);
    } else {
      if (_resolvedAccountName != null) {
        setState(() {
          _resolvedAccountName = null;
          _bankNameController.clear();
        });
      }
    }
  }

  Future<void> _resolveAccount(String account) async {
    setState(() => _isResolving = true);
    final data = await ref.read(walletRepositoryProvider).resolveExternalAccount(account);
    if (mounted) {
      if (data != null) {
        setState(() {
          _resolvedAccountName = data['account_name'];
          _bankNameController.text = data['bank_name'];
        });
      }
      setState(() => _isResolving = false);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final amount = CurrencyFormatter.parse(_amountController.text);
      await ref.read(walletRepositoryProvider).withdraw(
            currency: widget.currency,
            amount: amount,
            bankName: _bankNameController.text,
            accountNumber: _accountNumberController.text,
            pin: _pinController.text,
          );

      if (mounted) {
        ref.invalidate(walletsStateProvider);
        ref.invalidate(transactionsProvider);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Withdrawal request submitted!'),
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
            'Withdraw ${widget.currency}',
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
                      'DESTINATION ACCOUNT', 
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
                        children: [
                           TextFormField(
                            controller: _accountNumberController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: textColor),
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                            decoration: InputDecoration(
                              labelText: 'Account Number',
                              prefixIcon: Icon(Icons.numbers_rounded, color: secondaryTextColor),
                              suffixIcon: _isResolving 
                                ? Padding(
                                    padding: const EdgeInsets.all(12), 
                                    child: Transform.scale(
                                      scale: 0.6,
                                      child: const CircularProgressIndicator(strokeWidth: 3)
                                    )
                                  )
                                : (_resolvedAccountName != null ? const Icon(Icons.check_circle, color: AppTheme.successColor) : null),
                            ),
                            validator: (value) => (value == null || value.length != 10) ? 'Enter 10-digit number' : null,
                          ),
                          
                          if (_resolvedAccountName != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppTheme.successColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.verified_user_rounded, color: AppTheme.successColor, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _resolvedAccountName!,
                                        style: const TextStyle(
                                          color: AppTheme.successColor, 
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
    
                          const SizedBox(height: 16),
                          
                          TextFormField(
                            controller: _bankNameController,
                            style: TextStyle(color: textColor),
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Bank Name',
                              prefixIcon: Icon(Icons.account_balance_rounded, color: secondaryTextColor),
                              fillColor: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.03),
                            ),
                            validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
    
                    const SizedBox(height: 24),
    
                     Container(
                      padding: const EdgeInsets.all(24),
                      decoration: isDark 
                          ? AppTheme.glassmorphicDecoration()
                          : AppTheme.lightGlassmorphicDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           TextFormField(
                            controller: _pinController,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            style: TextStyle(
                              color: textColor, 
                              letterSpacing: 4, 
                              fontWeight: FontWeight.bold,
                            ),
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                            decoration: InputDecoration(
                              labelText: 'Transaction PIN',
                              prefixIcon: Icon(Icons.lock_rounded, color: secondaryTextColor),
                            ),
                            validator: (value) => (value == null || value.length != 4) ? 'Enter 4-digit PIN' : null,
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
                              'Request Payout', 
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)
                            ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Fast withdrawals usually processed in < 30 mins',
                        style: TextStyle(color: secondaryTextColor, fontSize: 11),
                      ),
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
