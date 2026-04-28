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

class SignIn extends StatelessWidget {
  const SignIn({super.key});

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
                    // toggle switch
                    const SizedBox(height: 40),
                    ButtonSwitch(),

                    // username or email
                    const SizedBox(height: 20),
                    ButtonUsername(),

                    // Text Field Password
                    const SizedBox(height: 20),
                    ButtonPassword(),

                    // Buttong Login
                    const SizedBox(height: 20),
                    ButtonLogin(),

                    // Teks Sign in with
                    const SizedBox(height: 34),
                    TeksOrSignin(),

                    // social logini
                    const SizedBox(height: 14),
                    SocialLogin(),
                    // Teks Terms of Service
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
