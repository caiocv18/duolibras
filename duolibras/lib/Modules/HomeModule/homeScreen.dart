import 'package:duolibras/Modules/LearningModule/ViewModel/learningViewModel.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/learningScreen.dart';
import 'package:duolibras/Modules/LearningModule/mainRouter.dart';
import 'package:duolibras/Modules/RankingModule/rankingScreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final _pages = [LearningScreen(LearningViewModel()), RankingScreen()];
  late Widget _page = _pages[0];

  BottomNavigationBar get bottomNavigationBar {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.score),
            label: "Ranking",
            backgroundColor: _currentIndex == 1 ? Colors.blue : Colors.white)
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Duolibras"),
        actions: [
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () => {
                    Navigator.of(context)
                        .pushNamed(MainRouter.routeSignIn)
                        .then((value) {
                      _handleCompletedLogin(value as bool?);
                    })
                  })
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
      body: _page,
    );
  }
}
