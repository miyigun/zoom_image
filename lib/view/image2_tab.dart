import 'package:flutter/material.dart';

class Image2Tab extends StatefulWidget {
  const Image2Tab({super.key});

  @override
  State<Image2Tab> createState() => _Image2TabState();
}

class _Image2TabState extends State<Image2Tab>
    with SingleTickerProviderStateMixin {
  late TransformationController controller;

  TapDownDetails? tapDownDetails;

  late AnimationController animationController;
  Animation<Matrix4>? animation;

  @override
  void initState() {
    controller = TransformationController();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        controller.value = animation!.value;
      });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: buildImage(),
      ),
    );
  }

  Widget buildImage() => GestureDetector(
        onTapDown: (details) => tapDownDetails = details,
        onTap: () {
          final position = tapDownDetails!.localPosition;

          const double scale = 5;

          final x = -position.dx * (scale - 1);
          final y = -position.dy * (scale - 1);

          final zoomed = Matrix4.identity()
            ..translate(x, y)
            ..scale(scale);

          final end =
              controller.value.isIdentity() ? zoomed : Matrix4.identity();

          animation = Matrix4Tween(
            begin: controller.value,
            end: end,
          ).animate(
              CurveTween(curve: Curves.easeOut).animate(animationController));

          animationController.forward(from: 0);
        },
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          transformationController: controller,
          panEnabled: false,
          scaleEnabled: false,
          child: AspectRatio(
            aspectRatio: 2,
            child: Image.asset(
              "assets/image2.jpg",
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
}
