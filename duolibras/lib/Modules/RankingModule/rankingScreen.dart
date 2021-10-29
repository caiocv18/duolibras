import 'dart:ui';

import 'package:duolibras/Commons/Components/exerciseButton.dart';
import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Modules/HomeModule/homeScreen.dart';
import 'package:duolibras/Modules/RankingModule/ViewModel/rankingViewModel.dart';
import 'package:duolibras/Modules/RankingModule/Widgets/rankingTile.dart';
import 'package:duolibras/Services/Models/Providers/userProvider.dart';
import 'package:duolibras/Services/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RankingScreen extends StatefulWidget {
  final _viewModel = RankingViewModel();  
  Function (HomePages) selectNewPage;

  RankingScreen(this.selectNewPage);

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<User> usersRank = [];

  @override
  initState() {
    super.initState();

    widget._viewModel.usersRank!.asBroadcastStream().listen((newUsersRank) {
      setState(() {
        this.usersRank = newUsersRank.reversed.toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    if (widget._viewModel.firstTime) {
      widget._viewModel.fetchUsersRank(context);
    }
    
    return Consumer(builder: (ctx, UserModel userModel, _) {
      sortUsersRanking(userModel.user);

      return 
      SafeArea(
        bottom: false,
        child: LayoutBuilder(builder: (ctx, constraint) {
          return Stack(
            alignment: AlignmentDirectional.center,
            children:
            [
              Container(
                height: constraint.maxHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        Constants.imageAssets.background_home),
                    fit: BoxFit.none,
                  ),
                ),
              ),
              SingleChildScrollView(
              child: Container(
                  height: constraint.maxHeight,
                  color: Colors.transparent,
                  child: SharedFeatures.instance.isLoggedIn
                      ? createRankingBody(context, constraint.maxHeight)
                      : createUnllogedBody(context, Size(constraint.maxWidth, constraint.maxHeight))
              ),
            ),]
          );
        })
      );
    });
    
   
  }

  Widget createRankingBody(BuildContext context, double containerHeight) {
    return 
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: containerHeight * 0.84,
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 12),
                itemCount: usersRank.length,
                itemBuilder: (ctx, index) {
                  return RankingTile(
                      index: index,
                      user: usersRank[index],
                      viewModel: widget._viewModel);
                }),
          ),
        );
  }

  Widget createUnllogedBody(BuildContext context, Size screenSize) {
    return Container(
      width: screenSize.width * 0.8,
      height: screenSize.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Faça login para ver a pontuação de outros jogadores!",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: "Nunito",
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center
          ),
          SizedBox(height: 40),
          Container(
            width: screenSize.width * 0.8,
            height: screenSize.height * 0.1,
            child: ExerciseButton(
              child: Center(
                child: Text(
                  "Entrar",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
              size: 25,
              color: HexColor.fromHex(
                  "#93CAFA"), //Colors.white, //Color(0xFFCA3034),
              onPressed: () {
                widget.selectNewPage(HomePages.Profile);
              },
            ),
            // child: ExerciseButton(child: Text("Entrar",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w800, color: HexColor.fromHex('E97070'), fontSize: 18)),
            //   onPressed: () => widget.selectNewPage(HomePages.Profile)
            // )
          )
        ],
      ),
    );
  }

  void sortUsersRanking(User newCurrentUser) {
    final index = usersRank.indexWhere((u) => u.id == newCurrentUser.id);
    if (index == -1) {
      return;
    }

    if (usersRank[index].currentProgress != newCurrentUser.currentProgress) {
      usersRank[index].currentProgress = newCurrentUser.currentProgress;
      usersRank.sort((a, b) {
        return b.currentProgress.compareTo(a.currentProgress);
      });
    }
  }

  @override
  void dispose() {
    widget._viewModel.disposeStreams();
    super.dispose();
  }

}
