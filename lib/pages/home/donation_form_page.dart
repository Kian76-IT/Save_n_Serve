import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

    final error = await _controller.submitDonation();
    if (!mounted) return;

    if (error == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SubmitSuccessPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ),
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

              // ── IMAGE PICKER BOX ─────────────────────────────
              _buildImagePicker(),

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

              // GIMMICK MAP — static UI placeholder, no API key needed
              _buildGimmickMap(),

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

  Widget _buildImagePicker() {
    final images = _controller.pickedImages;
    final canAddMore = images.length < 10;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                images.isEmpty
                    ? 'Add up to 10 images'
                    : '${images.length} / 10 photos selected',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              if (canAddMore)
                GestureDetector(
                  onTap: _controller.pickImages,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.add_photo_alternate_outlined,
                            color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text('Add Photos',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          if (images.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, i) => _buildThumbnail(images[i], i),
              ),
            ),
          ] else ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _controller.pickImages,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt_outlined,
                          size: 30, color: Colors.grey),
                      SizedBox(height: 6),
                      Text('Tap to pick photos',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildThumbnail(XFile image, int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            File(image.path),
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _controller.removeImage(index),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGimmickMap() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 140,
        child: Stack(
          children: [
            // Road grid background
            Container(color: const Color(0xFFD4E9C7)),
            // Horizontal road lines
            for (int i = 0; i < 6; i++)
              Positioned(
                top: 15.0 + i * 22.0,
                left: 0,
                right: 0,
                child: Container(
                  height: i == 2 ? 5 : 2,
                  color: Colors.white.withValues(alpha: i == 2 ? 0.9 : 0.5),
                ),
              ),
            // Vertical road lines
            for (int i = 0; i < 9; i++)
              Positioned(
                left: 10.0 + i * 42.0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: i == 3 ? 5 : 2,
                  color: Colors.white.withValues(alpha: i == 3 ? 0.9 : 0.4),
                ),
              ),
            // Decorative green blocks (park/building)
            Positioned(
              left: 50, top: 20,
              child: Container(
                width: 55, height: 35,
                decoration: BoxDecoration(
                  color: const Color(0xFF81C784).withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Positioned(
              right: 30, bottom: 20,
              child: Container(
                width: 48, height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF81C784).withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            // Grey building block
            Positioned(
              right: 90, top: 15,
              child: Container(
                width: 35, height: 28,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            // Center location pin
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_pin, color: Colors.red, size: 38),
                  SizedBox(height: 2),
                  Text(
                    'Lokasi Pickup',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // Map label chip
            Positioned(
              top: 8, right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.map_outlined, size: 12, color: Colors.green),
                    SizedBox(width: 4),
                    Text('Map', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
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
