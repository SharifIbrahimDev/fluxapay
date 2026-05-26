# Contributing to FluxaPay

Thank you for your interest in contributing to FluxaPay! We welcome contributions of all kinds: bug fixes, new features, UI/UX polish, backend optimizations, documentation, and more.

## Getting Started

1. **Fork the repository** on GitHub.
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/fluxapay.git
   ```
3. **Create a feature branch**:
   ```bash
   git checkout -b feature/amazing-new-feature
   ```

---

## Technical Contributions

### Frontend (Flutter)
FluxaPay's frontend is located in the root directory.

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
2. **Code Generation** (Riverpod providers and Freezed models):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
3. **Run Code Formatting & Analysis**:
   ```bash
   flutter format .
   flutter analyze
   ```
4. **Run Unit & Widget Tests**:
   ```bash
   flutter test
   ```

### Backend (Laravel)
FluxaPay's backend API is located in the `backend` folder.

1. **Navigate to backend and Install Dependencies**:
   ```bash
   cd backend
   composer install
   ```
2. **Setup Local Environment**:
   - Copy `.env.example` to `.env`
   - Setup a local MySQL database named `fluxapay`
   - Generate application key: `php artisan key:generate`
   - Run migrations and seeds: `php artisan migrate --seed`
3. **Run Backend Feature Tests**:
   ```bash
   php artisan test
   ```

---

## Submitting a Pull Request

1. **Commit your changes**: Ensure your commit messages are clear, descriptive, and follow semantic commit conventions (e.g. `feat: add biometric authentication` or `fix: handle currency conversion rounding`).
2. **Push your branch**:
   ```bash
   git push origin feature/amazing-new-feature
   ```
3. **Open a Pull Request**: Submit the PR against the `main` branch of `SharifIbrahimDev/fluxapay`.
4. **Provide Details**: In the PR description, explain what changes you made, what issues are resolved, and how you tested the changes.

Thank you for helping to improve financial access and digital banking for users in emerging markets!
