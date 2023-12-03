import 'package:flutter/material.dart';
import 'package:zoom_image/view/pinch_zoom_image.dart';

class Image2Tab extends StatefulWidget {
  const Image2Tab({super.key});

  @override
  State<Image2Tab> createState() => _Image2TabState();
}

class _Image2TabState extends State<Image2Tab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const PinchZoomImage(),
    );
  }
}
