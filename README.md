# FluxaPay MVP

A multi-currency digital wallet application for Nigerian users.

## Features
- **Multi-currency support**: NGN, USD, USDT.
- **Ledger-based accounting**: Immutable transaction records.
- **Currency Conversion**: Real-time mock rates with fees.
- **Send Money**: P2P transfers via email or Virtual Account Number.
- **Receive Money**: QR Code generation and copyable account details.
- **Virtual Account Number**: Unique 10-digit ID for every user.
- **Profile & Settings**: Dedicated screens for user identity and app preferences.
- **Security**: Sanctum Auth, Transaction PIN setup, and validation.
- **Admin Panel**: User management and transaction monitoring.

## Tech Stack
- **Frontend**: Flutter (Riverpod, Dio, GoRouter, Freezed).
- **Backend**: Laravel 12.x (Sanctum, MySQL).

## Setup Instructions

### Backend (Laravel)
1. Navigate to the `backend` folder.
2. Install dependencies: `composer install`.
3. Copy `.env.example` to `.env`.
4. Create a MySQL database named `fluxapay`.
5. Update your `.env` with your MySQL credentials (`DB_USERNAME`, `DB_PASSWORD`).
6. Generate app key: `php artisan key:generate`.
7. Run migrations and seeders: `php artisan migrate --seed`.
8. Start the server: `php artisan serve`.

### Frontend (Flutter)
1. Navigate to the root project folder.
2. Install dependencies: `flutter pub get`.
3. Generate code items: `flutter pub run build_runner build --delete-conflicting-outputs`.
4. Run the app: `flutter run`.

## API Endpoints
- `POST /api/register`
- `POST /api/login`
- `GET /api/user` (Auth required)
- `POST /api/set-pin` (Auth required)
- `GET /api/wallets` (Auth required)
- `POST /api/wallets/convert` (Auth required + PIN)
- `POST /api/wallets/convert` (Auth required + PIN)
- `POST /api/wallets/transfer` (Auth required + PIN)
- `GET /api/wallets/transactions` (Auth required)

## Admin Endpoints
- `GET /api/admin/users`
- `POST /api/withdrawal/{ref}/approve`

## Testing

### Backend Tests
Run the PHPUnit suite:
```bash
cd backend
php artisan test
```

### Frontend Tests
Run widget tests:
```bash
flutter test
```

### Automated API Testing (Newman)
Run the collection using Newman:
```bash
newman run newman_collection.json --env-var baseUrl=http://localhost:8000
```

### Unified Runner
Run both backend and frontend tests:
```bash
chmod +x run_tests.sh
./run_tests.sh
```
