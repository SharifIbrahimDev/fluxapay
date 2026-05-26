import 'package:fluxapay/features/auth/presentation/auth_provider.dart';
import 'package:fluxapay/features/auth/presentation/login_screen.dart';
import 'package:fluxapay/features/auth/presentation/register_screen.dart';
import 'package:fluxapay/features/auth/presentation/forgot_password_screen.dart';
import 'package:fluxapay/features/auth/presentation/reset_password_screen.dart';
import 'package:fluxapay/features/auth/presentation/pin_setup_screen.dart';
import 'package:fluxapay/features/splash/presentation/splash_screen.dart';
import 'package:fluxapay/features/wallets/presentation/dashboard_screen.dart';
import 'package:fluxapay/features/wallets/presentation/conversion_screen.dart';
import 'package:fluxapay/features/wallets/presentation/send_money_screen.dart';
import 'package:fluxapay/features/wallets/presentation/receive_screen.dart';
import 'package:fluxapay/features/settings/presentation/profile_screen.dart';
import 'package:fluxapay/features/settings/presentation/settings_screen.dart';
import 'package:fluxapay/features/wallets/presentation/wallet_detail_screen.dart';
import 'package:fluxapay/features/wallets/presentation/fund_wallet_screen.dart';
import 'package:fluxapay/features/wallets/presentation/withdraw_screen.dart';
import 'package:fluxapay/features/settings/presentation/change_pin_screen.dart';
import 'package:fluxapay/features/wallets/presentation/transactions_screen.dart';
import 'package:fluxapay/features/wallets/presentation/insights_screen.dart';
import 'package:fluxapay/features/admin/presentation/admin_dashboard_screen.dart';
import 'package:fluxapay/features/admin/presentation/admin_withdrawals_screen.dart';
import 'package:fluxapay/features/wallets/presentation/transaction_details_screen.dart';
import 'package:fluxapay/shared/models/transaction_model.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final user = authState.valueOrNull;
      final loggedIn = user != null;
      final authRoutes = [
        '/login', 
        '/register', 
        '/forgot-password', 
        '/reset-password'
      ];
      final isAuthRoute = authRoutes.any((route) => state.matchedLocation.startsWith(route));
      final onSplash = state.matchedLocation == '/splash';

      if (onSplash) return null;

      if (!loggedIn) {
        return isAuthRoute ? null : '/login';
      }

      if (isAuthRoute) {
        return '/';
      }

      // Force PIN setup if not set and not in excluded routes
      if (!user.isPinSet && state.matchedLocation != '/pin-setup' && state.matchedLocation != '/logout') {
        return '/pin-setup';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return ResetPasswordScreen(
            email: data['email']!,
            token: data['token']!,
          );
        },
      ),
      GoRoute(
        path: '/pin-setup',
        builder: (context, state) => const PinSetupScreen(),
      ),
      GoRoute(
        path: '/convert',
        builder: (context, state) => const ConversionScreen(),
      ),
      GoRoute(
        path: '/send',
        builder: (context, state) => const SendMoneyScreen(),
      ),
      GoRoute(
        path: '/receive',
        builder: (context, state) => const ReceiveScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/wallet/:currency',
        builder: (context, state) => WalletDetailScreen(
          currency: state.pathParameters['currency']!,
        ),
      ),
      GoRoute(
        path: '/fund/:currency',
        builder: (context, state) => FundWalletScreen(
          currency: state.pathParameters['currency']!,
        ),
      ),
      GoRoute(
        path: '/withdraw/:currency',
        builder: (context, state) => WithdrawScreen(
          currency: state.pathParameters['currency']!,
        ),
      ),
      GoRoute(
        path: '/change-pin',
        builder: (context, state) => const ChangePinScreen(),
      ),
      GoRoute(
        path: '/activity',
        builder: (context, state) => const TransactionsScreen(),
      ),
      GoRoute(
        path: '/insights',
        builder: (context, state) => const InsightsScreen(),
      ),
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/withdrawals',
        builder: (context, state) => const AdminWithdrawalsScreen(),
      ),
      GoRoute(
        path: '/transaction-details',
        builder: (context, state) {
          final transaction = state.extra as TransactionModel;
          return TransactionDetailsScreen(transaction: transaction);
        },
      ),
    ],
  );
}
