// Text helpers used to keep category names clean and typo-free.

/// Normalizes a user-typed category name: trims, collapses runs of internal
/// whitespace to a single space, and title-cases each word. Keeps stored names
/// consistent ("  coffee   shop " -> "Coffee Shop").
String normalizeCategoryName(String input) {
  final collapsed = input.trim().replaceAll(RegExp(r'\s+'), ' ');
  if (collapsed.isEmpty) return '';
  return collapsed
      .split(' ')
      .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
      .join(' ');
}

/// Levenshtein edit distance between two strings.
int levenshtein(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;

  var prev = List<int>.generate(b.length + 1, (i) => i);
  var curr = List<int>.filled(b.length + 1, 0);

  for (var i = 0; i < a.length; i++) {
    curr[0] = i + 1;
    for (var j = 0; j < b.length; j++) {
      final cost = a[i] == b[j] ? 0 : 1;
      curr[j + 1] = [
        curr[j] + 1, // insertion
        prev[j + 1] + 1, // deletion
        prev[j] + cost, // substitution
      ].reduce((m, e) => e < m ? e : m);
    }
    final tmp = prev;
    prev = curr;
    curr = tmp;
  }
  return prev[b.length];
}

/// Returns the [candidates] entry that is a likely-intended match for [input]
/// (a near-miss typo), or null if none is close enough. Exact
/// (case-insensitive) matches return null — those are handled as duplicates,
/// not suggestions. Threshold scales down for very short words so we don't
/// suggest wildly different names.
String? closestMatch(String input, Iterable<String> candidates) {
  final needle = input.trim().toLowerCase();
  if (needle.isEmpty) return null;

  final maxDistance = needle.length <= 4 ? 1 : 2;

  String? best;
  var bestDistance = maxDistance + 1;

  for (final candidate in candidates) {
    final other = candidate.trim().toLowerCase();
    if (other == needle) return null; // exact -> duplicate, not a suggestion
    final d = levenshtein(needle, other);
    if (d > 0 && d <= maxDistance && d < bestDistance) {
      bestDistance = d;
      best = candidate;
    }
  }
  return best;
}
