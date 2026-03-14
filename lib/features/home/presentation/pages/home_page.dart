import 'package:flutter/material.dart';
import 'package:nalargizi/features/dashboard/presentation/pages/dashboard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PageController _pageController;
  int _currentIndex = 0;

  final List<_OnboardingItem> _items = const [
    _OnboardingItem(
      color: Color(0xFFF43F5E),
      icon: Icons.child_care,
      title: 'Selamat Datang di\nTumbuhKu',
      description:
          'Aplikasi monitoring pertumbuhan bayi yang membantu orang tua memantau perkembangan anak dengan mudah dan akurat.',
      primaryButtonLabel: 'Lanjut',
    ),
    _OnboardingItem(
      color: Color(0xFF3B82F6),
      icon: Icons.equalizer,
      title: 'Kurva Pertumbuhan\nWHO',
      description:
          'Lacak berat dan tinggi badan anak Anda dengan grafik interaktif berdasarkan standar WHO. Dapatkan Z-score secara otomatis.',
      primaryButtonLabel: 'Lanjut',
    ),
    _OnboardingItem(
      color: Color(0xFF10B981),
      icon: Icons.favorite_border,
      title: 'Jurnal Nutrisi\nHarian',
      description:
          'Catat asupan nutrisi dan hidrasi anak Anda. Pantau kalori dan pola makan untuk tumbuh kembang optimal.',
      primaryButtonLabel: 'Lanjut',
    ),
    _OnboardingItem(
      color: Color(0xFF8B5CF6),
      icon: Icons.event_note,
      title: 'Jadwal Posyandu &\nImunisasi',
      description:
          'Jangan lewatkan jadwal posyandu dan imunisasi. Dapatkan pengingat dan lacak progress kesehatan anak.',
      primaryButtonLabel: 'Mulai Sekarang',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToDashboard(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const DashboardPage()));
  }

  void _goNext() {
    if (_currentIndex == _items.length - 1) {
      _goToDashboard(context);
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  void _goBack() {
    if (_currentIndex == 0) {
      return;
    }

    _pageController.previousPage(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = _items[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 12,
              color: item.color,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _goToDashboard(context),
                        child: Text(
                          'Lewati',
                          style: TextStyle(
                            color: item.color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _items.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final page = _items[index];

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 112,
                                height: 112,
                                decoration: BoxDecoration(
                                  color: page.color,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x22000000),
                                      blurRadius: 16,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  page.icon,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                              const SizedBox(height: 36),
                              Text(
                                page.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 42 / 2,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F1E3B),
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 22),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  page.description,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF334C6B),
                                    height: 1.55,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 34),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(_items.length, (
                                  dotIndex,
                                ) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: _OnboardingDot(
                                      isActive: dotIndex == _currentIndex,
                                      activeColor: item.color,
                                    ),
                                  );
                                }),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        if (_currentIndex > 0)
                          Container(
                            width: 58,
                            height: 58,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE2E8F0),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: _goBack,
                              icon: const Icon(
                                Icons.chevron_left,
                                color: Color(0xFF64748B),
                                size: 30,
                              ),
                            ),
                          ),
                        Expanded(
                          child: SizedBox(
                            height: 60,
                            child: FilledButton(
                              onPressed: _goNext,
                              style: FilledButton.styleFrom(
                                backgroundColor: item.color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item.primaryButtonLabel,
                                    style: const TextStyle(
                                      fontSize: 32 / 2,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.chevron_right, size: 24),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingDot extends StatelessWidget {
  final bool isActive;
  final Color activeColor;

  const _OnboardingDot({
    this.isActive = false,
    this.activeColor = const Color(0xFFF43F5E),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isActive ? 30 : 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? activeColor : const Color(0xFFCBD5E1),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}

class _OnboardingItem {
  final Color color;
  final IconData icon;
  final String title;
  final String description;
  final String primaryButtonLabel;

  const _OnboardingItem({
    required this.color,
    required this.icon,
    required this.title,
    required this.description,
    required this.primaryButtonLabel,
  });
}
