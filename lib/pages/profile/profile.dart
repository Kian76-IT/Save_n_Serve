import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_n_serve/controllers/auth_controller.dart';
import 'package:save_n_serve/pages/auth/signin.dart';
import 'package:save_n_serve/services/session_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _selectedGender;
  String? _selectedBirth;

  bool _isLoading = false;
  String _role = '';
  int _totalPoints = 0;
  String _giverLevel = '';

  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _usernameCtrl;
  late TextEditingController _emailCtrl;
  final TextEditingController _phoneCtrl = TextEditingController();

  static const _genders = ['Pria', 'Wanita', 'Prefer not to say'];
  static const _birthYears = [
    '1990', '1991', '1992', '1993', '1994', '1995',
    '1996', '1997', '1998', '1999', '2000', '2001',
    '2002', '2003', '2004', '2005', '2006',
  ];

  @override
  void initState() {
    super.initState();
    final name = SessionService.fullName ?? '';
    final parts = name.split(' ');
    _firstNameCtrl = TextEditingController(text: parts.isNotEmpty ? parts.first : '');
    _lastNameCtrl = TextEditingController(
        text: parts.length > 1 ? parts.sublist(1).join(' ') : '');
    _usernameCtrl = TextEditingController(
        text: name.isNotEmpty
            ? '@${name.toLowerCase().replaceAll(' ', '')}'
            : '');
    _emailCtrl = TextEditingController(text: SessionService.email ?? '');
    _role = SessionService.role ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchProfile());
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchProfile() async {
    setState(() => _isLoading = true);
    final authController = Provider.of<AuthController>(context, listen: false);
    final profile = await authController.fetchProfile();
    if (!mounted) return;
    if (profile != null) {
      final name = profile['full_name'] as String? ?? '';
      final parts = name.split(' ');
      _firstNameCtrl.text = parts.isNotEmpty ? parts.first : '';
      _lastNameCtrl.text =
          parts.length > 1 ? parts.sublist(1).join(' ') : '';
      _usernameCtrl.text = name.isNotEmpty
          ? '@${name.toLowerCase().replaceAll(' ', '')}'
          : '';
      _role = profile['role'] as String? ?? _role;
      _totalPoints = (profile['total_points'] as num?)?.toInt() ?? 0;
      _giverLevel = profile['giver_level'] as String? ?? '';
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE3E3),

      body: Stack(
        children: [

          // BACKGROUND DECORATIONS
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                color: Color(0xFFFFA726),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            top: -40,
            right: 40,
            child: Transform.rotate(
              angle: 0.7,
              child: Container(width: 40, height: 300, color: Colors.green),
            ),
          ),

          Positioned(
            bottom: -100,
            left: -50,
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                color: Color(0xFFFFA726),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: -40,
            left: 50,
            child: Transform.rotate(
              angle: 0.7,
              child: Container(width: 40, height: 300, color: Colors.green),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                if (_isLoading)
                  const LinearProgressIndicator(
                    minHeight: 2,
                    backgroundColor: Colors.transparent,
                    color: Color(0xFFFFA726),
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _fetchProfile,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [

                          const SizedBox(height: 30),

                          // PROFILE IMAGE + EDIT PHOTO BUTTON
                          Stack(
                            children: [

                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.person_outline,
                                  size: 50,
                                  color: Colors.black54,
                                ),
                              ),

                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: () =>
                                      ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Fitur ganti foto dalam pengembangan'),
                                    ),
                                  ),
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // GIVER-ONLY: points & level card
                          if (_role == 'giver') ...[
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 24),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatTile(
                                    icon: Icons.star_rounded,
                                    iconColor: const Color(0xFFFFA726),
                                    label: 'Total Points',
                                    value: '$_totalPoints',
                                  ),
                                  Container(
                                      width: 1,
                                      height: 40,
                                      color: Colors.black12),
                                  _buildStatTile(
                                    icon: Icons.emoji_events_rounded,
                                    iconColor: Colors.green,
                                    label: 'Level',
                                    value: _giverLevel.isNotEmpty
                                        ? _giverLevel
                                        : '-',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // FORM CARD
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                ),
                              ],
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                const Center(
                                  child: Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                _buildTextField('First Name', 'First Name',
                                    controller: _firstNameCtrl),
                                _buildTextField('Last Name', 'Last Name',
                                    controller: _lastNameCtrl),
                                _buildTextField('Username', 'Username',
                                    controller: _usernameCtrl),
                                _buildTextField('Email', 'Email',
                                    controller: _emailCtrl),
                                _buildTextField(
                                    'Phone Number', '+62  xxx xxxx xxxx',
                                    controller: _phoneCtrl),

                                _buildDropdown(
                                  'Birth Year',
                                  _selectedBirth,
                                  _birthYears,
                                  (v) => setState(() => _selectedBirth = v),
                                ),

                                _buildDropdown(
                                  'Gender',
                                  _selectedGender,
                                  _genders,
                                  (v) => setState(() => _selectedGender = v),
                                ),

                                const SizedBox(height: 30),

                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () =>
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Fitur ganti password dalam pengembangan'),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Change Password',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(Icons.lock,
                                            color: Colors.white, size: 18),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // LOGOUT BUTTON
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(
                                      color: Colors.red, width: 1.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () => _confirmLogout(context),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.logout,
                                        color: Colors.red, size: 18),
                                    SizedBox(width: 10),
                                    Text(
                                      'Logout',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }

  void _confirmLogout(BuildContext context) {
    final authController =
        Provider.of<AuthController>(context, listen: false);
    final navigator = Navigator.of(context);

    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar dari akun?'),
        content:
            const Text('Kamu akan diarahkan kembali ke halaman login.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed != true || !mounted) return;
      await authController.logoutUser();
      if (!mounted) return;
      navigator.pushAndRemoveUntil(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (ctx, anim, secondaryAnim) => const SignIn(),
          transitionsBuilder: (ctx, anim, secondaryAnim, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
        (route) => false,
      );
    });
  }

  Widget _buildTextField(String title, String hint,
      {TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDropdown(
    String title,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: const Text('Select'),
              isExpanded: true,
              onChanged: onChanged,
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
