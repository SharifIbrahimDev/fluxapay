import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxapay/core/theme/app_theme.dart';
import 'package:fluxapay/features/wallets/presentation/wallet_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fluxapay/core/utils/currency_formatter.dart';

class ConversionScreen extends ConsumerStatefulWidget {
  const ConversionScreen({super.key});

  @override
  ConsumerState<ConversionScreen> createState() => _ConversionScreenState();
}

class _ConversionScreenState extends ConsumerState<ConversionScreen> {
  String _fromCurrency = 'NGN';
  String _toCurrency = 'USD';
  final _amountController = TextEditingController();
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  List<dynamic> _rates = [];
  double? _previewAmount;
  bool _isFetchingRates = false;

  final List<String> _currencies = ['NGN', 'USD', 'USDT'];

  @override
  void dispose() {
    _amountController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_calculatePreview);
    _fetchRates();
  }

  Future<void> _fetchRates() async {
    setState(() => _isFetchingRates = true);
    try {
      final rates = await ref.read(walletRepositoryProvider).getRates();
      setState(() {
        _rates = rates;
        _isFetchingRates = false;
      });
      _calculatePreview();
    } catch (e) {
      if (mounted) setState(() => _isFetchingRates = false);
    }
  }

  void _calculatePreview() {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      setState(() => _previewAmount = null);
      return;
    }

    final amount = CurrencyFormatter.parse(amountText);
    if (amount <= 0) {
      setState(() => _previewAmount = null);
      return;
    }

    if (_fromCurrency == _toCurrency) {
      setState(() => _previewAmount = amount);
      return;
    }

    final rateData = _rates.firstWhere(
      (r) => r['from_currency'] == _fromCurrency && r['to_currency'] == _toCurrency,
      orElse: () => null,
    );

    if (rateData != null) {
      final rate = double.parse(rateData['rate'].toString());
      final feePercentage = double.parse(rateData['fee_percentage'].toString());
      final fee = (feePercentage / 100) * amount;
      final netAmount = amount - fee;
      setState(() => _previewAmount = netAmount * rate);
    } else {
      setState(() => _previewAmount = null);
    }
  }

  Future<void> _convert() async {
    if (!_formKey.currentState!.validate()) return;

    if (_fromCurrency == _toCurrency) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Cannot convert to the same currency'),
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(walletRepositoryProvider).convert(
            fromCurrency: _fromCurrency,
            toCurrency: _toCurrency,
            amount: CurrencyFormatter.parse(_amountController.text),
            pin: _pinController.text,
          );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Conversion successful'),
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

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
    _calculatePreview();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Convert Money',
          style: TextStyle(color: isDark ? Colors.white : AppTheme.lightTextColor),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new, 
            size: 20,
            color: isDark ? Colors.white : AppTheme.lightTextColor,
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
                   // Conversion Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: isDark 
                        ? AppTheme.glassmorphicDecoration() 
                        : AppTheme.lightGlassmorphicDecoration(),
                    child: Column(
                      children: [
                        // From Currency
                        _buildCurrencySelector(
                          label: 'From',
                          value: _fromCurrency,
                          isDark: isDark,
                          onChanged: (v) {
                            setState(() => _fromCurrency = v!);
                            _calculatePreview();
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Swap Button
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Divider(
                              color: isDark ? Colors.white24 : AppTheme.lightSecondaryTextColor.withValues(alpha: 0.2)
                            ),
                            GestureDetector(
                              onTap: _swapCurrencies,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryColor.withValues(alpha: 0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.swap_vert, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // To Currency
                        _buildCurrencySelector(
                          label: 'To',
                          value: _toCurrency,
                          isDark: isDark,
                          onChanged: (v) {
                            setState(() => _toCurrency = v!);
                            _calculatePreview();
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Amount Input
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'Amount to Convert',
                      prefixIcon: Icon(
                        Icons.numbers, 
                        color: isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor
                      ),
                      suffixText: _fromCurrency,
                      // fillColor removal handled by theme
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.lightTextColor,
                    ),
                    inputFormatters: [ThousandsSeparatorInputFormatter()],
                    validator: (v) => (CurrencyFormatter.parse(v ?? '')) <= 0 ? 'Invalid amount' : null,
                  ),

                  if (_previewAmount != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.successColor.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'You will receive:',
                              style: TextStyle(
                                color: isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor
                              ),
                            ),
                            Text(
                              CurrencyFormatter.format(_previewAmount!, currency: _toCurrency),
                              style: const TextStyle(
                                color: AppTheme.successColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                      // fillColor handled by theme
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: isDark ? Colors.white : AppTheme.lightTextColor,
                    ),
                    maxLength: 4,
                    validator: (v) => v?.length != 4 ? '4-digit PIN required' : null,
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Convert Button
                  Container(
                    decoration: AppTheme.gradientDecoration(),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _convert,
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
                              'Confirm Conversion',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencySelector({
    required String label,
    required String value,
    required ValueChanged<String?> onChanged,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white60 : AppTheme.lightSecondaryTextColor, 
            fontSize: 14
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? Colors.black12 : AppTheme.lightBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.black12
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: isDark ? AppTheme.cardColor : Colors.white,
              icon: Icon(
                Icons.keyboard_arrow_down, 
                color: isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor
              ),
              style: TextStyle(
                color: isDark ? Colors.white : AppTheme.lightTextColor, 
                fontSize: 16, 
                fontWeight: FontWeight.w600
              ),
              items: _currencies
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
