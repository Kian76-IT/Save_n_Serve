import 'package:flutter/material.dart';
import 'package:save_n_serve/pages/auth/signup.dart';
// ─────────────────────────────────────────
// CONSTANTS
// ─────────────────────────────────────────
const kGreen     = Color(0xFF2A6B35);
const kGreenDark = Color(0xFF1E4D25);
const kOrange    = Color(0xFFF5A31A);
const kGrey      = Color(0xFF555B52);

// ─────────────────────────────────────────
// SPLASH SCREEN — Flow 14
// ─────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _slideCtrl;
  late Animation<double>    _slideAnim;

  late AnimationController _rotCtrl;
  late Animation<double>    _rotAnim;

  late AnimationController _splitCtrl;
  late Animation<double>    _splitAnim;

  late AnimationController _logoCtrl;
  late Animation<double>    _logoAnim;

  @override
  void initState() {
    super.initState();

    _slideCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _slideAnim = CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut);

    _rotCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _rotAnim = CurvedAnimation(parent: _rotCtrl, curve: Curves.easeInOut);

    _splitCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _splitAnim = CurvedAnimation(parent: _splitCtrl, curve: Curves.easeInOut);

    _logoCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _logoAnim = CurvedAnimation(parent: _logoCtrl, curve: Curves.easeIn);

    _run();
  }

  Future<void> _run() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _slideCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    await _rotCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    await _splitCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    await _logoCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const OnboardingScreen(),
          transitionsBuilder: (_, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    _rotCtrl.dispose();
    _splitCtrl.dispose();
    _logoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: Listenable.merge([_slideCtrl, _rotCtrl, _splitCtrl, _logoCtrl]),
        builder: (context, _) {
          return _SplashPainter(
            slideProgress: _slideAnim.value,
            rotProgress:   _rotAnim.value,
            splitProgress: _splitAnim.value,
            logoProgress:  _logoAnim.value,
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────
// SPLASH PAINTER WIDGET
// ─────────────────────────────────────────
class _SplashPainter extends StatelessWidget {
  final double slideProgress;
  final double rotProgress;
  final double splitProgress;
  final double logoProgress;

  const _SplashPainter({
    required this.slideProgress,
    required this.rotProgress,
    required this.splitProgress,
    required this.logoProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          painter: _StripesPainter(
            slideProgress: slideProgress,
            rotProgress:   rotProgress,
            splitProgress: splitProgress,
          ),
        ),
        Opacity(
          opacity: logoProgress,
          child: Center(
            child: Image.asset(
              'assets/logo/Logo_Save_n_Serve.png',
              width: 300,
              height: 300,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// STRIPES CUSTOM PAINTER
// ─────────────────────────────────────────
class _StripesPainter extends CustomPainter {
  final double slideProgress;
  final double rotProgress;
  final double splitProgress;

  _StripesPainter({
    required this.slideProgress,
    required this.rotProgress,
    required this.splitProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (slideProgress == 0) return;

    final w = size.width;
    final h = size.height;

    final greenW  = w * 1.0;
    final whiteW  = w * 0.1;
    final orangeW = w * 1.0;

    final totalW = greenW + whiteW + orangeW;
    final startX = (w - totalW) / 2;

    final gX = startX;
    final wX = startX + greenW;
    final oX = startX + greenW + whiteW;

    final stripeH     = h * 1.5 * slideProgress;
    final topY        = (h - stripeH) / 2;
    final angle       = rotProgress * 0.48;
    final maxShift    = w * 1.2;
    final greenShift  = -splitProgress * maxShift;
    final orangeShift =  splitProgress * maxShift;

    canvas.save();
    if (splitProgress == 0) {
      canvas.clipRect(Rect.fromLTWH(0, 0, w, h));
    }

    _drawStripe(canvas, left: gX + greenShift, top: topY,
        stripeW: greenW,  stripeH: stripeH, color: kGreen,
        angle: angle, cx: w / 2, cy: h / 2);

    _drawStripe(canvas, left: wX, top: topY,
        stripeW: whiteW, stripeH: stripeH, color: Colors.white,
        angle: angle, cx: w / 2, cy: h / 2);

    _drawStripe(canvas, left: oX + orangeShift, top: topY,
        stripeW: orangeW, stripeH: stripeH, color: kOrange,
        angle: angle, cx: w / 2, cy: h / 2);

    canvas.restore();
  }

  void _drawStripe(Canvas canvas, {
    required double left,
    required double top,
    required double stripeW,
    required double stripeH,
    required Color  color,
    required double angle,
    required double cx,
    required double cy,
  }) {
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(angle);
    canvas.translate(-cx, -cy);
    canvas.drawRect(Rect.fromLTWH(left, top, stripeW, stripeH), Paint()..color = color);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_StripesPainter old) =>
      old.slideProgress != slideProgress ||
          old.rotProgress   != rotProgress   ||
          old.splitProgress != splitProgress;
}

// ─────────────────────────────────────────
// ONBOARDING DATA MODEL
// ─────────────────────────────────────────
class _OnboardingData {
  final String imagePath;
  final String title;
  final String description;

  const _OnboardingData({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

final List<_OnboardingData> _onboardingPages = [
  const _OnboardingData(
    imagePath: 'assets/images/Splash1.png',
    title: '"Setiap Makanan Berarti"',
    description:
    'Masih banyak makanan layak konsumsi yang terbuang, sementara banyak orang membutuhkannya.',
  ),
  const _OnboardingData(
    imagePath: 'assets/images/Splash2.png',
    title: '"Donasikan, Jangan Buang"',
    description:
    'Hubungkan makanan berlebihmu dengan mereka yang membutuhkan secara cepat dan mudah.',
  ),
  const _OnboardingData(
    imagePath: 'assets/images/Splash3.png',
    title: '"Temukan Bantuan di Sekitarmu"',
    description:
    'Di sekitarmu, ada makanan layak konsumsi yang dibagikan oleh orang-orang yang peduli. '
        'Kamu bisa menemukannya dengan mudah melalui aplikasi ini.',
  ),
  const _OnboardingData(
    imagePath: 'assets/images/Splash4.png',
    title: '"Kebaikan yang Menguatkan"',
    description:
    'Setiap makanan yang dibagikan adalah bentuk kepedulian kita semua untuk saling menguatkan.',
  ),
  const _OnboardingData(
    imagePath: '',
    title: '',
    description:
    '"Di dunia ini banyak orang baik dan jika kamu tidak menemukannya, maka jadilah salah satunya"',
  ),
];

// ─────────────────────────────────────────
// ONBOARDING SCREEN — Flow 15
// ─────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {

  final PageController _pageCtrl = PageController();
  int _currentPage = 0;

  late AnimationController _fadeCtrl;
  late Animation<double>    _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      value: 1.0,
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _goToPage(int page) async {
    await _fadeCtrl.reverse();
    setState(() => _currentPage = page);
    await _pageCtrl.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _fadeCtrl.forward();
  }

  void _next() {
    if (_currentPage < _onboardingPages.length - 1) {
      _goToPage(_currentPage + 1);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => SignUp()),
      );
    }
  }

  void _skip() => _goToPage(_onboardingPages.length - 1);

  bool get _isLast => _currentPage == _onboardingPages.length - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Skip button ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: AnimatedOpacity(
                  opacity: _isLast ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: TextButton(
                    onPressed: _isLast ? null : _skip,
                    child: const Text(
                      'Lewati',
                      style: TextStyle(
                        color: kGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Page content ──
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _onboardingPages.length,
                itemBuilder: (context, index) => FadeTransition(
                  opacity: _fadeAnim,
                  child: _OnboardingPage(data: _onboardingPages[index]),
                ),
              ),
            ),

            // ── Dot indicator ──
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_onboardingPages.length, (i) {
                  final active = i == _currentPage;
                  return GestureDetector(
                    onTap: () => _goToPage(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 28 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: active ? kOrange : const Color(0xFFD1E8D5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // ── CTA Button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _isLast ? 'Mulai Sekarang' : 'Selanjutnya',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// SINGLE ONBOARDING PAGE
// ─────────────────────────────────────────
class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;
  const _OnboardingPage({required this.data});

  bool get _isClosing => data.imagePath.isEmpty && data.title.isEmpty;

  @override
  Widget build(BuildContext context) =>
      _isClosing ? _buildClosing() : _buildNormal();

  Widget _buildNormal() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 220,
            height: 220,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF5F9F5),
            ),
            child: ClipOval(
              child: Image.asset(
                data.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const _Placeholder(),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: kGreenDark,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: kGrey,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClosing() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Center(
        child: Text(
          data.description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            color: kGreenDark,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// PLACEHOLDER IMAGE
// ─────────────────────────────────────────
class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F7F1),
      child: const Icon(Icons.image_outlined, size: 64, color: Color(0xFFB2CDB8)),
    );
  }
}