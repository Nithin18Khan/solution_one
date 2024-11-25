import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:solution_one/main.dart';
import 'package:solution_one/router.dart';
import 'package:solution_one/view_model/buttons/buttons.dart';
import 'package:solution_one/view_model/model_widget/themed_txt.dart';
import 'package:solution_one/view_model/platform_info.dart';


class PageNotFound extends StatelessWidget {
  const PageNotFound(this.url, {super.key});

  final String url;

  @override
  Widget build(BuildContext context) {
    void handleHomePressed() => context.go(ScreenPaths.home);

    return Scaffold(
      backgroundColor: $styles.colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const WonderousLogo(),
            const Gap(10),
            Text(
              'Books',
              style: $styles.text.wonderTitle
                  .copyWith(color: $styles.colors.accent1, fontSize: 28),
            ),
            const Gap(70),
            Text(
              'The page you are looking for does not exist.',
              style: $styles.text.body.copyWith(color: $styles.colors.offWhite),
            ),
            if (PlatformInfo.isDesktop) ...{
              LightText(
                  child: Text('Path: $url', style: $styles.text.bodySmall)),
            },
            const Gap(70),
            AppBtn(
              minimumSize: const Size(200, 0),
              bgColor: $styles.colors.offWhite,
              onPressed: handleHomePressed,
              semanticLabel: 'Back',
              child: DarkText(
                child: Text(
                  'Back to civilization',
                  style: $styles.text.btn.copyWith(fontSize: 12),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
