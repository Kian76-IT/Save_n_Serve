import 'package:flutter/material.dart';

class SubmitSuccessPage extends StatelessWidget {
  const SubmitSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              width: 140,
              height: 140,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.green,
                  width: 8,
                ),
              ),

              child: const Center(
                child: Icon(
                  Icons.check,
                  size: 70,
                  color: Colors.orange,
                ),
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              "Donation successfully added",
              style: TextStyle(
                color: Colors.green,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            const Text(
              "Thankyou for your kindness",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/giver-activity',
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 18,
                ),
              ),

              child: const Text(
                "Back",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}