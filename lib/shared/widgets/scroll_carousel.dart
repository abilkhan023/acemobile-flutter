import 'package:flutter/material.dart';

class ScrollCarousel extends StatelessWidget {
  const ScrollCarousel({super.key, required this.images, this.onTap});

  final List<String> images;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: images.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) => GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(images[i], width: 100, height: 120, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
