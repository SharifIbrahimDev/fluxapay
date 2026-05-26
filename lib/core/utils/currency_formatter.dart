import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String getSymbol(String? currency) {
    switch (currency) {
      case 'NGN':
        return '₦';
      case 'USD':
        return '\$';
      case 'USDT':
        return '₮'; // Or just Keep it as USDT if preferred, but ₮ is the Tether symbol
      default:
        return '';
    }
  }

  static String format(double amount, {String? currency}) {
    final formatter = NumberFormat.decimalPattern();
    formatter.minimumFractionDigits = 2;
    formatter.maximumFractionDigits = 2;
    
    String formatted = formatter.format(amount);
    String symbol = getSymbol(currency);
    
    return '$symbol$formatted';
  }
  
  static String formatShort(double amount) {
     final formatter = NumberFormat.compact();
     return formatter.format(amount);
  }

  static double parse(String value) {
    try {
      return double.parse(value.replaceAll(',', ''));
    } catch (_) {
      return 0.0;
    }
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static final NumberFormat _formatter = NumberFormat.decimalPattern();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Handle decimal points
    if (newValue.text.endsWith('.')) {
      return newValue;
    }

    final doubleValue = double.tryParse(newValue.text.replaceAll(',', ''));
    if (doubleValue == null) {
      return oldValue;
    }

    final formattedValue = _formatter.format(doubleValue);
    
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}
