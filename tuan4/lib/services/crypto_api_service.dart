import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crypto_coin.dart';

class FetchBenchmarkResult {
  final List<CryptoCoin> coins;
  final Duration concurrentDuration;
  final Duration sequentialDuration;
  final Map<String, String> rawJsonMap;

  FetchBenchmarkResult({
    required this.coins,
    required this.concurrentDuration,
    required this.sequentialDuration,
    required this.rawJsonMap,
  });
}

class CryptoApiService {
  static const String coinGeckoUrl =
      'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,litecoin,monero&vs_currencies=usd&include_24hr_change=true';

  static const String binanceBtcUrl =
      'https://api.binance.com/api/v3/ticker/24hr?symbol=BTCUSDT';

  static const String cryptoCompareUrl =
      'https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,ETH&tsyms=USD';

  static const String krakenUrl =
      'https://api.kraken.com/0/public/Ticker?pair=XBTUSD';

  static Future<FetchBenchmarkResult> fetchAllDataWithBenchmark() async {
    final stopwatchConcurrent = Stopwatch()..start();
    final futures = [
      _safeHttpGet(coinGeckoUrl),
      _safeHttpGet(binanceBtcUrl),
      _safeHttpGet(cryptoCompareUrl),
      _safeHttpGet(krakenUrl),
    ];

    final responses = await Future.wait(futures);
    stopwatchConcurrent.stop();
    final concurrentDuration = stopwatchConcurrent.elapsed;

    final rawJsonMap = <String, String>{
      'CoinGecko API': _prettyJson(responses[0]),
      'Binance API': _prettyJson(responses[1]),
      'CryptoCompare API': _prettyJson(responses[2]),
      'Kraken API': _prettyJson(responses[3]),
    };

    final stopwatchSequential = Stopwatch()..start();
    await _safeHttpGet(coinGeckoUrl);
    await _safeHttpGet(binanceBtcUrl);
    await _safeHttpGet(cryptoCompareUrl);
    await _safeHttpGet(krakenUrl);
    stopwatchSequential.stop();
    final sequentialDuration = stopwatchSequential.elapsed;

    final coins = _parseCoins(responses[0], responses[1], responses[2]);

    return FetchBenchmarkResult(
      coins: coins,
      concurrentDuration: concurrentDuration,
      sequentialDuration: sequentialDuration,
      rawJsonMap: rawJsonMap,
    );
  }

  static Future<String?> _safeHttpGet(String url) async {
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 6));
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (_) {}
    return null;
  }

  static String _prettyJson(String? raw) {
    if (raw == null || raw.isEmpty) {
      return '{\n  "status": "Offline / Using Fallback Mock Data"\n}';
    }
    try {
      final decoded = json.decode(raw);
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(decoded);
    } catch (_) {
      return raw;
    }
  }

  static List<CryptoCoin> _parseCoins(
      String? coinGeckoRaw, String? binanceRaw, String? cryptoCompareRaw) {
    Map<String, dynamic>? cgJson;
    if (coinGeckoRaw != null) {
      try {
        cgJson = json.decode(coinGeckoRaw);
      } catch (_) {}
    }

    final defaultCoins = [
      CryptoCoin(
        id: 'ethereum',
        symbol: 'ETH',
        name: 'Ethereum',
        price: 1245.34,
        change24h: 0.9,
        sparkline: [1200, 1220, 1210, 1235, 1240, 1245.34],
      ),
      CryptoCoin(
        id: 'bitcoin',
        symbol: 'BTC',
        name: 'Bitcoin',
        price: 3451.12,
        change24h: 1.4,
        sparkline: [3300, 3350, 3400, 3420, 3451.12],
      ),
      CryptoCoin(
        id: 'litecoin',
        symbol: 'LTC',
        name: 'Litecoin',
        price: 2125.68,
        change24h: 1.2,
        sparkline: [2100, 2110, 2105, 2120, 2125.68],
      ),
      CryptoCoin(
        id: 'monero',
        symbol: 'XMR',
        name: 'Monero',
        price: 120.45,
        change24h: 0.3,
        sparkline: [118, 119, 119.5, 120.0, 120.45],
      ),
    ];

    if (cgJson == null) return defaultCoins;

    List<CryptoCoin> result = [];
    final coinConfigs = [
      {'id': 'ethereum', 'symbol': 'ETH', 'name': 'Ethereum'},
      {'id': 'bitcoin', 'symbol': 'BTC', 'name': 'Bitcoin'},
      {'id': 'litecoin', 'symbol': 'LTC', 'name': 'Litecoin'},
      {'id': 'monero', 'symbol': 'XMR', 'name': 'Monero'},
    ];

    for (var cfg in coinConfigs) {
      final coinId = cfg['id']!;
      if (cgJson.containsKey(coinId)) {
        result.add(CryptoCoin.fromJsonCoinGecko(cgJson, coinId, cfg['symbol']!, cfg['name']!));
      } else {
        result.add(defaultCoins.firstWhere((element) => element.id == coinId));
      }
    }

    return result.isEmpty ? defaultCoins : result;
  }
}
