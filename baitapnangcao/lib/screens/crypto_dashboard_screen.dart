import 'dart:async';
import 'package:flutter/material.dart';
import '../models/crypto_coin.dart';
import '../services/crypto_api_service.dart';
import '../widgets/sparkline_chart.dart';

class CryptoDashboardScreen extends StatefulWidget {
  const CryptoDashboardScreen({super.key});

  @override
  State<CryptoDashboardScreen> createState() => _CryptoDashboardScreenState();
}

class _CryptoDashboardScreenState extends State<CryptoDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Timer? _timer;

  bool _isLoading = true;
  FetchBenchmarkResult? _benchmarkResult;
  List<CryptoCoin> _coins = [];

  // Selected JSON Tab for inspect panel
  String _selectedApiSource = 'CoinGecko API';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchData();

    // Set auto periodic refresh every 8 seconds to demonstrate real-time async streams
    _timer = Timer.periodic(const Duration(seconds: 8), (_) {
      _fetchData(silent: true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchData({bool silent = false}) async {
    if (!silent) {
      setState(() => _isLoading = true);
    }

    final result = await CryptoApiService.fetchAllDataWithBenchmark();

    if (mounted) {
      setState(() {
        _benchmarkResult = result;
        _coins = result.coins;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF13161E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B202D),
        elevation: 0,
        title: const Text(
          'NÂNG CAO 02 - Concurrency & Real-time APIs',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.amberAccent),
            tooltip: 'Re-run Concurrency Benchmark',
            onPressed: () => _fetchData(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amberAccent,
          labelColor: Colors.amberAccent,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard_rounded), text: 'Crypto UI'),
            Tab(icon: Icon(Icons.code_rounded), text: 'API & Concurrency Log'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.amberAccent),
                  SizedBox(height: 16),
                  Text(
                    'Executing Concurrent API Requests (Future.wait)...',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCryptoUiTab(),
                _buildApiConcurrencyLogTab(),
              ],
            ),
    );
  }

  // --------------------------------------------------------------------------
  // TAB 1: CRYPTO DASHBOARD UI (Matching Left Side of Slide 02)
  // --------------------------------------------------------------------------
  Widget _buildCryptoUiTab() {
    return RefreshIndicator(
      onRefresh: _fetchData,
      color: Colors.amberAccent,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Home & Banner Section
            Row(
              children: [
                const Text(
                  'Home',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('New', style: TextStyle(color: Colors.white70, fontSize: 12)),
                )
              ],
            ),
            const SizedBox(height: 12),

            // BREAKING NEWS LIVE Banner
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2C3E50), Color(0xFF000000)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 10)],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0x26448AFF),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                            color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'BREAKING NEWS',
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Real-time Market Updates Active',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Favorites Header
            const Text(
              'Favorites',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Favorites Horizontal Grid Cards (ETH & BTC)
            Row(
              children: [
                Expanded(child: _buildFavoriteCard(_coins.isNotEmpty ? _coins[0] : null, '\$0.94', '+12.49')),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFavoriteCard(
                    _coins.length > 1 ? _coins[1] : null,
                    '\$1.43',
                    '+27.46',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // All Fluctuations Header
            const Text(
              'All Fluctuations',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Fluctuations Vertical List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _coins.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final coin = _coins[index];
                final isPositive = coin.change24h >= 0;

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D2332),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      // Coin Circle Icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2B3448),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            coin.symbol.substring(0, coin.symbol.length > 2 ? 2 : coin.symbol.length),
                            style: const TextStyle(
                                color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Name & Symbol
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coin.symbol,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            coin.name,
                            style: const TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Price & % Change
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${coin.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '%${coin.change24h.toStringAsFixed(1)}',
                            style: TextStyle(
                              color: isPositive ? const Color(0xFF4CAF50) : const Color(0xFFE57373),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(CryptoCoin? coin, String priceDisplay, String changeDisplay) {
    if (coin == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1D2332),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFF2B3448),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    coin.symbol.substring(0, 1),
                    style: const TextStyle(color: Colors.cyanAccent, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                coin.symbol,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                priceDisplay,
                style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                changeDisplay,
                style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SparklineChart(
            data: coin.sparkline.isEmpty ? [1, 2, 1.5, 3, 2.8, 3.5] : coin.sparkline,
            color: const Color(0xFF4A90E2),
            height: 35,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // TAB 2: API & CONCURRENCY LOG / CODE INSPECTOR (Matching Right Side of Slide 02)
  // --------------------------------------------------------------------------
  Widget _buildApiConcurrencyLogTab() {
    final res = _benchmarkResult;
    if (res == null) return const SizedBox();

    final concurrentMs = res.concurrentDuration.inMilliseconds;
    final sequentialMs = res.sequentialDuration.inMilliseconds;
    final speedup = sequentialMs > 0 ? (sequentialMs / (concurrentMs == 0 ? 1 : concurrentMs)).toStringAsFixed(1) : '1.0';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Concurrency & Async Concepts Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1D2332),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x4DFFAB40)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Coroutines / Concurrency | Asynchronous',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Request data HTTP GET samples from 4 APIs in parallel using Future.wait\n'
                  '• Gives real-time crypto APIs with live price & open market data',
                  style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                ),
                const Divider(color: Colors.white12, height: 24),
                
                // Concurrency Benchmark Metrics
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetricCol('Parallel (Future.wait)', '${concurrentMs}ms', Colors.greenAccent),
                    _buildMetricCol('Sequential Fetch', '${sequentialMs}ms', Colors.redAccent),
                    _buildMetricCol('Speedup Factor', '${speedup}x Faster', Colors.amberAccent),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // API Source Selector Chips
          const Text(
            'Select Raw API Response JSON (Right Side of Slide):',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: res.rawJsonMap.keys.map((key) {
                final isSelected = key == _selectedApiSource;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(key),
                    selected: isSelected,
                    selectedColor: Colors.amber,
                    backgroundColor: const Color(0xFF1D2332),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedApiSource = key);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Raw JSON Code Box (Matches dark code block in screenshot)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1017),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText(
                res.rawJsonMap[_selectedApiSource] ?? '{}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: Color(0xFF80CBC4),
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCol(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
      ],
    );
  }
}
