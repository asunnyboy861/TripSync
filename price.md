# Price Configuration

## Monetization Model
Auto-renewable Subscription (IAP Required)

## Subscription Group
Group Name: TripSync Pro

### Tier 0: Free (Always Available)
- **Type**: Free (limited features)
- **Features**: Up to 2 trips, basic itinerary builder, map view, basic polls, dark mode, local storage
- **Purpose**: User acquisition, trial experience

### Tier 1: Monthly Subscription
- **Reference Name**: TripSync Pro Monthly
- **Product ID**: com.zzoutuo.TripSync.pro.monthly
- **Price**: $2.99 (USD)
- **Subscription Period**: 1 Month
- **Localization (English US)**:
  - Display Name: TripSync Pro Monthly (max 35 chars)
  - Description: Unlock all premium features (max 55 chars)

### Tier 2: Yearly Subscription
- **Reference Name**: TripSync Pro Yearly
- **Product ID**: com.zzoutuo.TripSync.pro.yearly
- **Price**: $19.99 (USD)
- **Subscription Period**: 1 Year
- **Localization (English US)**:
  - Display Name: TripSync Pro Yearly (max 35 chars)
  - Description: Save 45% with annual plan (max 55 chars)

### Tier 3: Lifetime (Non-consumable)
- **Include ONLY if**: App has NO API costs or usage-based costs
- **Reference Name**: TripSync Pro Lifetime
- **Product ID**: com.zzoutuo.TripSync.pro.lifetime
- **Price**: $49.99 (USD)
- **Type**: Non-consumable (One-time, no renewal)
- **Localization (English US)**:
  - Display Name: TripSync Pro Lifetime (max 35 chars)
  - Description: One-time purchase, forever access (max 55 chars)

### Premium Features (Unlocked by Pro)
- Unlimited trips
- iCloud sync across devices
- Expense splitting with multi-currency
- Advanced polls (swipe voting)
- Packing list templates
- Trip sharing with custom permissions
- Export trip as PDF
- Priority support

## App Store Connect Setup Instructions
1. Go to App Store Connect → Your App → Subscriptions
2. Create Subscription Group: "TripSync Pro"
3. Add subscriptions with above Product IDs
4. Configure localizations for each
5. Submit for review

## IAP Compliance Checklist (REQUIRED for Subscription Apps)
- [ ] Paywall displays subscription names
- [ ] Paywall displays subscription durations
- [ ] Dynamic pricing from StoreKit (no hardcoded prices)
- [ ] Renewal terms displayed: "Subscription automatically renews unless canceled..."
- [ ] Cancellation instructions displayed
- [ ] Free trial clause displayed (if applicable)
- [ ] Restore Purchases button implemented
- [ ] Privacy Policy link on paywall
- [ ] Terms of Use link on paywall
- [ ] NO dark patterns (no auto-selecting expensive options)
- [ ] Lifetime tier included (app has no API/usage costs)
