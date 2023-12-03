import 'package:flutter/material.dart';
import 'package:zoom_image/view/image1_tab.dart';
import 'package:zoom_image/view/image2_tab.dart';

class PageBase extends StatefulWidget {
  const PageBase({super.key, required this.title});

  final String title;

  @override
  State<PageBase> createState() => _PageBaseState();
}

class _PageBaseState extends State<PageBase> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Image 1',
                icon: Icon(Icons.image),
              ),
              Tab(
                text: 'Image 2',
                icon: Icon(Icons.image),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [Image1Tab(), Image2Tab()],
        ),
      ),
    );
  }
}
