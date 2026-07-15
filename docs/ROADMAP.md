# expenseful — 3-Week Roadmap (India-first)

**Product one-liner:** *The private UPI + cash tracker that lives entirely on your phone — no account linking, no ads, no loan pitches.*

## Strategic positioning

India is **not an empty market** (Axio/ex-Walnut, Money View, Fold are established) — it's a **positioning gap**. Every incumbent shares three weaknesses, and our thesis is the antidote to all three:

| Incumbent | What they do | Their weakness = our opening |
|---|---|---|
| Axio (ex-Walnut) | SMS auto-track, 40+ banks | Drifted into **lending**; privacy trade-offs, ad-heavy |
| Money View | SMS auto-track since 2014 | Also now a **loan platform**; reads all your SMS |
| Fold | Account Aggregator auto-sync | Requires **linking every account** — not private, not offline |
| SMS apps generally | Parse bank texts | **Blind to cash** (street food, vegetables, autos); double-count refunds |

**Our wedge:** a privacy-first, on-device, no-lending tracker that captures **UPI *and* cash**, and never sells a loan. The offline / no-bank-integration thesis is the differentiator, not a limitation.

### Locked decisions
- **Auto-capture method:** on-device **NotificationListener** (parse UPI/bank push notifications locally). *Not* SMS `READ_SMS`, *not* Account Aggregator. This is Play-Store compliant, private, and requires no account linking.
- **Positioning:** privacy + cash + no-lending wedge.

## Why the US benchmarks don't apply

India's money mechanic is UPI (16.6B transactions/month, Oct 2025) + RBI-mandated bank SMS alerts for every debit. Auto-tracking here has never meant Plaid-style bank APIs. Pure manual entry **cannot** win against Axio/Money View given UPI volume — hence the on-device capture pivot in Week 2.

---

## Week 1 — Make it unmistakably Indian + close the insight loop
- **India category pack** — replace the generic seed in `lib/data/database.dart` with Rent, Groceries/Vegetables, Fuel, EMI, Recharge/Bills, Auto/Cab, Eating out, Domestic help. (Schema migration, bump `schemaVersion` to 4.)
- **Insights screen** — `fl_chart` is already installed; wire the dead "Budget & Insights" settings row. Category donut, monthly trend, and a **Cash vs UPI split** chart.
- **Cash-first quick-add** — 2-tap hero flow. Cash is the segment SMS-based incumbents structurally can't see; it's our beachhead.

## Week 2 — The wedge: on-device UPI capture (NotificationListener)
- **Notification capture service** — detect GPay / PhonePe / Paytm / bank debit notifications, parse amount + payee/VPA **on-device only**, surface a **"Confirm expense?"** card. Opt-in; nothing leaves the phone.
- **VPA/merchant → category** mapping that learns from user corrections.
- **Refund & self-transfer dedup** — the exact noise complaint users have about Axio/Money View.

## Week 3 — Trust, retention, delight
- **App lock / biometric** + a visible **"100% on-device · no lending · no ads"** privacy screen (turn the thesis into marketing).
- **Recurring** (rent/EMI/subscriptions — existing settings placeholder) + **daily cash-logging reminder**.
- **Streaks & badges** for consistent logging (fits the playful brand) + **CSV export** ("own your data").

## Parked (deliberately)
Account linking, Account Aggregator, credit score, investments, lending — every one is where incumbents monetize and leak privacy. Staying out is the differentiator.

---

## Appendix: the two auto-capture routes for India

Two technical ways to read transactions automatically. We chose **NotificationListener**.

### 1. `READ_SMS` (SMS parsing)
- Reads the actual bank/UPI **SMS** in the messages inbox via the `READ_SMS` / `RECEIVE_SMS` permissions.
- **Higher coverage** — catches transactions even when the payment app sends no push notification, and works for card swipes/ATM.
- **Play Store restriction:** Google restricts `READ_SMS` to apps that are the device's **default SMS handler**. A finance tracker isn't, so it needs a special Play Console **permissions declaration/exception** and often gets rejected. High policy risk.
- **Privacy cost:** the app can read *all* SMS (OTPs, personal messages), which undercuts a privacy-first pitch.

### 2. NotificationListener (chosen)
- Uses `NotificationListenerService` to read the **push notifications** the bank/UPI apps already post (e.g. "₹250 paid to X via PhonePe").
- **Play-Store compliant** for this use case; no default-SMS-handler requirement.
- **Privacy-aligned:** we only inspect notifications from a user-approved allowlist of finance apps, parse on-device, and store nothing off-device. Fits the "100% on-device" brand.
- **Trade-off:** slightly lower coverage than SMS (depends on the app posting a notification with the amount), and requires the user to grant notification-access in system settings.

**Net:** SMS = more coverage, worse privacy story, real risk of Play Store rejection. NotificationListener = compliant, on-brand for privacy, minor coverage gap. The coverage gap is covered by our cash-first manual flow anyway.
