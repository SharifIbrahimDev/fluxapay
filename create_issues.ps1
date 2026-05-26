$token = $env:GITHUB_TOKEN  # Set before running: $env:GITHUB_TOKEN = "ghp_..."
$repo  = "SharifIbrahimDev/fluxapay"
$base  = "https://api.github.com/repos/$repo/issues"
$headers = @{
    Authorization = "Bearer $token"
    Accept        = "application/vnd.github+json"
}

function Create-Issue($title, $body, $labels) {
    $payload = [ordered]@{
        title  = $title
        body   = $body
        labels = $labels
    } | ConvertTo-Json -Depth 5
    try {
        $r = Invoke-RestMethod -Uri $base -Method POST -Headers $headers -Body $payload -ContentType "application/json"
        Write-Host "OK #$($r.number): $title"
    } catch {
        Write-Host "FAIL: $title -- $_"
    }
    Start-Sleep -Milliseconds 600
}

# ============================================================
# BEGINNER ISSUES
# ============================================================

Create-Issue `
    "Add unit tests for CurrencyFormatter" `
    "The CurrencyFormatter utility has no unit tests.`n`n**Acceptance Criteria**`n- Cover formatCurrency for NGN, USD, and USDT`n- Handle edge cases: zero, large numbers, negative values`n- All tests pass with ``flutter test``" `
    @("good first issue","testing")

Create-Issue `
    "Add status badges to README" `
    "Add professional badges to the top of README.md.`n`n**Acceptance Criteria**`n- GitHub Actions CI badge`n- MIT License badge`n- Flutter version badge`n- All badges render correctly on GitHub" `
    @("good first issue","documentation")

Create-Issue `
    "Document all backend API routes in API_DOCUMENTATION.md" `
    "Create a comprehensive API reference file at ``docs/API_DOCUMENTATION.md``.`n`n**Acceptance Criteria**`n- Cover Auth, Wallets, Transfers, Conversions, Admin endpoints`n- Include example request/response bodies for each route`n- Document required headers (e.g., Authorization)" `
    @("good first issue","documentation")

Create-Issue `
    "Add custom exception classes for API error handling" `
    "Create typed exception classes to replace generic catches throughout the Flutter app.`n`n**Acceptance Criteria**`n- Create ``ApiException``, ``AuthException``, ``NetworkException`` classes`n- Use them consistently in all repository classes`n- Add unit tests for exception scenarios" `
    @("good first issue","enhancement")

Create-Issue `
    "Add dartdoc comments to all public APIs" `
    "All public classes and methods must have proper dartdoc comments.`n`n**Acceptance Criteria**`n- All public APIs in ``lib/`` are documented`n- Run ``dart doc`` successfully with no warnings`n- Link added to README" `
    @("good first issue","documentation")

Create-Issue `
    "Improve PIN input field UX with shake animation on error" `
    "When a user enters an incorrect transaction PIN, the PIN input field should animate a shake to indicate failure.`n`n**Acceptance Criteria**`n- Implement a shake animation widget`n- Trigger animation on incorrect PIN submission`n- Animate and clear the field gracefully" `
    @("good first issue","ui/ux")

Create-Issue `
    "Add empty state illustration for transaction history" `
    "When a user has no transactions, show a friendly illustration and message instead of a blank list.`n`n**Acceptance Criteria**`n- Custom illustration or Lottie animation`n- Friendly message: 'No transactions yet'`n- Consistent styling with app theme" `
    @("good first issue","ui/ux")

Create-Issue `
    "Add copy-to-clipboard button for Virtual Account Number" `
    "Users should be able to easily copy their Virtual Account Number on the dashboard and receive screen.`n`n**Acceptance Criteria**`n- Tappable copy icon next to account number`n- Shows a SnackBar confirmation: 'Copied to clipboard'`n- Works on both Android and iOS" `
    @("good first issue","enhancement")

