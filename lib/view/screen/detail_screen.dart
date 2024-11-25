// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:solution_one/model/data_model.dart';
// import 'package:solution_one/model/provider/app_provider.dart';
// import 'package:solution_one/view/transition/illustration.dart';


// // Providers




// class WonderDetailsScreen extends ConsumerStatefulWidget {
//   const WonderDetailsScreen({
//     super.key,
//     required this.type,
//     this.tabIndex = 0,
//   });

//   final WonderType type;
//   final int tabIndex;

//   @override
//   ConsumerState<WonderDetailsScreen> createState() => _WonderDetailsScreenState();
// }

// class _WonderDetailsScreenState extends ConsumerState<WonderDetailsScreen>
//     with SingleTickerProviderStateMixin {
//   late final TabController _tabController = TabController(
//     length: 4,
//     vsync: this,
//     initialIndex: _clampIndex(widget.tabIndex),
//   )..addListener(_handleTabChanged);

//   AnimationController? _fade;
//   double? _tabBarSize;
//   bool _useNavRail = false;

//   @override
//   void didUpdateWidget(covariant WonderDetailsScreen oldWidget) {
//     if (oldWidget.tabIndex != widget.tabIndex) {
//       _tabController.index = _clampIndex(widget.tabIndex);
//     }
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   int _clampIndex(int index) => index.clamp(0, 3);

//   void _handleTabChanged() {
//     _fade?.forward(from: 0);
//     setState(() {});
//   }

//   void _handleTabTapped(int index) {
//     _tabController.index = index;
//     context.go(
//         ScreenPaths.wonderDetails(widget.type, tabIndex: _tabController.index));
//   }

//   void _handleTabMenuSized(Size size) {
//     setState(() {
//       _tabBarSize = (_useNavRail ? size.width : size.height) -
//           WonderDetailsTabMenu.buttonInset;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Access providers
//     final appLogic = ref.watch(appLogicProvider);
//     final wondersLogic = ref.watch(wonderDataProvider);

//     _useNavRail = appLogic.shouldUseNavRail();
//     final wonder = wondersLogic.title;
//     final tabIndex = _tabController.index;
//     final showTabBarBg = tabIndex != 1;
//     final tabBarSize = _tabBarSize ?? 0;
//     final menuPadding = _useNavRail
//         ? EdgeInsets.only(left: tabBarSize)
//         : EdgeInsets.only(bottom: tabBarSize);

//     return ColoredBox(
//       color: Colors.black,
//       child: Stack(
//         children: [
//           /// Fullscreen tab views
//           LazyIndexedStack(
//             index: _tabController.index,
//             children: [
//               WonderEditorialScreen(wonder, contentPadding: menuPadding),
//               PhotoGallery(
//                   collectionId: wonder.unsplashCollectionId,
//                   wonderType: wonder.type),
//               ArtifactCarouselScreen(
//                   type: wonder.type, contentPadding: menuPadding),
//               WonderEvents(type: widget.type, contentPadding: menuPadding),
//             ],
//           ),

//           /// Tab menu
//           Align(
//             alignment:
//                 _useNavRail ? Alignment.centerLeft : Alignment.bottomCenter,
//             child: MeasurableWidget(
//               onChange: _handleTabMenuSized,
//               child: WonderDetailsTabMenu(
//                   tabController: _tabController,
//                   onTap: _handleTabTapped,
//                   wonderType: wonder.type,
//                   showBg: showTabBarBg,
//                   axis: _useNavRail ? Axis.vertical : Axis.horizontal),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
