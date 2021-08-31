// import 'package:duolibras/Modules/ExercisesModule/exerciseMultiChoiceScreen.dart';
// import 'package:duolibras/Modules/ExercisesModule/exerciseWritingScreen.dart';
// import 'package:duolibras/Modules/LearningModule/ViewModel/learningViewModel.dart';
// import 'package:duolibras/Modules/LearningModule/Widgets/learningScreen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class Routes {
//   Routes._();

//   static const String PAGE_INITIAL = '/';
//   static const String PAGE_MULTICHOICE_EXERCISE = "/ExerciseMultiChoiceScreen";
//   static const String PAGE_HOME = '/home';
//   static const String PAGE_WRITING_EXERCISE = '/ExerciseWritingScreen';
// // "/ExerciseMultiChoiceScreen"
//   static final GlobalKey<NavigatorState> rootNavigatorKey =
//       GlobalKey<NavigatorState>();
//   static final GlobalKey<NavigatorState> mainNavigatorKey =
//       GlobalKey<NavigatorState>();

//   static String? currentSubNavigatorInitialRoute;

//   static CupertinoPageRoute<Widget>? onGenerateRoute(RouteSettings settings) {
//     Widget page = LearningScreen(LearningViewModel());

//     switch (settings.name) {
//       case PAGE_INITIAL:
//         page = LearningScreen(LearningViewModel());
//         break;
//       case PAGE_MULTICHOICE_EXERCISE:
//         page = ExerciseMultiChoiceScreen();
//         break;
//       case PAGE_HOME:
//         page = LearningScreen(LearningViewModel());
//         break;
//       case PAGE_WRITING_EXERCISE:
//         page = ExerciseWritingScreen();
//         break;
//     }

//     if (settings.name == PAGE_INITIAL &&
//         currentSubNavigatorInitialRoute != null) {
//       // When current sub-navigator initial route is set,
//       // do not display initial route because it is already displayed.
//       return null;
//     }

//     return CupertinoPageRoute<Widget>(
//       builder: (_) {
//         if (currentSubNavigatorInitialRoute == settings.name) {
//           return WillPopScope(
//             onWillPop: () async => false,
//             child: page,
//           );
//         }

//         return page;
//       },
//       settings: settings,
//     );
//   }

//   /// [MaterialApp] navigator key.
//   ///
//   ///
//   static NavigatorState? get rootNavigator => rootNavigatorKey.currentState;

//   /// [PAGE_MAIN] navigator key.
//   ///
//   ///
//   static NavigatorState? get mainNavigator => mainNavigatorKey.currentState;

//   /// Navigate to screen via [CupertinoPageRoute].
//   ///
//   /// If [navigator] is not set, it will use the [rootNavigator].
//   static void push(Widget screen, {required NavigatorState navigator}) {
//     final CupertinoPageRoute<Widget> route = CupertinoPageRoute<Widget>(
//       builder: (_) => screen,
//     );

//     if (navigator != null) {
//       navigator.push(route);
//       return;
//     }

//     rootNavigator!.push(route);
//   }

//   /// Navigate to route name via [CupertinoPageRoute].
//   ///
//   /// If [navigator] is not set, it will use the [rootNavigator].
//   static void pushNamed(
//     String routeName, {
//     NavigatorState? navigator,
//     Object? arguments,
//   }) {
//     if (navigator != null) {
//       navigator.pushNamed(routeName, arguments: arguments);
//       return;
//     }

//     rootNavigator!.pushNamed(routeName, arguments: arguments);
//   }

//   /// Pop current route of [navigator].
//   ///
//   /// If [navigator] is not set, it will use the [rootNavigator].
//   static void pop<T extends Object>({
//     NavigatorState? navigator,
//     T? result,
//   }) {
//     if (navigator != null) {
//       navigator.pop(result);
//       return;
//     }

//     rootNavigator!.pop(result);
//   }
// }

// //--------------------------------------------------------------------------------
// /// A navigator widget who is a child of [MaterialApp] navigator.
// ///
// ///
// class SubNavigator extends StatelessWidget {
//   const SubNavigator({
//     required this.navigatorKey,
//     required this.initialRoute,
//     required Key key,
//   }) : super(key: key);

//   final GlobalKey<NavigatorState> navigatorKey;
//   final String initialRoute;

//   @override
//   Widget build(BuildContext context) {
//     final _SubNavigatorObserver _navigatorObserver = _SubNavigatorObserver(
//       initialRoute,
//       navigatorKey,
//     );
//     Routes.currentSubNavigatorInitialRoute = initialRoute;

//     return WillPopScope(
//       onWillPop: () async {
//         if (_navigatorObserver.isInitialPage) {
//           Routes.currentSubNavigatorInitialRoute = null;
//           await SystemNavigator.pop();
//           return true;
//         }

//         final bool canPop = navigatorKey.currentState!.canPop();

//         if (canPop) {
//           navigatorKey.currentState!.pop();
//         }

//         return !canPop;
//       },
//       child: Navigator(
//         key: navigatorKey,
//         observers: <NavigatorObserver>[_navigatorObserver],
//         initialRoute: initialRoute,
//         onGenerateRoute: Routes.onGenerateRoute,
//       ),
//     );
//   }
// }

// //--------------------------------------------------------------------------------
// /// [NavigatorObserver] of [SubNavigator] widget.
// ///
// ///
// class _SubNavigatorObserver extends NavigatorObserver {
//   _SubNavigatorObserver(this._initialRoute, this._navigatorKey);

//   final String _initialRoute;
//   final GlobalKey<NavigatorState> _navigatorKey;
//   final List<String> _routeNameStack = <String>[];

//   bool _isInitialPage = false;

//   /// Flag if current route is the initial page.
//   ///
//   ///
//   bool get isInitialPage => _isInitialPage;

//   // @override
//   // void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
//   //   _routeNameStack.add(route.settings.name);
//   //   _isInitialPage = _routeNameStack.last == _initialRoute;
//   // }

//   // @override
//   // void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
//   //   _routeNameStack.remove(route.settings.name);
//   //   _isInitialPage = _routeNameStack.last == _initialRoute;
//   // }

//   // @override
//   // void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
//   //   _routeNameStack.remove(route.settings.name);
//   //   _isInitialPage = _routeNameStack.last == _initialRoute;
//   // }

//   // @override
//   // void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
//   //   _routeNameStack.remove(oldRoute.settings.name);
//   //   _routeNameStack.add(newRoute.settings.name);
//   //   _isInitialPage = _routeNameStack.last == _initialRoute;
//   // }
// }
