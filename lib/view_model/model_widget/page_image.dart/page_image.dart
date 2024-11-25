
import 'package:flutter/material.dart';
import 'package:solution_one/assets.dart';

class PageImage extends StatelessWidget {
  const PageImage({Key? key, required this.data}) : super(key: key);

  final PageData data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Image.asset(
            '${ImagePaths.common}/intro-${data.img}.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.centerRight,
          ),
        ),
        Positioned.fill(
            child: Image.asset(
          '${ImagePaths.common}/intro-mask-${data.mask}.png',
          fit: BoxFit.fill,
        )),
      ],
    );
  }
}

class PageData {
  const PageData(this.title, this.desc, this.img, this.mask);

  final String title;
  final String desc;
  final String img;
  final String mask;
}