Create-Issue `
    "Add pull-to-refresh on the dashboard screen" `
    "Users should be able to pull down to refresh their wallet balances and recent transactions.`n`n**Acceptance Criteria**`n- Implement RefreshIndicator widget`n- Re-fetch wallets and transactions on pull`n- Loading indicator shown during refresh" `
    @("good first issue","enhancement")

Create-Issue `
    "Improve Laravel validation error messages to be user-friendly" `
    "Replace default Laravel validation messages with cleaner, context-aware messages for all API endpoints.`n`n**Acceptance Criteria**`n- Cover all validation rules in AuthController and WalletController`n- Messages are clear and human-readable`n- Return consistent JSON error structure" `
    @("good first issue","backend")

# ============================================================
# INTERMEDIATE ISSUES
# ============================================================

Create-Issue `
    "Implement biometric authentication for app login" `
    "Allow users to log in using Face ID or Fingerprint instead of entering password every time.`n`n**Acceptance Criteria**`n- Integrate local_auth package`n- Add biometric toggle in Settings screen`n- Fallback to PIN/password on failure`n- Persist biometric preference securely" `
    @("enhancement","feature","security")

Create-Issue `
    "Add push notifications for incoming transfers" `
    "Notify users in real-time when they receive funds via P2P transfer or QR payment.`n`n**Acceptance Criteria**`n- Integrate Firebase Cloud Messaging (FCM) on Flutter side`n- Laravel backend fires push notification on successful credit`n- Notification click opens transaction details screen" `
    @("enhancement","feature")

Create-Issue `
    "Implement dark mode theme" `
    "Add a high-quality dark mode using Riverpod-based theme management.`n`n**Acceptance Criteria**`n- Define complete dark ThemeData alongside existing light theme`n- Add toggle in Settings screen`n- Persist theme preference using shared_preferences`n- All screens tested in dark mode" `
    @("enhancement","feature","ui/ux")

Create-Issue `
    "Add admin setting to manage live conversion rates" `
    "Allow admins to update currency conversion rates from the dashboard instead of using hardcoded mock values.`n`n**Acceptance Criteria**`n- Create ``exchange_rates`` management UI in admin dashboard`n- New Laravel API endpoints: GET/PUT /api/admin/rates`n- Flutter app reads live rates from API" `
    @("enhancement","feature","backend")

Create-Issue `
    "Add transaction filtering and search" `
    "Allow users to filter their transaction history by type (credit/debit), currency, and date range.`n`n**Acceptance Criteria**`n- Filter bar on the transactions screen`n- Backend supports query parameters: type, currency, from_date, to_date`n- Results update reactively" `
    @("enhancement","feature")

Create-Issue `
    "Add paginated transaction history loading" `
    "Load transactions in pages instead of all at once to improve performance and reduce server load.`n`n**Acceptance Criteria**`n- Implement infinite scroll with pagination`n- Backend returns paginated response with meta (current_page, last_page)`n- Loading indicator shown at the bottom while fetching next page" `
    @("enhancement","feature","backend")

Create-Issue `
    "Implement transaction receipt sharing" `
    "Allow users to share a formatted transaction receipt as an image or PDF after completing a transfer.`n`n**Acceptance Criteria**`n- Generate receipt widget with transaction details`n- Use share_plus to share receipt image`n- Receipt is branded with FluxaPay logo and colors" `
    @("enhancement","feature","ui/ux")

Create-Issue `
    "Add user profile photo upload" `
    "Allow users to upload and update their profile photo from the Profile screen.`n`n**Acceptance Criteria**`n- Integrate image_picker for camera/gallery selection`n- Upload image to Laravel backend (store in storage/public)`n- Display avatar throughout the app (dashboard, settings)" `
    @("enhancement","feature")

Create-Issue `
    "Implement wallet balance chart on Insights screen" `
    "Replace placeholder on the Insights screen with an interactive line chart showing balance history over time.`n`n**Acceptance Criteria**`n- Integrate fl_chart package`n- Display 7-day and 30-day balance trend per wallet currency`n- Chart animates on load" `
    @("enhancement","feature","ui/ux")

Create-Issue `
    "Add email verification flow for new registrations" `
    "Send a verification email after registration and require users to verify before accessing the app.`n`n**Acceptance Criteria**`n- Laravel sends verification email on register`n- API returns 403 with clear message if unverified`n- Flutter shows verification reminder screen with resend option" `
    @("enhancement","feature","security","backend")

