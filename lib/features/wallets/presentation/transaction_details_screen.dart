import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluxapay/core/theme/app_theme.dart';
import 'package:fluxapay/shared/models/transaction_model.dart';
import 'package:fluxapay/core/utils/currency_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final TransactionModel transaction;

  const TransactionDetailsScreen({super.key, required this.transaction});

  @override
  State<TransactionDetailsScreen> createState() => _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> _shareReceipt() async {
    try {
      final image = await _screenshotController.capture();
      if (image == null) return;

      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/receipt_${widget.transaction.reference}.png').create();
      await imagePath.writeAsBytes(image);

      await Share.shareXFiles(
        [XFile(imagePath.path)],
        text: 'Transaction Receipt: ${widget.transaction.reference}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing receipt: $e'), backgroundColor: AppTheme.errorColor),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCredit = widget.transaction.type == 'credit';
    final currency = widget.transaction.wallet?['currency'] ?? 'USD';
    final textColor = isDark ? Colors.white : AppTheme.lightTextColor;
    final secondaryTextColor = isDark ? Colors.white70 : AppTheme.lightSecondaryTextColor;

    Color statusColor;
    switch (widget.transaction.status.toLowerCase()) {
      case 'successful':
      case 'completed':
        statusColor = AppTheme.successColor;
        break;
      case 'pending':
      case 'processing':
        statusColor = Colors.orange;
        break;
      case 'failed':
      case 'rejected':
        statusColor = AppTheme.errorColor;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Transaction Details', style: TextStyle(color: textColor)),
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
            child: Column(
              children: [
                Screenshot(
                  controller: _screenshotController,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: isDark ? AppTheme.backgroundGradient : AppTheme.lightBackgroundGradient,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        // Header (Icon + Amount)
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: isDark ? null : [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                            size: 48,
                            color: isCredit ? AppTheme.successColor : AppTheme.errorColor,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        Text(
                          '${isCredit ? '+' : '-'}${CurrencyFormatter.format(widget.transaction.amount, currency: currency)}',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: isCredit ? AppTheme.successColor : AppTheme.errorColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            widget.transaction.status.toUpperCase(),
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                         Text(
                           DateFormat('MMMM d, yyyy • h:mm a').format(widget.transaction.createdAt),
                           style: TextStyle(color: secondaryTextColor, fontSize: 14),
                         ),

                        const SizedBox(height: 48),

                        // Details Card
                        Container(
                          decoration: isDark ? AppTheme.glassmorphicDecoration() : AppTheme.lightGlassmorphicDecoration(),
                          child: Column(
                            children: [
                              _DetailRow(
                                label: 'Type', 
                                value: widget.transaction.type.toUpperCase(),
                                isDark: isDark,
                              ),
                              _DetailRow(
                                label: 'Category', 
                                value: widget.transaction.category.replaceAll('_', ' ').toUpperCase(),
                                isDark: isDark,
                              ),
                              if (widget.transaction.description != null && widget.transaction.description!.isNotEmpty)
                                _DetailRow(
                                  label: 'Description', 
                                  value: widget.transaction.description!,
                                  isDark: isDark,
                                ),
                              _DetailRow(
                                label: 'Reference', 
                                value: widget.transaction.reference,
                                isDark: isDark,
                                canCopy: true,
                              ),
                              if (widget.transaction.wallet != null)
                                _DetailRow(
                                  label: 'Wallet', 
                                  value: '${widget.transaction.wallet!['currency'] ?? ''} Wallet',
                                  isDark: isDark,
                                ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        // Branding in receipt
                        Text(
                          'Generated by FluxaPay',
                          style: TextStyle(
                            color: secondaryTextColor.withValues(alpha: 0.5),
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                
                // Action Buttons
                Container(
                  decoration: AppTheme.gradientDecoration(),
                  child: ElevatedButton.icon(
                    onPressed: _shareReceipt,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    icon: const Icon(Icons.share),
                    label: const Text('Share Receipt'),
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

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool canCopy;

  const _DetailRow({
    required this.label, 
    required this.value, 
    required this.isDark,
    this.canCopy = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white60 : AppTheme.lightSecondaryTextColor,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: isDark ? Colors.white : AppTheme.lightTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                if (canCopy) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Copied to clipboard'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppTheme.successColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.copy,
                      size: 16,
                      color: isDark ? Colors.white60 : AppTheme.primaryColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
