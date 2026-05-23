import 'package:flutter/material.dart';
import 'package:save_n_serve/components/signUp/social_login.dart';
import 'package:save_n_serve/components/signup/button_company.dart';
import 'package:save_n_serve/components/signup/button_password.dart';
import 'package:save_n_serve/components/signup/button_signup.dart';
import 'package:save_n_serve/components/signup/button_switch.dart';
import 'package:save_n_serve/components/signup/button_username.dart';
import 'package:save_n_serve/components/signup/button_confrim.dart'; 
import 'package:save_n_serve/components/signup/text_or_sign.dart';
import 'package:save_n_serve/components/signup/header.dart';
import 'package:save_n_serve/components/signup/text_terms.dart';
import 'package:save_n_serve/theme.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // 1. SIAPKAN KABEL PENANGKAP TEKS DI SINI
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isGiver = false;

  @override
  void dispose() {
    // Bersihkan memori saat halaman ditutup
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accent,
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
                    // 2. KARENA BUTTON_USERNAME UDAH ADA COLOKANNYA, LANGSUNG PASANG
                    ButtonUsername(controller: emailController),

                    const SizedBox(height: 20),
                    // 3. SEPERTI USERNAME, PASANG JUGA KE PASSWORD
                    ButtonPassword(controller: passwordController),

                    const SizedBox(height: 20),
                    // 4. KITA OPER KE COFRIM (Nanti file ini bakal merah, wajar!)
                    ButtonConfrim(controller: confirmPasswordController),

                    const SizedBox(height: 20),
                    // 5. OPER KE NAMA PERUSAHAAN / FULL NAME (Bakal merah juga!)
                    ButtonCompany(
                      controller: fullNameController,
                      onToggle: (v) => setState(() => _isGiver = v),
                    ),

                    const SizedBox(height: 20),
                    // 6. OPER SEMUA CONTROLLER KE TOMBOL EKSEKUSI UTAMA (Bakal merah!)
                    ButtonSignup(
                      fullNameController: fullNameController,
                      emailController: emailController,
                      passwordController: passwordController,
                      isGiver: _isGiver,
                    ),

                    const SizedBox(height: 20),
                    TeksOrSignUp(),

                    const SizedBox(height: 15),
                    SocialLogin(),
                    
                    const SizedBox(height: 82),
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