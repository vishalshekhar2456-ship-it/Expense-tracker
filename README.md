# expenseful

A playful, Android-first expense tracker with no bank integration — all data
is stored locally on the device. Built around a friendly "coin jar" visual
metaphor.

## Stack

- **State management**: Riverpod (with `riverpod_annotation` code generation)
- **Local storage**: Drift (SQL layer over SQLite)
- **Navigation**: go_router
- **Fonts**: google_fonts (fetched at runtime, cached — no manual `.ttf` files)
- **Utilities**: intl (formatting), uuid (IDs)

> Declared but not yet wired up: `fl_chart` (for the planned Insights screen)
> and `firebase_core` / `firebase_auth` (optional identity, no cloud sync).
> See the roadmap below.

## Current features

The app is functional end-to-end for local expense tracking:

- **Add expense** — amount, merchant, notes, date, and category.
- **Edit expense** — tap any expense (in History or Recent Activity) to edit
  it; changes are persisted via a full-row update.
- **Delete expense** — swipe an expense left in History to delete it, with an
  **Undo** snackbar. Deletes are *soft* (`isDeleted` flag), so nothing is
  destroyed immediately.
- **Dashboard** — live "spent this month" total with a month-over-month change
  badge, plus a Recent Activity preview of the latest expenses (both driven by
  real DB data).
- **History** — full, reverse-chronological list of expenses with category
  icons/colors and per-item currency formatting.
- **Categories** — expenses are tagged with a category (icon + color).
- **Budgets** — an overall monthly budget cap plus per-category limits, set on a
  dedicated Budgets screen. Spend is measured against the configured budget
  cycle (`budgetResetDay`); the dashboard shows a "Budget Used" summary and each
  category shows its own progress, with over-budget states highlighted.
- **Settings** — currency selection (symbol resolved via `intl`) and date
  format preference, applied consistently across the app.

## Architecture

Two layers, glued together by Riverpod providers — there is intentionally **no
separate domain layer**; the Drift-generated `Expense`/`Category` classes serve
as the models.

- **Data** (`lib/data/`) — the Drift `AppDatabase` holds all tables and all
  queries (expense CRUD, category/budget/settings reads). `schemaVersion` is
  currently **3** (v3 added the overall budget column + per-category `Budgets`
  table, with an `onUpgrade` migration).
- **Presentation** (`lib/features/*/presentation/`) — screens and widgets. UI
  reads data through Riverpod providers (`expensesProvider`,
  `categoriesProvider`, `currencySymbolProvider`, `settingsProvider`) and
  performs writes via `appDatabaseProvider`. Lists are reactive: any DB change
  re-emits on a stream and the UI updates automatically.

### Actual folder structure

```
lib/
  app/                     # router.dart, theme.dart
  core/
    constants/             # categories, category_visuals (icon/color mapping), currencies
    widgets/               # shared widgets (app_card, ...)
  data/
    database.dart          # AppDatabase — tables + all queries
    database.g.dart        # generated
    models/                # Drift table definitions (expenses, categories, app_settings)
  features/
    add_expense/presentation/    # add screen + form widgets
    edit_expense/presentation/   # edit screen (reuses add-expense widgets)
    history/presentation/        # expense history list
    home/presentation/           # dashboard + widgets (balance, recent activity, ...)
    settings/presentation/       # settings + currency screens
  providers/               # Riverpod providers (database, expenses, categories, currency, settings)
  repositories/            # settings_repository (only settings so far)
  main.dart
```

## Getting started

1. Install dependencies:
   ```
   flutter pub get
   ```

2. Generate Drift + Riverpod code (needed for `*.g.dart` — re-run whenever a
   table or `@riverpod`-annotated provider changes):
   ```
   dart run build_runner build --delete-conflicting-outputs
   ```
   For active development, keep it watching:
   ```
   dart run build_runner watch --delete-conflicting-outputs
   ```

3. Run on a connected device/emulator:
   ```
   flutter run
   ```

Fonts are fetched at runtime via `google_fonts`, so no manual font files are
required.

## Roadmap

Ordered roughly by priority. Checked items are done.

### Recently shipped
- [x] Edit expense flow
- [x] Delete expense (swipe-to-delete with undo, soft delete)
- [x] Dashboard wired to real data (live monthly total + recent activity)
- [x] **Budgets** — overall monthly cap + per-category limits, with a Budgets
      screen and a real dashboard "Budget Used" card (replaced the old
      hardcoded Monthly Trajectory card).

### Next up — core tracker features
- [ ] **Filtering & search** — by date range, category, and merchant text.
- [ ] **Insights / analytics** — spending totals by category and by month, with
      charts (this is what `fl_chart` is for).

### Data durability & trust
- [ ] **Trash / recently-deleted view** — surface and restore/purge soft-deleted
      expenses (DB already supports `restoreExpense`); define a purge policy.
- [ ] **Export** — CSV / JSON (or shareable summary); the dashboard "Export"
      button is a placeholder today.
- [ ] **Backup / cloud sync** — larger effort; would introduce Firebase (Auth is
      already a declared dependency) or another backend. Treat as its own
      architectural phase (local Drift as cache + remote source of truth).

### Growth features
- [ ] **Recurring expenses** — auto-generate entries on a schedule.
- [ ] **Multi-currency per expense** — currency is currently a global setting.
- [ ] **Receipt attachments** — photo per expense; the "Scan" button is a
      placeholder today.

### Tech-debt / consistency
- [ ] Consider a thin **expense repository** (mirroring `settings_repository`)
      before analytics/budgets/filtering start duplicating query logic across
      widgets.
- [ ] Replace in-Dart monthly aggregation on the dashboard with a Drift
      `SUM(...)` aggregate query once datasets grow.

## Notes on the data layer

- All data is local-only via Drift. There is no cloud sync in the current
  version.
- Any future column/table change must bump `AppDatabase.schemaVersion` and add a
  migration step — never edit an existing table definition without also writing
  the migration, or existing users' local data can break on upgrade.
