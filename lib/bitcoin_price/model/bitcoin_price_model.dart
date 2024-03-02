class BitcoinPriceModel {
  final String currency;
  final String symbol;
  final double rate;
  final String description;

  BitcoinPriceModel({
    required this.currency,
    required this.symbol,
    required this.rate,
    required this.description,
  });

  factory BitcoinPriceModel.fromJson(Map<String, dynamic> json) {
    return BitcoinPriceModel(
      currency: json['code'],
      symbol: json['symbol'],
      rate: json['rate_float'],
      description: json['description'],
    );
  }
}
