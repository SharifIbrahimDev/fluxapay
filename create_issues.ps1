$token = $env:GITHUB_TOKEN  # Set this environment variable before running: $env:GITHUB_TOKEN = "ghp_..."
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

# ---- BEGINNER ---------------------------------------------------------------
Create-Issue `
    "Add unit tests for CurrencyFormatter" `
    "The CurrencyFormatter class in Flutter has no unit tests. We need test coverage for NGN, USD, and USDT formatting patterns.`n`nAcceptance Criteria`n- Tests cover `formatCurrency` for all supported currencies`n- Edge cases (large values, negative numbers, decimals) are handled correctly`n- All tests pass with flutter test" `
    @("good first issue","testing")

Create-Issue `
    "Add status badges to FluxaPay README" `
    "Make the README look professional by adding badges at the top.`n`nAcceptance Criteria`n- Add GitHub Actions CI workflow badge`n- Add license badge (MIT)`n- Add Flutter version compatibility badge`n- Badges render correctly on GitHub" `
    @("good first issue","documentation")

Create-Issue `
    "Document backend API routes in API_DOCUMENTATION.md" `
    "Create a comprehensive markdown file listing all API routes, request payloads, and response structures for easier frontend collaboration.`n`nAcceptance Criteria`n- Cover Authentication, Wallets, Transfers, Conversions, and Admin endpoints`n- Save file as docs/API_DOCUMENTATION.md" `
    @("good first issue","documentation")

Create-Issue `
    "Enhance transaction PIN validation error messages" `
    "Provide clear, localized, and context-aware error messages when a transaction PIN validation fails on the transfer/conversion screen.`n`nAcceptance Criteria`n- Handle incorrect PIN, locked accounts, and input validation`n- Ensure backend errors are gracefully caught and mapped to user-friendly messages" `
    @("good first issue","enhancement")

# ---- INTERMEDIATE -----------------------------------------------------------
Create-Issue `
    "Implement Biometric login using local_auth" `
    "Allow users to log in securely or authorize small transfers using biometrics (Face ID / Fingerprint).`n`nAcceptance Criteria`n- Integrate local_auth package in Flutter`n- Add biometric toggle in the settings screen`n- Fallback to PIN/Password on failure or when biometrics are unavailable" `
    @("enhancement","feature")

Create-Issue `
    "Add dynamic conversion fee settings to Laravel Admin Dashboard" `
    "Allow administrators to update currency conversion fees (currently hardcoded mock rates/fees) directly from the admin dashboard.`n`nAcceptance Criteria`n- Create an admin settings table and Laravel API endpoint to modify fees`n- Build Flutter admin UI screen to edit NGN/USD/USDT transaction fees`n- Ensure conversions instantly reflect modified fees" `
    @("enhancement","feature")

Create-Issue `
    "Add push notification triggers on P2P transfers" `
    "Trigger push notifications when a user receives funds via transfer or QR code request.`n`nAcceptance Criteria`n- Integrate Firebase Cloud Messaging (FCM) on Flutter frontend`n- Configure Laravel event listeners to dispatch push payloads on successful transactions`n- Handle notification click redirect to transaction details screen" `
    @("enhancement","feature")

Create-Issue `
    "Design a premium glassmorphic dark mode option" `
    "Add a high-quality dark mode theme to the app, showcasing modern glassmorphic designs and custom color palettes.`n`nAcceptance Criteria`n- Create standard dark theme configuration using Riverpod`n- Add theme toggle to settings screen`n- Polish all screens to ensure harmony and excellent readability in dark mode" `
    @("enhancement","feature")

# ---- ADVANCED ---------------------------------------------------------------
Create-Issue `
    "Integrate live payment gateway (Paystack / Flutterwave) for bank transfers" `
    "Integrate a production-grade payment facilitator (like Paystack or Flutterwave) to allow users to fund their digital wallets via actual debit cards or bank transfers.`n`nAcceptance Criteria`n- Integrate payment SDK or webhook endpoints in Laravel backend`n- Build funding flow UI on Flutter to collect card/transfer confirmations`n- Process and settle ledger records correctly in real-time" `
    @("enhancement","advanced","feature")

Create-Issue `
    "Implement full offline mode with local SQL database cache" `
    "Cache transaction history locally so that users can view their statements and wallet details even without active internet connection.`n`nAcceptance Criteria`n- Integrate sqflite or floor package in Flutter`n- Sync latest data to local database whenever connection is established`n- Implement offline indicator banner when connection is lost" `
    @("enhancement","advanced","feature")

Create-Issue `
    "Develop multi-signature/two-factor approval flow for high-volume transactions" `
    "Protect user accounts by requiring secondary SMS/Email 2FA or multi-signature verification for transfers exceeding a specific threshold (e.g., NGN 100,000).`n`nAcceptance Criteria`n- Add transaction limit settings to database`n- Require verification token on backend API when threshold is exceeded`n- Build custom OTP overlay screen in Flutter to capture authorization" `
    @("enhancement","advanced","security")

Create-Issue `
    "Implement secure device binding to prevent account hijack" `
    "Bind user accounts to a specific mobile device identifier on login to prevent unauthorized access from new devices without additional checks.`n`nAcceptance Criteria`n- Collect secure device fingerprint on Flutter during login`n- Authenticate device token on Laravel Sanctum auth layer`n- Trigger email verification flow when login is attempted from an unrecognized device" `
    @("enhancement","advanced","security")

# ---- DOCS -------------------------------------------------------------------
Create-Issue `
    "Write comprehensive FluxaPay MVP deployment guide" `
    "Write a detailed tutorial outlining how to deploy the Laravel API to production (e.g. Fly.io or VPS) and package the Flutter app for iOS/Android.`n`nAcceptance Criteria`n- Cover database setup, Nginx configurations, environment variables, and build tools`n- Save file as docs/DEPLOYMENT.md" `
    @("documentation")

Write-Host ""
Write-Host "All done!"
