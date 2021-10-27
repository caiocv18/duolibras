import 'package:duolibras/Commons/Components/appBarWidget.dart';
import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Modules/LearningModule/ViewModel/learningViewModel.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/learningScreen.dart';
import 'package:duolibras/Modules/ProfileModule/profilePage.dart';
import 'package:duolibras/Modules/RankingModule/rankingScreen.dart';
import 'package:flutter/material.dart';

enum HomePages {
  Ranking,
  Home, 
  Profile
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  bool isSwitched = false;
  int _currentIndex = 1;

  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  late var _pages = [
    RankingScreen(_setupNewPage),
    LearningScreen(LearningViewModel()),
    ProfilePage()
  ];
  late Widget _page = _pages[_currentIndex];

  Widget get bottomNavigationBar {
    return Container(
      height: 112,
      child: Column(
        children: [
          Container(
            height: 10,
            width: double.infinity,
            color: HexColor.fromHex("4982F6"),
          ),
          BottomNavigationBar(
            elevation: 15,
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset(Constants.imageAssets.rankingIcon,
                      color: _currentIndex == 0
                          ? HexColor.fromHex("4982F6")
                          : HexColor.fromHex("D2D7E4")),
                  label: "Ranking",
                  backgroundColor: _currentIndex == 1
                      ? HexColor.fromHex("4982F6")
                      : Colors.white),
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
              setState(() => _page = _pages[index]);
              _currentIndex = index;
            },
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            currentIndex: _currentIndex,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(234, 234, 234, 1),
      appBar: AppBarWidget(_currentIndex == 0 ? "Ranking" : "Dibras", () {
        setState(() {
          isSwitched = !isSwitched;
          isLoading = true;
        });
        loadingNewLearningScreen(isSwitched);
      }),
      bottomNavigationBar: bottomNavigationBar,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(child: _page),
    );
  }

  void _setupNewPage(HomePages selectedPage) {
    switch (selectedPage) {
      case HomePages.Profile:
        setState(() {
          _page = _pages[2];
          _currentIndex = 2;
        });
        break;
      case HomePages.Ranking:
        setState(() {
          _page = _pages[0];
          _currentIndex = 0;
        });
        break;
      case HomePages.Home:
        setState(() {
          _page = _pages[1];
          _currentIndex = 1;
        });
        break;
    }
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
