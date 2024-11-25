import 'package:flutter/material.dart';
import 'package:solution_one/assets.dart';
import 'package:solution_one/view/decoration/color_extention.dart';
import 'package:solution_one/view/texture/illustration_texture.dart';
import 'package:solution_one/view/transition/builder.illustration.dart';
import 'package:solution_one/view/transition/fade_transition.dart';
import 'package:solution_one/view/transition/illustration.config.dart';
import 'package:solution_one/view/transition/illustration.dart';
import 'package:solution_one/view/transition/illustration.main.piece.dart';

class ChichenItzaIllustration extends StatelessWidget {
  ChichenItzaIllustration({Key? key, required this.config}) : super(key: key);
  final WonderIllustrationConfig config;
  final assetPath = WonderType.chichenItza.assetPath;
  final fgColor = WonderType.chichenItza.fgColor;
  @override
  Widget build(BuildContext context) {
    return WonderIllustrationBuilder(
      config: config,
      bgBuilder: _buildBg,
      mgBuilder: _buildMg,
      fgBuilder: _buildFg,
      wonderType: WonderType.chichenItza,
    );
  }

  List<Widget> _buildBg(BuildContext context, Animation<double> anim) {
    return [
      FadeColorTransition(animation: anim, color: fgColor),
      Positioned.fill(
        child: IllustrationTexture(
          ImagePaths.roller2,
          color: const Color(0xffDC762A),
          opacity: anim.drive(Tween(begin: 0, end: .5)),
          flipY: true,
          scale: config.shortMode ? 4 : 1.15,
        ),
      ),
      IllustrationPiece(
        fileName: 'sun.png',
        initialOffset: const Offset(0, 50),
        enableHero: true,
        heightFactor: .4,
        minHeight: 200,
        fractionalOffset: Offset(.55, config.shortMode ? .2 : -.35),
      ),
    ];
  }

  List<Widget> _buildMg(BuildContext context, Animation<double> anim) {
    // We want to size to the shortest side
    return [
      Transform.translate(
        offset: Offset(0, config.shortMode ? 70 : -30),
        child: const IllustrationPiece(
          fileName: 'chichen.png',
          heightFactor: .4,
          minHeight: 180,
          zoomAmt: -.1,
          enableHero: true,
        ),
      ),
    ];
  }

  List<Widget> _buildFg(BuildContext context, Animation<double> anim) {
    return [
      const IllustrationPiece(
        fileName: 'foreground-right.png',
        alignment: Alignment.bottomCenter,
        initialOffset: Offset(20, 40),
        initialScale: .95,
        heightFactor: .4,
        fractionalOffset: Offset(.5, -.1),
        zoomAmt: .1,
        dynamicHzOffset: 250,
      ),
      const IllustrationPiece(
        fileName: 'foreground-left.png',
        alignment: Alignment.bottomCenter,
        initialScale: .9,
        initialOffset: Offset(-40, 60),
        heightFactor: .65,
        fractionalOffset: Offset(-.4, .2),
        zoomAmt: .25,
        dynamicHzOffset: -250,
      ),
      const IllustrationPiece(
        fileName: 'top-left.png',
        alignment: Alignment.topLeft,
        initialScale: .9,
        initialOffset: Offset(-40, 60),
        heightFactor: .65,
        fractionalOffset: Offset(-.4, -.4),
        zoomAmt: .05,
        dynamicHzOffset: 100,
      ),
      const IllustrationPiece(
        fileName: 'top-right.png',
        alignment: Alignment.topRight,
        initialOffset: Offset(20, 40),
        initialScale: .95,
        heightFactor: .65,
        fractionalOffset: Offset(.35, -.4),
        zoomAmt: .05,
        dynamicHzOffset: -100,
      ),
    ];
  }
}
