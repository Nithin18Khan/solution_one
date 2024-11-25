





import 'package:solution_one/view/transition/illustration.dart';

class ImagePaths {
  static String root = 'assets/images';
  static String common = 'assets/images/_common';
  static String cloud = '$common/cloud-white.png';

  // static String collectibles = '$root/collectibles';
  // static String particle = '$common/particle-21x23.png';
  // static String ribbonEnd = '$common/ribbon-end.png';

  static String textures = '$common/texture';
  static String icons = '$common/icons';

  static String roller1 = '$textures/roller-1-white.gif';
  static String roller2 = '$textures/roller-2-white.gif';

  // static String appLogo = '$common/app-logo.png';
  // static String appLogoPlain = '$common/app-logo-plain.png';
}



class SvgPaths {
  static String compassFull = '${ImagePaths.common}/compass-full.svg';
  static String compassSimple = '${ImagePaths.common}/compass-simple.svg';
}
extension WonderAssetExtensions on WonderType {
  String get assetPath {
    switch (this) {
      
      case WonderType.chichenItza:
        return '${ImagePaths.root}/chichen_itza';
     
    }
  }
  String get homeBtn => '$assetPath/wonder-button.png';

}
