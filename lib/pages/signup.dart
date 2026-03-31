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

class SignUp extends StatelessWidget {
  const SignUp({super.key});

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
                    // toggle switch
                    const SizedBox(height: 40),
                    ButtonSwitch(),
                    // username or email
                    const SizedBox(height: 20),
                    ButtonUsername(),
                    
                    // Text Field Password
                    const SizedBox(height: 20),
                    ButtonPassword(),

                    // Buttong Confrim
                    const SizedBox(height: 20),
                    ButtonConfrim(),

                    const SizedBox(height: 20),
                    ButtonCompany(),

                    // Teks SignUP with
                    const SizedBox(height: 20),
                    ButtonSignup(),

                    const SizedBox(height: 20,),
                    TeksOrSignUp(),

                    // social logini
                    const SizedBox(height: 15),
                    SocialLogin(),
                    // Teks Terms of Service
                    const SizedBox(height: 82,),
                    TextTerms()
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
