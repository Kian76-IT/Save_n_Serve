import 'package:flutter/material.dart';

/// A reusable image slider for a [FoodItem]'s photo gallery.
///
/// Handles three states:
///   • empty list  → asset placeholder
///   • single URL  → plain network image
///   • many URLs   → swipeable PageView with animated dot indicators
///
/// All outputs are constrained to [height] × ∞-width with [BoxFit.cover] so
/// varying source resolutions never stretch or overflow the parent card.
class FoodImageSlider extends StatefulWidget {
  final List<String> imageUrls;

  /// Height of the image area. Cards can pass different values (e.g. 180, 140).
  final double height;

  /// Fallback local asset shown when [imageUrls] is empty or a network load fails.
  final String fallbackAsset;

  const FoodImageSlider({
    super.key,
    required this.imageUrls,
    this.height = 180,
    this.fallbackAsset = 'assets/images/GambarProduk1.png',
  });

  @override
  State<FoodImageSlider> createState() => _FoodImageSliderState();
}

class _FoodImageSliderState extends State<FoodImageSlider> {
  int _currentPage = 0;
  late final PageController _pageCtrl;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    // ── State A: no images ────────────────────────────────────────────────────
    if (widget.imageUrls.isEmpty) {
      return Image.asset(
        widget.fallbackAsset,
        height: widget.height,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    // ── State B: single image ─────────────────────────────────────────────────
    if (widget.imageUrls.length == 1) {
      return Image.network(
        widget.imageUrls.first,
        height: widget.height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Image.asset(
          widget.fallbackAsset,
          height: widget.height,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    // ── State C: multiple images — swipeable PageView + dot indicators ────────
    return Stack(
      children: [
        PageView.builder(
          controller: _pageCtrl,
          itemCount: widget.imageUrls.length,
          onPageChanged: (i) => setState(() => _currentPage = i),
          itemBuilder: (_, i) => Image.network(
            widget.imageUrls[i],
            height: widget.height,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Image.asset(
              widget.fallbackAsset,
              height: widget.height,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.imageUrls.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: i == _currentPage ? 14 : 5,
                height: 5,
                decoration: BoxDecoration(
                  color: i == _currentPage ? Colors.white : Colors.white54,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
