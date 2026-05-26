$token = $env:GITHUB_TOKEN
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

    # Force UTF-8 encoding for the payload to avoid character issues
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($payload)

    try {
        $r = Invoke-RestMethod -Uri $base -Method POST -Headers $headers -Body $bytes -ContentType "application/json; charset=utf-8"
        Write-Host "OK #$($r.number): $title"
    } catch {
        Write-Host "FAIL: $title -- $_"
    }
    Start-Sleep -Milliseconds 600
}

# ============================================================
# RETRYING PREVIOUSLY FAILED ISSUES
# ============================================================

Create-Issue `
    "Redesign the Send Money screen with a modern stepper UI" `
    "Break the Send Money flow into clear steps: Recipient -> Amount -> PIN -> Confirm.`n`n**Acceptance Criteria**`n- Step indicator at the top`n- Each step validated before proceeding`n- Back navigation between steps`n- Smooth slide transition between steps" `
    @("ui/ux","enhancement")

Create-Issue `
    "Add integration tests for the full auth flow" `
    "Write integration tests that simulate registration, login, and PIN setup end-to-end.`n`n**Acceptance Criteria**`n- Tests run on a real device or emulator using flutter test integration_test/`n- Cover: register -> verify -> login -> set PIN`n- Tests are stable and repeatable" `
    @("testing","enhancement")

Create-Issue `
    "Add Laravel feature tests for the conversion endpoint" `
    "The /api/wallets/convert endpoint currently lacks dedicated test coverage.`n`n**Acceptance Criteria**`n- Test valid NGN to USD conversion`n- Test invalid currency pair returns 422`n- Test insufficient balance returns 400`n- Test wrong PIN returns 403" `
    @("testing","backend")


# ============================================================
# NEW FEATURE ISSUES (Batch 2)
# ============================================================

Create-Issue `
    "Implement user referral system (Frontend + Backend)" `
    "Allow users to refer friends and earn rewards when the referred user makes their first transaction.`n`n**Acceptance Criteria**`n- Backend: Generate unique referral codes per user`n- Backend: API endpoint to claim referral reward`n- Frontend: 'Invite Friends' screen with shareable link`n- Admin config for reward amount" `
    @("feature","growth","fullstack")

Create-Issue `
    "Add support for Virtual USD Cards" `
    "Integrate a third-party card issuing API (e.g., Stripe, Sudo Africa, or Flutterwave) to allow users to generate virtual USD cards funded from their wallet.`n`n**Acceptance Criteria**`n- API integration for card creation, freezing, and funding`n- Frontend UI to view card details securely (requires PIN)`n- Handle webhook events for card transactions" `
    @("feature","advanced","fullstack")

Create-Issue `
    "Build a promotional banner system for the dashboard" `
    "Allow admins to display targeted promotional banners or announcements on user dashboards.`n`n**Acceptance Criteria**`n- Admin panel UI to create/manage banners (image URL, target link, expiry date)`n- Backend API to fetch active banners`n- Frontend carousel widget on the dashboard to display them" `
    @("feature","admin","ui/ux")

Create-Issue `
    "Implement daily and weekly spending limits" `
    "To protect users, introduce configurable daily and weekly transaction limits.`n`n**Acceptance Criteria**`n- Default limits set by admin (e.g., Tier 1 KYC)`n- Users can view their current limit usage on the profile screen`n- Backend rejects transfers that exceed the rolling limit" `
    @("feature","security","backend")

Create-Issue `
    "Add tiered KYC verification flow" `
    "Implement a Know Your Customer (KYC) flow to unlock higher limits, requiring ID upload and liveness checks.`n`n**Acceptance Criteria**`n- Tier 1: Basic info (Default)`n- Tier 2: ID Document Upload (Drivers License, Passport)`n- Tier 3: Liveness check / Video selfie`n- Admin dashboard interface to manually approve/reject KYC submissions" `
    @("feature","compliance","fullstack")

Create-Issue `
    "Integrate Customer Support Chat SDK" `
    "Add in-app live chat support to assist users in real-time.`n`n**Acceptance Criteria**`n- Integrate Intercom or Zendesk SDK`n- Pass user context (name, email, user_id) to the chat provider`n- Floating action button or Settings menu item to launch chat" `
    @("feature","support","frontend")

Create-Issue `
    "Add Webhook Subscriptions for Merchant APIs" `
    "Allow business users/merchants to subscribe to webhook events (e.g., 'payment_received', 'transfer_completed') to automate their own systems.`n`n**Acceptance Criteria**`n- UI to add webhook URLs and view webhook secrets`n- Backend system to dispatch webhooks asynchronously with signature headers`n- Webhook retry mechanism for failed deliveries" `
    @("feature","advanced","backend")

