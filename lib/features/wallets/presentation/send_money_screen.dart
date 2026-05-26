import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxapay/core/theme/app_theme.dart';
import 'package:fluxapay/features/wallets/presentation/wallet_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fluxapay/core/utils/currency_formatter.dart';

class SendMoneyScreen extends ConsumerStatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  ConsumerState<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends ConsumerState<SendMoneyScreen> {
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedCurrency = 'NGN';
  bool _isLoading = false;
  String? _resolvedName;
  bool _isResolving = false;
  final List<String> _currencies = ['NGN', 'USD', 'USDT'];

  @override
  void initState() {
    super.initState();
    _recipientController.addListener(_onRecipientChanged);
  }

  void _onRecipientChanged() {
    final val = _recipientController.text;
    if (val.length == 10 && int.tryParse(val) != null) {
       _resolveUser(val);
    } else {
       if (_resolvedName != null) setState(() => _resolvedName = null);
    }
  }

  Future<void> _resolveUser(String account) async {
    setState(() => _isResolving = true);
    final name = await ref.read(walletRepositoryProvider).resolveUser(account);
    if (mounted) {
      setState(() {
        _resolvedName = name;
        _isResolving = false;
      });
    }
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _sendMoney() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(walletRepositoryProvider).transfer(
            recipient: _recipientController.text.trim(),
            amount: CurrencyFormatter.parse(_amountController.text),
            currency: _selectedCurrency,
            pin: _pinController.text,
          );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Transfer successful'),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.invalidate(walletsStateProvider);
        ref.invalidate(transactionsProvider);
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
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
            'Send Money',
            style: TextStyle(color: textColor),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new, 
              size: 20,
              color: textColor,
            ),
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
                    // Currency Selection Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: isDark 
                          ? AppTheme.glassmorphicDecoration()
                          : AppTheme.lightGlassmorphicDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Wallet',
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.black12 : AppTheme.lightBackgroundColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCurrency,
                                isExpanded: true,
                                dropdownColor: isDark ? AppTheme.cardColor : Colors.white,
                                icon: Icon(
                                  Icons.keyboard_arrow_down, 
                                  color: secondaryTextColor
                                ),
                                style: TextStyle(
                                  color: textColor, 
                                  fontSize: 16, 
                                  fontWeight: FontWeight.w600
                                ),
                                items: _currencies
                                    .map((c) => DropdownMenuItem(value: c, child: Text('$c Wallet')))
                                    .toList(),
                                onChanged: (v) => setState(() => _selectedCurrency = v!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
    
                    // Recipient Input
                    TextFormField(
                      controller: _recipientController,
                      decoration: InputDecoration(
                        labelText: 'Recipient Account or Email',
                        prefixIcon: Icon(
                          Icons.person_outline, 
                          color: isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor
                        ),
                        suffixIcon: _isResolving 
                          ? Padding(
                              padding: const EdgeInsets.all(12), 
                              child: Transform.scale(
                                scale: 0.6,
                                child: const CircularProgressIndicator(strokeWidth: 3)
                              )
                            )
                          : (_resolvedName != null ? const Icon(Icons.check_circle, color: AppTheme.successColor) : null),
                      ),
                      style: TextStyle(color: textColor),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (v.contains('@')) return null;
                        if (v.length == 10 && int.tryParse(v) != null) return null;
                        return 'Invalid email or account number';
                      },
                    ),
                    if (_resolvedName != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.verified, size: 14, color: AppTheme.successColor),
                            const SizedBox(width: 4),
                            Text(
                              _resolvedName!,
                              style: const TextStyle(
                                color: AppTheme.successColor, 
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 20),
                    
                    // Amount Input
                    TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        prefixIcon: Icon(
                          Icons.account_balance_wallet_outlined, 
                          color: isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor
                        ),
                        suffixText: _selectedCurrency,
                        suffixStyle: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      inputFormatters: [ThousandsSeparatorInputFormatter()],
                      validator: (v) => (CurrencyFormatter.parse(v ?? '')) <= 0 ? 'Invalid amount' : null,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // PIN Input
                    TextFormField(
                      controller: _pinController,
                      decoration: InputDecoration(
                        labelText: 'Transaction PIN',
                        prefixIcon: Icon(
                          Icons.lock_outline, 
                          color: isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor
                        ),
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: textColor),
                      maxLength: 4,
                      validator: (v) => v?.length != 4 ? '4-digit PIN required' : null,
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Send Button
                    Container(
                      decoration: AppTheme.gradientDecoration(),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _sendMoney,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'Confirm Payment',
                                style: TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Powered by FluxaPay Secure Engine',
                        style: TextStyle(
                          color: secondaryTextColor.withValues(alpha: 0.5),
                          fontSize: 10,
                          letterSpacing: 1,
                        ),
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
