import 'package:flutter/material.dart';
import 'package:solution_one/view/transition/illustration.config.dart';
import 'package:solution_one/view/transition/transition_main_page.dart';

class WonderIllustration extends StatelessWidget {
  const WonderIllustration({Key? key, required this.config}) : super(key: key);

  final WonderIllustrationConfig config;

  @override
  Widget build(BuildContext context) {
    return ChichenItzaIllustration(config: config);
  }
}


enum WonderType {
  chichenItza,
  // christRedeemer,
  // colosseum,
  // greatWall,
  // machuPicchu,
  // petra,
  // pyramidsGiza,
  // tajMahal,
}
