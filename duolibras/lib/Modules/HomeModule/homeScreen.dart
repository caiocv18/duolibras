import 'package:duolibras/Commons/Components/appBarWidget.dart';
import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Modules/LearningModule/ViewModel/learningViewModel.dart';
import 'package:duolibras/Modules/LearningModule/Widgets/learningScreen.dart';
import 'package:duolibras/Modules/LoginModule/SignIn/signInPage.dart';
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
       return BottomNavigationBar(
         elevation: 15,
         items: [
           BottomNavigationBarItem(
               activeIcon: Image.asset(Constants.imageAssets.trophyGradient),
               icon: Image.asset(Constants.imageAssets.trophyEmpty),
               label: "Ranking",
           ),
           BottomNavigationBarItem(
               activeIcon: Image.asset(Constants.imageAssets.trailGradient), 
               icon: Image.asset(Constants.imageAssets.trailEmpty),
               label: "Trilha"
           ),
           BottomNavigationBarItem(
               activeIcon: Image.asset(Constants.imageAssets.profileGradient),
               icon: Image.asset(Constants.imageAssets.profileEmpty),
               label: "Perfil"
           ),
         ],
         type: BottomNavigationBarType.fixed,
         onTap: (index) {
           setState(() => _page = _pages[index]);
           _currentIndex = index;
         },
         selectedLabelStyle: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w500, fontSize: 14, color: HexColor.fromHex("4982F6")),
         unselectedLabelStyle: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w500, color: Colors.grey, fontSize: 14),
         currentIndex: _currentIndex,
       );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(234, 234, 234, 1),
      appBar: AppBarWidget(_getCurrentTile(), longpressHandler: () {
        setState(() {
          isSwitched = !isSwitched;
          isLoading = true;
        });
        loadingNewLearningScreen(isSwitched);
      }, backButtonPressed: null),
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(child: 
        LayoutBuilder(builder: (BuildContext ctx, BoxConstraints constraint) {
          return Stack(
              alignment: Alignment.bottomCenter,
              children: [
              isLoading
              ? _loadingPage(Size(constraint.maxWidth, constraint.maxHeight)) : _page,
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [HexColor.fromHex("4982F6"), HexColor.fromHex("2CC4FC")]),
                )
              ),
            ]
          );
        })
      ));
  
  }

  Widget _loadingPage(Size containerSize) {
    return
        Stack(
            alignment: AlignmentDirectional.center,
            children: 
            [
              Container(
                height: containerSize.height,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        Constants.imageAssets.background_home),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              CircularProgressIndicator()
          ],
      );
  }

  void _setupNewPage(HomePages selectedPage) {
  switch (selectedPage) {
    case HomePages.Profile:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignInPage()));
        break;
      default: break;
    }
  }

  String _getCurrentTile() {
    if (_currentIndex == 0) {
      return "Ranking";
    }
    if (_currentIndex == 1) {
      return "Trilha";
    }
    if (_currentIndex == 2) {
      return "Perfil";
    }

    return "";
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
