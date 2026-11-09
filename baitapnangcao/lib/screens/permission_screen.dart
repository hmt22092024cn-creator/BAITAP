import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/permission_service.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  // Selected language simulation
  String _currentLang = 'ENG';

  final List<PermissionCardData> _cards = [
    PermissionCardData(
      type: CustomPermissionType.location,
      title: 'Location',
      description: 'Allow maps to access your location while you use the app?',
      buttonText: 'Allow',
      iconData: Icons.location_on_rounded,
      iconColor: const Color(0xFFE05638),
      bgColor: const Color(0xFFE2F3EC),
    ),
    PermissionCardData(
      type: CustomPermissionType.notification,
      title: 'Notification',
      description: 'Please enable notifications to receive updates and reminders',
      buttonText: 'Turn on',
      iconData: Icons.notifications_active_rounded,
      iconColor: const Color(0xFFF1AC33),
      bgColor: const Color(0xFFFEF8E7),
    ),
    PermissionCardData(
      type: CustomPermissionType.camera,
      title: 'Camera',
      description: 'We need access to your camera to scan QR codes',
      buttonText: 'Turn on',
      iconData: Icons.camera_alt_rounded,
      iconColor: const Color(0xFFE05638),
      bgColor: const Color(0xFFE6F5EE),
    ),
  ];

  final Map<CustomPermissionType, PermissionStatus> _permissionStatuses = {};

  @override
  void initState() {
    super.initState();
    _checkInitialPermissions();
  }

  Future<void> _checkInitialPermissions() async {
    for (var card in _cards) {
      final status = await PermissionService.checkPermission(card.type);
      if (mounted) {
        setState(() {
          _permissionStatuses[card.type] = status;
        });
      }
    }
  }

  Future<void> _handlePermissionRequest(PermissionCardData card) async {
    final status = await PermissionService.requestPermission(card.type);
    if (mounted) {
      setState(() {
        _permissionStatuses[card.type] = status;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${card.title} Permission: ${status.name.toUpperCase()}'),
          backgroundColor: status.isGranted ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );

      // Auto advance to next card if available
      if (_currentPage < _cards.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _skipCard() {
    if (_currentPage < _cards.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All permissions reviewed!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Stack(
        children: [
          // Background dark backdrop gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E2332), Color(0xFF0D1017)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Main Layout
          SafeArea(
            child: Column(
              children: [
                // Top App Bar Header (Matches slide header 16:54 & ENG switcher)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Text(
                        'NÂNG CAO 01',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '16:54',
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      // Language Selector Switcher pill
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: const Color(0x66000000),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => _currentLang = 'বাংলা'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _currentLang == 'বাংলা' ? Colors.orange : Colors.transparent,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  'বাং',
                                  style: TextStyle(
                                    color: _currentLang == 'বাংলা' ? Colors.white : Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _currentLang = 'ENG'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _currentLang == 'ENG' ? const Color(0xFFE05638) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  'ENG',
                                  style: TextStyle(
                                    color: _currentLang == 'ENG' ? Colors.white : Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Page Indicator Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _cards.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? const Color(0xFFE05638) : Colors.white38,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Middle Permission Dialog Cards Carousel
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (idx) => setState(() => _currentPage = idx),
                    itemCount: _cards.length,
                    itemBuilder: (context, index) {
                      final card = _cards[index];
                      final status = _permissionStatuses[card.type];
                      final isGranted = status?.isGranted ?? false;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x4D000000),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            // Custom Illustrated Icon Container
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                color: card.bgColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: card.bgColor.withAlpha(128),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    Icon(
                                      card.iconData,
                                      size: 50,
                                      color: card.iconColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Permission Title
                            Text(
                              card.title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E2332),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Subtitle description
                            Text(
                              card.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: Colors.grey.shade600,
                              ),
                            ),

                            if (status != null) ...[
                              const SizedBox(height: 12),
                              Chip(
                                label: Text(
                                  isGranted ? 'GRANTED' : 'DENIED / NOT REQUESTED',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isGranted ? Colors.green.shade800 : Colors.deepOrange.shade800,
                                  ),
                                ),
                                backgroundColor: isGranted ? Colors.green.shade50 : Colors.orange.shade50,
                                side: BorderSide.none,
                              ),
                            ],

                            const SizedBox(height: 16),

                            // Primary Action Button (Allow / Turn on)
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () => _handlePermissionRequest(card),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE05638),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child: Text(
                                  card.buttonText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Secondary Action Button (Skip for now)
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: OutlinedButton(
                                onPressed: _skipCard,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFE05638), width: 1.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child: const Text(
                                  'Skip for now',
                                  style: TextStyle(
                                    color: Color(0xFFE05638),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      );
                    },
                  ),
                ),

                // Bottom Login / Continue Buttons (As depicted at bottom of screen 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Login Pressed')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5C3328),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Continuing without account')),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF5C3328), width: 1.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Continue without account',
                            style: TextStyle(color: Colors.white60, fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PermissionCardData {
  final CustomPermissionType type;
  final String title;
  final String description;
  final String buttonText;
  final IconData iconData;
  final Color iconColor;
  final Color bgColor;

  PermissionCardData({
    required this.type,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.iconData,
    required this.iconColor,
    required this.bgColor,
  });
}
