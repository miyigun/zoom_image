import 'package:flutter/material.dart';

class PinchZoomImage extends StatefulWidget {
  const PinchZoomImage({super.key});

  @override
  State<PinchZoomImage> createState() => _PinchZoomImageState();
}

class _PinchZoomImageState extends State<PinchZoomImage>
    with SingleTickerProviderStateMixin {
  late TransformationController controller;
  late AnimationController animationController;
  Animation<Matrix4>? animation;

  final double minScale = 1;
  final double maxScale = 4;
  double scale=1;

  OverlayEntry? entry;

  @override
  void initState() {
    controller = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )
      ..addListener(() => controller.value = animation!.value)
      ..addStatusListener((status) {
        if (status==AnimationStatus.completed) {
          removeOverlay();
        }
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
    return Center(
      child: buildImage(),
    );
  }

  Widget buildImage() {
    return Builder(
      builder: (context) {
        return InteractiveViewer(
          transformationController: controller,
          clipBehavior: Clip.none,
          panEnabled: false,
          minScale: minScale,
          maxScale: maxScale,
          onInteractionStart: (details) {
            if (details.pointerCount<2) return;

            showOverlay(context);
          },
          onInteractionUpdate: (details) {
            if (entry==null) return;

            scale=details.scale;
            entry!.markNeedsBuild();
          },
          onInteractionEnd: (details) {
            resetAnimation();
          },
          child: AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "assets/image2.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }
    );
  }

  void resetAnimation() {
    animation = Matrix4Tween(
      begin: controller.value,
      end: Matrix4.identity(),
    ).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));

    animationController.forward(from: 0);
  }

  void showOverlay(BuildContext context) {
    final renderBox=context.findRenderObject()! as RenderBox;
    final offset=renderBox.localToGlobal(Offset.zero);
    final size=MediaQuery.of(context).size;

    entry=OverlayEntry(
        builder: (context) {
          final opacity=((scale-1)/(maxScale-1)).clamp(minScale,maxScale);

          return Stack(
            children: <Widget>[
              Positioned.fill(
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      color: Colors.black,
                    ),
                  )
              ),
              Positioned(
                left: offset.dx,
                top: offset.dy,
                width: size.width,
                child: buildImage(),
              ),
            ]
          );
        }
    );

    final overlay=Overlay.of(context);
    overlay.insert(entry!);

  }

  void removeOverlay() {
    entry?.remove();
    entry=null;
  }
}
