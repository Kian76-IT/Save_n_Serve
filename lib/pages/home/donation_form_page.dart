import 'package:flutter/material.dart';
import 'package:save_n_serve/controllers/giver_controller.dart';
import 'submit_success_page.dart';

class DonationFormPage extends StatefulWidget {
  const DonationFormPage({super.key});

  @override
  State<DonationFormPage> createState() => _DonationFormPageState();
}

class _DonationFormPageState extends State<DonationFormPage> {
  // Use the singleton — do NOT dispose it
  final _controller = giverController;

  Future<void> _onSubmit() async {
    final basicFilled = _controller.titleController.text.trim().isNotEmpty &&
        _controller.descriptionController.text.trim().isNotEmpty &&
        _controller.startTime != null &&
        _controller.endTime != null;

    if (!basicFilled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap isi Title, Description, dan waktu pengambilan.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_controller.isTimeReversed()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End Time harus lebih lambat dari Start Time.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await _controller.submitDonation();
    if (success && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SubmitSuccessPage()),
      );
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final current = isStart ? _controller.startTime : _controller.endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: current ?? TimeOfDay.now(),
      builder: (ctx, child) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null) {
      isStart ? _controller.setStartTime(picked) : _controller.setEndTime(picked);
    }
  }

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

      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) => SingleChildScrollView(
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
                        border: Border.all(color: Colors.grey, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.camera_alt_outlined, size: 35, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    const Text("Add up to 10 images", style: TextStyle(color: Colors.grey)),
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
                    const Text("Title", style: TextStyle(fontWeight: FontWeight.w500)),
                    TextField(
                      controller: _controller.titleController,
                      decoration: const InputDecoration(hintText: "Input your food title"),
                    ),

                    const SizedBox(height: 20),

                    // DESCRIPTION
                    const Text("Description", style: TextStyle(fontWeight: FontWeight.w500)),
                    TextField(
                      controller: _controller.descriptionController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: "e.g 3x tins of veg soup, BB Dec 2023",
                      ),
                    ),

                    const SizedBox(height: 20),

                    // QUANTITY
                    const Text("Quantity", style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    Row(
                      children: _controller.quantities.map((qty) {
                        final isSelected = _controller.selectedQuantity == qty;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => _controller.selectQuantity(qty),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.orange : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  qty.toString(),
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black,
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

                    // PICKUP TIME — dual time pickers
                    const Text("Pick up times", style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildTimeBox('Start Time', _controller.startTime, isStart: true)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTimeBox('End Time', _controller.endTime, isStart: false)),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // INSTRUCTION
                    const Text("Your pick up instructions", style: TextStyle(fontWeight: FontWeight.w500)),
                    TextField(
                      controller: _controller.instructionController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: "Please don't ring the doorbell, send me a message when you arrive",
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Confirm your location", style: TextStyle(fontWeight: FontWeight.w500)),
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
                  onPressed: _controller.isSubmitting ? null : _onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _controller.isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text("Submit", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeBox(String label, TimeOfDay? value, {required bool isStart}) {
    final hasValue = value != null;
    return GestureDetector(
      onTap: () => _pickTime(isStart: isStart),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasValue ? Colors.orange : Colors.grey.shade300,
            width: hasValue ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.access_time, size: 18, color: hasValue ? Colors.orange : Colors.grey),
                const SizedBox(width: 6),
                Text(
                  hasValue
                      ? '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}'
                      : 'HH:MM',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: hasValue ? Colors.black87 : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
