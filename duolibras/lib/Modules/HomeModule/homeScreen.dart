import 'package:duolibras/Modules/LearningModule/ViewModel/learningViewModel.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/learningScreen.dart';
import 'package:duolibras/Modules/LearningModule/mainRouter.dart';
import 'package:duolibras/Modules/ProfileModule/profilePage.dart';
import 'package:duolibras/Modules/RankingModule/rankingScreen.dart';
import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;

  final _pages = [
    RankingScreen(),
    LearningScreen(LearningViewModel()),
    ProfileFlow(setupPageRoute: ProfileFlow.routeProfile)
  ];
  late Widget _page = _pages[_currentIndex];

  BottomNavigationBar get bottomNavigationBar {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.score),
            label: "Ranking",
            backgroundColor: _currentIndex == 1 ? Colors.blue : Colors.white),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: "Perfil"),
      ],
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        MainRouter.instance.navigatorKey.currentState!.maybePop();
        setState(() => _page = _pages[index]);
        _currentIndex = index;
      },
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      currentIndex: _currentIndex,
    );
  }

  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  void _handleCompletedLogin(bool? shouldUpdateView) {
    if (shouldUpdateView == null) return;

    if (shouldUpdateView) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => UserSession.instance.userProvider,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Dibras"),
        ),
        bottomNavigationBar: bottomNavigationBar,
        body: _page,
      ),
    );
  }
}
