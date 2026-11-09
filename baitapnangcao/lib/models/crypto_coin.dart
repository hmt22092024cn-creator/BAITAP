class CryptoCoin {
  final String id;
  final String symbol;
  final String name;
  final double price;
  final double change24h;
  final String iconUrl;
  final List<double> sparkline;
  final String apiSource;

  CryptoCoin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change24h,
    this.iconUrl = '',
    this.sparkline = const [],
    this.apiSource = 'Aggregated',
  });

  factory CryptoCoin.fromJsonCoinGecko(Map<String, dynamic> json, String coinId, String coinSymbol, String coinName) {
    final coinData = json[coinId] ?? {};
    final price = (coinData['usd'] ?? 0.0).toDouble();
    final change = (coinData['usd_24h_change'] ?? 0.0).toDouble();

    return CryptoCoin(
      id: coinId,
      symbol: coinSymbol,
      name: coinName,
      price: price,
      change24h: change,
      apiSource: 'CoinGecko API',
      sparkline: [price * 0.95, price * 0.98, price * 0.94, price * 0.99, price * 1.01, price],
    );
  }

  factory CryptoCoin.fromJsonBinance(Map<String, dynamic> json) {
    final symbol = json['symbol'] ?? 'BTCUSDT';
    final price = double.tryParse(json['lastPrice']?.toString() ?? '0') ?? 0.0;
    final change = double.tryParse(json['priceChangePercent']?.toString() ?? '0') ?? 0.0;

    return CryptoCoin(
      id: symbol.toLowerCase(),
      symbol: symbol.replaceAll('USDT', ''),
      name: symbol.replaceAll('USDT', ''),
      price: price,
      change24h: change,
      apiSource: 'Binance API',
      sparkline: [price * 0.97, price * 0.96, price * 0.98, price * 0.99, price],
    );
  }
}
