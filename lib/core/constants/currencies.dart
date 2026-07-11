class Currency {
  final String code; // ISO 4217, e.g. 'INR'
  final String name; // e.g. 'Indian Rupee'

  const Currency({required this.code, required this.name});
}

const List<Currency> kSupportedCurrencies = [
  Currency(code: 'INR', name: 'Indian Rupee'),
  Currency(code: 'USD', name: 'US Dollar'),
  Currency(code: 'EUR', name: 'Euro'),
  Currency(code: 'GBP', name: 'British Pound'),
  Currency(code: 'AED', name: 'UAE Dirham'),
  Currency(code: 'SGD', name: 'Singapore Dollar'),
  Currency(code: 'AUD', name: 'Australian Dollar'),
  Currency(code: 'CAD', name: 'Canadian Dollar'),
  Currency(code: 'JPY', name: 'Japanese Yen'),
];
