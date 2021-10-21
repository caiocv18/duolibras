import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Modules/LearningModule/ViewModel/learningViewModel.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/learningScreen.dart';
import 'package:duolibras/Modules/LearningModule/mainRouter.dart';
import 'package:duolibras/Modules/ProfileModule/profilePage.dart';
import 'package:duolibras/Modules/RankingModule/rankingScreen.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  bool isSwitched = false;
  int _currentIndex = 1;
  var _pages = [
    RankingScreen(),
    LearningScreen(LearningViewModel()),
    ProfileFlow(setupPageRoute: ProfileFlow.routeProfile)
  ];
  late Widget _page = _pages[_currentIndex];

  BottomNavigationBar get bottomNavigationBar {
    return BottomNavigationBar(
      elevation: 15,
      items: [
        BottomNavigationBarItem(
            icon: Image.asset(Constants.imageAssets.rankingIcon,
                color: _currentIndex == 0
                    ? HexColor.fromHex("4982F6")
                    : HexColor.fromHex("D2D7E4")),
            label: "Ranking",
            backgroundColor:
                _currentIndex == 1 ? HexColor.fromHex("4982F6") : Colors.white),
        BottomNavigationBarItem(
            icon: Image.asset(
              Constants.imageAssets.trailIcon,
              color: _currentIndex == 1
                  ? HexColor.fromHex("4982F6")
                  : HexColor.fromHex("D2D7E4"),
            ),
            label: "Trilha"),
        BottomNavigationBarItem(
            icon: Image.asset(Constants.imageAssets.profileIcon,
                color: _currentIndex == 2
                    ? HexColor.fromHex("4982F6")
                    : HexColor.fromHex("D2D7E4")),
            label: "Perfil"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(234, 234, 234, 1),
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Container(
              child: Column(
                children: [
                  Text(_currentIndex == 0 ? "Ranking Mundial" : "Dibras", 
                  style: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w700, color: Colors.black)),
                ],
          )
        ),
        leading: GestureDetector(onLongPress: () {
           setState(() {
            isSwitched = !isSwitched;
            isLoading = true;
          });
          loadingNewLearningScreen(isSwitched);
        }),
        elevation: 1,
      ),
      bottomNavigationBar: bottomNavigationBar,
      body: isLoading ? Center(child: CircularProgressIndicator()) : SafeArea(child: _page),
    );
  }

  Future loadingNewLearningScreen(bool newValue) {
    return Future.delayed(Duration(seconds: 1)).then((value) => {
      setState(() {
        _changeEnvironment(newValue);
      })
    });
  }

  void _changeEnvironment(bool newValue) {
    isLoading = false;
    if (isSwitched) {
      SharedFeatures.instance.enviroment = AppEnvironment.PROD;
    } else {
      SharedFeatures.instance.enviroment = AppEnvironment.DEV;
    }
    _pages[1] = LearningScreen(LearningViewModel());
    _page = _pages[1];
  }

}

