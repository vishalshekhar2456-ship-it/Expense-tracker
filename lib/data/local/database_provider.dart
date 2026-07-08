// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'database.dart';

// /// Single shared instance of [AppDatabase] for the whole app.
// ///
// /// Feature-level DAOs/repositories should depend on this provider rather
// /// than constructing their own [AppDatabase] — keeps a single sqlite
// /// connection alive for the app's lifetime.
// final appDatabaseProvider = Provider<AppDatabase>((ref) {
//   final db = AppDatabase();
//   ref.onDispose(db.close);
//   return db;
// });
