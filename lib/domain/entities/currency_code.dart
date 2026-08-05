enum CurrencyCode {
  gbp,
  usd,
  eur;

  String get symbol {
    switch (this) {
      case CurrencyCode.gbp:
        return '£';
      case CurrencyCode.usd:
        return '\$';
      case CurrencyCode.eur:
        return '€';
    }
  }
}