Create-Issue `
    "Add transaction PIN change flow with current PIN confirmation" `
    "The existing change PIN screen should require the user's current PIN before allowing a change.`n`n**Acceptance Criteria**`n- Add current PIN verification step`n- Backend validates current PIN before updating`n- Show success/failure feedback to user" `
    @("enhancement","security")

Create-Issue `
    "Implement rate limiting on sensitive API endpoints" `
    "Apply Laravel rate limiting to prevent brute-force attacks on login, PIN validation, and registration endpoints.`n`n**Acceptance Criteria**`n- Max 5 failed attempts in 10 minutes for login/PIN`n- Return 429 Too Many Requests with retry-after header`n- Flutter shows appropriate lock message to user" `
    @("enhancement","security","backend")

Create-Issue `
    "Add Swagger/OpenAPI documentation for the Laravel API" `
    "Generate interactive API documentation using L5-Swagger.`n`n**Acceptance Criteria**`n- Install and configure l5-swagger`n- Annotate all API controllers with OpenAPI annotations`n- Documentation accessible at /api/documentation" `
    @("enhancement","documentation","backend")

Create-Issue `
    "Add GitHub Actions CI workflow for Flutter" `
    "Set up a CI pipeline that automatically runs tests on every push and PR.`n`n**Acceptance Criteria**`n- Workflow runs flutter analyze and flutter test`n- Fails on lint errors or test failures`n- Badge shown on README" `
    @("enhancement","ci/cd")

Create-Issue `
    "Add GitHub Actions CI workflow for Laravel backend" `
    "Set up a CI pipeline for the Laravel backend that runs PHPUnit tests.`n`n**Acceptance Criteria**`n- Workflow sets up PHP, MySQL, runs migrations, and executes php artisan test`n- Fails if any test fails`n- Badge shown on README" `
    @("enhancement","ci/cd","backend")

# ============================================================
# ADVANCED ISSUES
# ============================================================

Create-Issue `
    "Integrate Paystack for real NGN wallet funding" `
    "Replace the mock funding flow with a real Paystack integration to allow users to fund their NGN wallet via card or bank transfer.`n`n**Acceptance Criteria**`n- Integrate paystack_flutter SDK`n- Laravel webhook handles payment confirmation and credits wallet`n- Idempotent processing to avoid duplicate credits" `
    @("enhancement","advanced","feature")

Create-Issue `
    "Implement full offline support with local SQLite cache" `
    "Cache wallet balances and transaction history locally so users can view data without an internet connection.`n`n**Acceptance Criteria**`n- Integrate drift (formerly moor) or floor package`n- Sync from API when connection is available`n- Show 'Offline Mode' banner when no internet detected" `
    @("enhancement","advanced","feature")

Create-Issue `
    "Add OTP-based 2FA for high-value transactions" `
    "Require SMS or email OTP verification for transfers exceeding a configurable threshold (e.g., NGN 100,000).`n`n**Acceptance Criteria**`n- Configurable limit stored in settings table`n- Laravel generates and sends OTP via email/SMS`n- Flutter OTP entry overlay before transfer is submitted" `
    @("enhancement","advanced","security")

Create-Issue `
    "Implement device binding to detect new device logins" `
    "Bind user sessions to a device fingerprint and send email alerts when a login is detected from an unrecognized device.`n`n**Acceptance Criteria**`n- Collect device_id on Flutter login`n- Laravel checks device_id per user`n- Trigger email alert on unrecognized device`n- Allow user to trust/revoke devices" `
    @("enhancement","advanced","security")

Create-Issue `
    "Build a transaction dispute and reversal system" `
    "Allow users to flag a transaction for dispute and allow admins to review and process reversals.`n`n**Acceptance Criteria**`n- Flutter: dispute button on transaction details screen`n- Laravel: dispute table with status (pending/resolved/rejected)`n- Admin dashboard: dispute management view`n- Reversal credits original sender's wallet" `
    @("enhancement","advanced","feature")

