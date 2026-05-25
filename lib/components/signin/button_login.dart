import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import 'package:save_n_serve/theme.dart';
import 'package:save_n_serve/pages/home/home_tab.dart';
import 'package:save_n_serve/pages/home/main_page_giver.dart';

class ButtonLogin extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const ButtonLogin({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 27),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          final authController =
              Provider.of<AuthController>(context, listen: false);

          final String? role = await authController.loginUser(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

          if (!context.mounted) return;

          if (role == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login Gagal! Cek kembali email & password lo.'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          // Route strictly by the role returned from the backend
          final destination = role == 'giver'
              ? const MainPageGiver()
              : const MainPageBene();

          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (ctx, anim, secondaryAnim) => destination,
              transitionsBuilder: (ctx, anim, secondaryAnim, child) =>
                  FadeTransition(
                opacity:
                    CurvedAnimation(parent: anim, curve: Curves.easeInOut),
                child: child,
              ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Login',
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
