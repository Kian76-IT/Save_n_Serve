import 'package:flutter/material.dart';
import 'package:save_n_serve/pages/auth/signin.dart';
import 'package:save_n_serve/theme.dart';
import 'package:provider/provider.dart';
import 'package:save_n_serve/controllers/auth_controller.dart';

class ButtonSignup extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isGiver;

  const ButtonSignup({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.isGiver,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 98, vertical: 41),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          // 1. Panggil Controller-nya
          final authController = Provider.of<AuthController>(context, listen: false);

          // 2. Ekstrak teks dari ketikan user (pakai .text)
          String email = emailController.text.trim();
          String password = passwordController.text.trim();
          String fullName = fullNameController.text.trim();
  
          // Kasih nama default kalau user nggak ngetik di kolom Company
          if (fullName.isEmpty) fullName = "User Baru";

          // Role is derived from the company checkbox state passed from the parent
          final role = isGiver ? 'giver' : 'receiver';

          // 3. Tembak API Register Kian!
          bool isSuccess = await authController.registerUser(
            fullName: fullName,
            email: email,
            password: password,
            role: role,
          );

          if (!context.mounted) return;

          // 4. Bikin logika if-else (isSuccess) seperti di fitur Login kemarin
          if (isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Akun Berhasil Dibuat! Silakan login.'),
                backgroundColor: Colors.green,
              ),
            );

            // Navigate to SignIn — registration does not return a session token,
            // so the user must log in to get a valid session before entering the app.
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 400),
                pageBuilder: (ctx, anim, secondaryAnim) => const SignIn(),
                transitionsBuilder: (ctx, anim, secondaryAnim, child) =>
                    FadeTransition(
                  opacity: CurvedAnimation(
                      parent: anim, curve: Curves.easeInOut),
                  child: child,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Daftar Gagal! Cek kembali datamu.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Sign Up',
            style: AppTextStyle.regularPoppins20.copyWith(
              color: background,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