Create-Issue `
    "Add fraud detection heuristics on the backend" `
    "Detect suspicious transaction patterns and automatically flag or block them.`n`n**Acceptance Criteria**`n- Flag transactions that exceed velocity limits (e.g., 10 transfers in 1 hour)`n- Flag logins from new geographic regions`n- Quarantine suspicious transactions for admin review`n- Notify user of blocked activity" `
    @("enhancement","advanced","security","backend")

Create-Issue `
    "Implement scheduled automatic recurring transfers" `
    "Allow users to set up automatic recurring transfers (daily, weekly, monthly) to other accounts.`n`n**Acceptance Criteria**`n- Flutter UI to configure recurring transfer details`n- Laravel scheduled job executes transfers on time`n- Users can view, edit, and cancel scheduled transfers" `
    @("enhancement","advanced","feature")

Create-Issue `
    "Add multi-language (i18n) support" `
    "Support multiple languages using Flutter's intl package to serve a wider user base.`n`n**Acceptance Criteria**`n- Set up intl and ARB files for at least 2 languages (English + one additional)`n- Language switcher in Settings screen`n- All UI strings externalized" `
    @("enhancement","advanced","feature","ui/ux")

Create-Issue `
    "Implement end-to-end encrypted messaging for transfer notes" `
    "Allow users to attach end-to-end encrypted optional notes to P2P transfers.`n`n**Acceptance Criteria**`n- Encrypt note on sender's device before transmission`n- Backend stores ciphertext only`n- Recipient decrypts and displays note on their transaction details" `
    @("enhancement","advanced","security","feature")

Create-Issue `
    "Add admin audit log viewer in the dashboard" `
    "Allow admins to see a detailed audit log of all admin actions taken (user management, rate changes, dispute resolutions).`n`n**Acceptance Criteria**`n- Laravel AuditLog model and middleware logs all admin API calls`n- Admin dashboard screen with filterable audit log table`n- Logs show: action, admin_id, timestamp, affected resource" `
    @("enhancement","advanced","feature","backend")

Create-Issue `
    "Implement USDT on-chain withdrawal via wallet address" `
    "Allow users to withdraw USDT to an external blockchain wallet address.`n`n**Acceptance Criteria**`n- User provides TRC20 or ERC20 wallet address`n- Admin review queue for USDT withdrawals above a threshold`n- Status updates: pending, processing, completed, failed`n- Email notification on completion" `
    @("enhancement","advanced","feature")

# ============================================================
# UI/UX ISSUES
# ============================================================

Create-Issue `
    "Add glassmorphism card design to wallet balance cards" `
    "Redesign the wallet balance cards on the dashboard with a modern glassmorphism aesthetic.`n`n**Acceptance Criteria**`n- Frosted glass effect with subtle gradient`n- Smooth hover/tap animation`n- Consistent on both light and dark themes" `
    @("ui/ux","enhancement")

Create-Issue `
    "Add animated number counter for balance display" `
    "Animate the balance numbers when the dashboard loads or when balance changes.`n`n**Acceptance Criteria**`n- Smooth rolling number animation on load`n- Animation triggers on pull-to-refresh`n- Subtle enough to not distract" `
    @("ui/ux","enhancement")

Create-Issue `
    "Add loading skeleton screens instead of spinners" `
    "Replace CircularProgressIndicator with content skeleton loaders for a more professional UX.`n`n**Acceptance Criteria**`n- Skeleton loaders for: dashboard, transaction list, wallet details`n- Shimmer animation effect`n- Consistent with app color palette" `
    @("ui/ux","enhancement")

Create-Issue `
    "Redesign the Send Money screen with a modern stepper UI" `
    "Break the Send Money flow into clear steps: Recipient → Amount → PIN → Confirm.`n`n**Acceptance Criteria**`n- Step indicator at the top`n- Each step validated before proceeding`n- Back navigation between steps`n- Smooth slide transition between steps" `
    @("ui/ux","enhancement")

