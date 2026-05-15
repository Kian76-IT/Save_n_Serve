import 'package:flutter/material.dart';
import 'submit_success_page.dart';

class DonationFormPage extends StatefulWidget {
  const DonationFormPage({super.key});

  @override
  State<DonationFormPage> createState() => _DonationFormPageState();
}

class _DonationFormPageState extends State<DonationFormPage> {
  int selectedQuantity = 1;

  final List<int> quantities = [1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text(
          "Heavy Meals Donation",
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // IMAGE BOX
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Row(
                children: [

                  Container(
                    width: 90,
                    height: 90,

                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 35,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(width: 16),

                  const Text(
                    "Add up to 10 images",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // FORM BOX
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // TITLE
                  const Text(
                    "Title",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),

                  const TextField(
                    decoration: InputDecoration(
                      hintText: "Input your food title",
                    ),
                  ),

                  const SizedBox(height: 20),

                  // DESCRIPTION
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),

                  const TextField(
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: "e.g 3x tins of veg soup, BB Dec 2023",
                    ),
                  ),

                  const SizedBox(height: 20),

                  // QUANTITY
                  const Text(
                    "Quantity",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: quantities.map((qty) {
                      final isSelected = selectedQuantity == qty;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),

                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedQuantity = qty;
                            });
                          },

                          child: Container(
                            width: 38,
                            height: 38,

                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.orange
                                  : Colors.grey.shade200,

                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Center(
                              child: Text(
                                qty.toString(),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // PICKUP TIME
                  const Text(
                    "Pick up times",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),

                  const TextField(
                    decoration: InputDecoration(
                      hintText: "Today from 6pm - 11pm",
                    ),
                  ),

                  const SizedBox(height: 20),

                  // INSTRUCTION
                  const Text(
                    "Your pick up instructions",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),

                  const TextField(
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText:
                          "Please don't ring the doorbell, send me a message when you arrive",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // LOCATION BOX
            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [

                  Text(
                    "Confirm your location",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // MAP PLACEHOLDER
            Container(
              height: 140,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: NetworkImage(
                    "https://maps.gstatic.com/tactile/basepage/pegman_sherlock.png",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SubmitSuccessPage(),
                        ),
                    );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}