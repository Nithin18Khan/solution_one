import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solution_one/model/logic/cloud_provider.dart';
import 'package:solution_one/view/transition/illustration.dart';


class AnimatedClouds extends ConsumerStatefulWidget {
  const AnimatedClouds({
    Key? key,
    this.enableAnimations = true,
    required this.wonderType,
    required this.opacity,
    this.cloudSize = 500,
  }) : super(key: key);

  final WonderType wonderType;
  final bool enableAnimations;
  final double opacity;
  final double cloudSize;

  @override
  ConsumerState<AnimatedClouds> createState() => _AnimatedCloudsState();
}

class _AnimatedCloudsState extends ConsumerState<AnimatedClouds>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim =
      AnimationController(vsync: this, duration: 1500.ms);

  @override
  void initState() {
    super.initState();
    _generateClouds();
    _showClouds();
  }

  @override
  void didUpdateWidget(covariant AnimatedClouds oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.wonderType != widget.wonderType) {
      _generateClouds();
      _showClouds();
    }
  }

  void _generateClouds() {
    final screenSize = MediaQuery.of(context).size;
    ref.read(cloudProvider.notifier).generateClouds(
          widget.wonderType,
          widget.cloudSize,
          widget.opacity,
          screenSize,
        );
  }

  void _showClouds() {
    if (widget.enableAnimations) {
      _anim.forward(from: 0);
    } else {
      _anim.value = 1;
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clouds = ref.watch(cloudProvider);

    Widget buildCloud(Cloud cloud, {required bool isOld, required int startOffset}) {
      final curvedValue = Curves.easeOut.transform(_anim.value);
      final stOffset = clouds.indexOf(cloud) % 2 == 0 ? -startOffset : startOffset;
      return Positioned(
        top: cloud.pos.dy,
        left: isOld
            ? cloud.pos.dx - stOffset * curvedValue
            : cloud.pos.dx + stOffset * (1 - curvedValue),
        child: Opacity(
          opacity: isOld ? 1 - _anim.value : _anim.value,
          child: Transform.scale(
            scaleX: cloud.scale * (cloud.flipX ? -1 : 1),
            scaleY: cloud.scale * (cloud.flipY ? -1 : 1),
            child: Image.asset(
              'assets/images/cloud.png', // Update to your actual cloud asset path
              width: cloud.size * cloud.scale,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      );
    }

    return RepaintBoundary(
      child: ClipRect(
        child: OverflowBox(
          child: AnimatedBuilder(
            animation: _anim,
            builder: (_, __) {
              return Stack(
                clipBehavior: Clip.hardEdge,
                key: ValueKey(widget.wonderType),
                children: [
                  ...clouds.map(
                    (c) => buildCloud(c, isOld: false, startOffset: 1000),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