Create-Issue `
    "Implement Social Login (OAuth2)" `
    "Allow users to sign up and log in using Google or Apple accounts.`n`n**Acceptance Criteria**`n- Integrate google_sign_in and sign_in_with_apple on Flutter`n- Backend OAuth callback endpoints using Laravel Socialite`n- Gracefully handle linking social accounts to existing emails" `
    @("feature","auth","fullstack")

Create-Issue `
    "Implement Redis caching for exchange rates and stats" `
    "Optimize backend performance by caching frequently accessed, rarely changing data.`n`n**Acceptance Criteria**`n- Setup Redis in the environment`n- Cache exchange rates with a 5-minute TTL`n- Cache admin dashboard summary statistics with a 15-minute TTL" `
    @("performance","backend")

Create-Issue `
    "Add auto-lock when app is backgrounded" `
    "Enhance security by automatically locking the app and requiring biometric/PIN if the app is backgrounded for more than 1 minute.`n`n**Acceptance Criteria**`n- Listen to Flutter AppLifecycleState`n- Start a timer when paused, trigger lock overlay when resumed if timer expired`n- Configurable timeout in settings" `
    @("security","frontend")

Create-Issue `
    "Implement 'Blur Balance' privacy feature" `
    "Allow users to hide their wallet balances from prying eyes.`n`n**Acceptance Criteria**`n- Eye icon toggle on the dashboard to blur/unblur balances`n- Remember user's preference using local storage`n- Apply blur effect using BackdropFilter or simple text masking (***)" `
    @("ui/ux","frontend")

Create-Issue `
    "Add Deep Linking for Payment Requests" `
    "Allow users to generate deep links (e.g., fluxapay://pay/username?amount=100) to request money from others.`n`n**Acceptance Criteria**`n- Configure deep links for Android and iOS`n- App intercepts link, opens 'Send Money' screen pre-filled with details`n- Fallback web page if the app is not installed" `
    @("feature","growth","frontend")

Create-Issue `
    "Automated DB backups and disaster recovery runbook" `
    "Ensure data safety by automating database backups and documenting the recovery process.`n`n**Acceptance Criteria**`n- Use spatie/laravel-backup to schedule daily DB dumps to an S3 bucket`n- Write a DISASTER_RECOVERY.md runbook outlining how to restore the database from a backup" `
    @("devops","documentation","backend")

Create-Issue `
    "Add Gamification Badges" `
    "Reward users with profile badges for hitting milestones (e.g., First Deposit, 100 Transfers, Verified User).`n`n**Acceptance Criteria**`n- Backend table to track user achievements`n- UI to display earned badges on the Profile screen`n- Push notification when a new badge is unlocked" `
    @("feature","growth","fullstack")

Create-Issue `
    "Create custom payment link pages (fluxapay.com/pay/username)" `
    "Allow users to share a public URL where anyone can pay them using a card, even if they don't have the FluxaPay app.`n`n**Acceptance Criteria**`n- Laravel web route for /pay/{username}`n- Web checkout UI integrating a payment gateway (Paystack/Stripe)`n- Funds are directly credited to the user's FluxaPay wallet" `
    @("feature","growth","fullstack")

Create-Issue `
    "Accessibility (a11y) Improvements" `
    "Ensure the app is fully usable for visually impaired users.`n`n**Acceptance Criteria**`n- Add Semantics widgets to all custom buttons and icons`n- Ensure proper contrast ratios for text`n- Test flow entirely using iOS VoiceOver and Android TalkBack" `
    @("accessibility","ui/ux","frontend")

Create-Issue `
    "Add biometric approval for outgoing transfers" `
    "Instead of entering a PIN for every transfer, allow users to approve outgoing transactions using FaceID/Fingerprint.`n`n**Acceptance Criteria**`n- Add setting to toggle 'Use Biometrics for Transfers'`n- Fallback to PIN if biometrics fail or are unavailable`n- Cryptographically verify the biometric prompt" `
    @("security","frontend")

Create-Issue `
    "Implement split-payment / bill splitting" `
    "Allow users to split a bill with multiple FluxaPay users.`n`n**Acceptance Criteria**`n- 'Split Bill' feature where user selects multiple contacts and enters total amount`n- Sends payment requests to all selected contacts`n- Track who has paid and who is pending in a dedicated UI" `
    @("feature","advanced","fullstack")

Create-Issue `
    "Add savings vaults/goals" `
    "Allow users to create 'Vaults' to save money aside from their main balance, optionally with auto-save features.`n`n**Acceptance Criteria**`n- Users can create a vault with a name, target amount, and target date`n- Transfer funds freely between main wallet and vault`n- Optional: Auto-save a fixed amount daily/weekly" `
    @("feature","advanced","fullstack")

Write-Host "Batch 2 issues generated!"