Create-Issue `
    "Add haptic feedback on key interactions" `
    "Provide subtle haptic feedback on important actions: successful transfer, PIN entry, copy to clipboard.`n`n**Acceptance Criteria**`n- Use HapticFeedback from Flutter SDK`n- Triggered on: transfer success, copy account number, PIN digit tap`n- Respects system-level haptic settings" `
    @("ui/ux","enhancement")

# ============================================================
# TESTING ISSUES
# ============================================================

Create-Issue `
    "Increase Flutter widget test coverage to 80%" `
    "Add comprehensive widget tests for all major screens.`n`n**Acceptance Criteria**`n- Cover: LoginScreen, DashboardScreen, SendMoneyScreen, ConversionScreen`n- Mock Riverpod providers using ProviderContainer`n- All tests pass with flutter test" `
    @("testing","enhancement")

Create-Issue `
    "Add integration tests for the full auth flow" `
    "Write integration tests that simulate registration, login, and PIN setup end-to-end.`n`n**Acceptance Criteria**`n- Tests run on a real device or emulator using flutter test integration_test/`n- Cover: register → verify → login → set PIN`n- Tests are stable and repeatable" `
    @("testing","enhancement")

Create-Issue `
    "Add Laravel feature tests for the conversion endpoint" `
    "The /api/wallets/convert endpoint currently lacks dedicated test coverage.`n`n**Acceptance Criteria**`n- Test valid NGN→USD conversion`n- Test invalid currency pair returns 422`n- Test insufficient balance returns 400`n- Test wrong PIN returns 403" `
    @("testing","backend")

Create-Issue `
    "Add Laravel feature tests for admin endpoints" `
    "Expand the AdminTest.php to cover all admin API actions.`n`n**Acceptance Criteria**`n- Cover user listing, user suspension, withdrawal approval/rejection`n- Test non-admin access returns 403`n- All tests pass with php artisan test" `
    @("testing","backend")

# ============================================================
# BACKEND ISSUES
# ============================================================

Create-Issue `
    "Add account suspension feature to admin panel" `
    "Allow admins to suspend or reactivate user accounts directly from the dashboard.`n`n**Acceptance Criteria**`n- Add ``is_suspended`` boolean to users table (migration)`n- POST /api/admin/users/{id}/suspend and /unsuspend endpoints`n- Suspended users receive a 403 on any authenticated API call`n- Admin dashboard shows suspension status and toggle" `
    @("backend","feature","enhancement")

Create-Issue `
    "Implement transaction soft-delete and archive" `
    "Allow transactions to be archived/soft-deleted instead of permanently removed, to maintain the immutable ledger.`n`n**Acceptance Criteria**`n- Add ``deleted_at`` column to transactions table via migration`n- Use Laravel SoftDeletes trait`n- Archived transactions excluded from user-facing lists`n- Admin can view archived transactions" `
    @("backend","enhancement")

Create-Issue `
    "Add request logging middleware to Laravel API" `
    "Log all incoming API requests (endpoint, method, user_id, IP address, response time) for diagnostics.`n`n**Acceptance Criteria**`n- Custom middleware logs to database or log channel`n- Include: timestamp, method, path, user_id, IP, status_code`n- Exclude sensitive fields (passwords, PINs)" `
    @("backend","enhancement","security")

Create-Issue `
    "Add database query optimization and indexes" `
    "Analyze and optimize slow database queries, adding indexes where needed.`n`n**Acceptance Criteria**`n- Add indexes to: transactions(user_id), transactions(created_at), wallets(user_id)`n- Use Laravel Telescope or query log to identify N+1 problems`n- Document changes in a migration file" `
    @("backend","enhancement","performance")

Create-Issue `
    "Implement a wallet statement export to CSV/PDF" `
    "Allow users to export their transaction history as a downloadable CSV or PDF file.`n`n**Acceptance Criteria**`n- Laravel generates CSV/PDF from transaction history`n- GET /api/wallets/export?format=csv&from=&to=`n- Flutter downloads and opens file using open_filex package" `
    @("backend","feature","enhancement")

Write-Host ""
Write-Host "All 50 issues created!"
