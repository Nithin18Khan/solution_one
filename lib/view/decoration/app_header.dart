import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:solution_one/main.dart';
import 'package:solution_one/view_model/model_widget/circle_button.dart';



import '../../view_model/buttons/app_icons.dart';

class AppHeader extends StatelessWidget {
  const AppHeader(
      {Key? key,
      this.title,
      this.subtitle,
      this.showBackBtn = true,
      this.isTransparent = false,
      this.onBack,
      this.trailing,
      this.backIcon = AppIcons.prev,
      this.backBtnSemantics})
      : super(key: key);
  final String? title; 
  final String? subtitle;
  final bool showBackBtn;
  final AppIcons backIcon;
  final String? backBtnSemantics;
  final bool isTransparent;
  final VoidCallback? onBack;
  final Widget Function(BuildContext context)? trailing;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: isTransparent ? Colors.transparent : $styles.colors.black,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64 * $styles.scale,
          child: Stack(
            children: [
              MergeSemantics(
                child: Semantics(
                  header: true,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (title != null)
                          Text(
                            title!.toUpperCase(),
                            textHeightBehavior: const TextHeightBehavior(
                                applyHeightToFirstAscent: false),
                            style: $styles.text.h4.copyWith(
                              color: $styles.colors.offWhite,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        if (subtitle != null)
                          Text(
                            subtitle!.toUpperCase(),
                            textHeightBehavior: const TextHeightBehavior(
                                applyHeightToFirstAscent: false),
                            style: $styles.text.title1
                                .copyWith(color: $styles.colors.accent1),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Row(children: [
                    Gap($styles.insets.sm),
                    if (showBackBtn)
                      BackBtn(
                        onPressed: onBack,
                        icon: backIcon,
                        semanticLabel: backBtnSemantics,
                      ),
                    const Spacer(),
                    if (trailing != null) trailing!.call(context),
                    Gap($styles.insets.sm),
                    // if (showBackBtn) Container(width: $styles.insets.lg * 2, alignment: Alignment.centerLeft, child: child),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
