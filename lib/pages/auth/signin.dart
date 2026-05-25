import 'package:flutter/material.dart';
import 'package:save_n_serve/components/signin/button_login.dart';
import 'package:save_n_serve/components/signin/header.dart';
import 'package:save_n_serve/components/signin/button_switch.dart';
import 'package:save_n_serve/components/signin/button_username.dart';
import 'package:save_n_serve/components/signin/button_password.dart';
import 'package:save_n_serve/components/signin/social_login.dart';
import 'package:save_n_serve/components/signin/teks_or_signin.dart';
import 'package:save_n_serve/components/signin/text_terms.dart';
import 'package:save_n_serve/theme.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // 1. KITA BIKIN MESIN PENANGKAP TEKS DI SINI
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Bersihkan memori kalau halaman ditutup
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Header(),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 200,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    ButtonSwitch(),

                    const SizedBox(height: 20),
                    // 2. MASUKIN CONTROLLER KE DALAM KOLOM EMAIL
                    ButtonUsername(controller: emailController),

                    const SizedBox(height: 20),
                    // 3. MASUKIN CONTROLLER KE DALAM KOLOM PASSWORD
                    ButtonPassword(controller: passwordController),

                    const SizedBox(height: 20),
                    // 4. MASUKIN CONTROLLER KE DALAM TOMBOL LOGIN!
                    ButtonLogin(
                      emailController: emailController,
                      passwordController: passwordController,
                    ),

                    const SizedBox(height: 34),
                    TeksOrSignin(),

                    const SizedBox(height: 14),
                    SocialLogin(),
                    
                    const SizedBox(height: 100),
                    TextTerms(),
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