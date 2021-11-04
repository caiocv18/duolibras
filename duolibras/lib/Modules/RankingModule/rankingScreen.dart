import 'dart:ui';

import 'package:duolibras/Commons/Components/baseScreen.dart';
import 'package:duolibras/Commons/Components/exerciseButton.dart';
import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/constants.dart';
import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Commons/ViewModel/screenState.dart';
import 'package:duolibras/Modules/HomeModule/homeScreen.dart';
import 'package:duolibras/Modules/RankingModule/ViewModel/rankingViewModel.dart';
import 'package:duolibras/Modules/RankingModule/Widgets/rankingTile.dart';
import 'package:duolibras/Services/Models/Providers/userProvider.dart';
import 'package:duolibras/Services/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RankingScreen extends StatefulWidget {
  Function(HomePages) selectNewPage;

  RankingScreen(this.selectNewPage);

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen<RankingViewModel>(
        onModelReady: (viewModel) => viewModel.fetchUsersRank(context),
        builder: (_, viewModel, __) {
          return Consumer(builder: (ctx, UserModel userModel, _) {
            sortUsersRanking(userModel.user, viewModel.usersRank);

            return viewModel.state == ScreenState.Loading
                ? Center(child: CircularProgressIndicator())
                : SafeArea(
                    bottom: false,
                    child: LayoutBuilder(builder: (ctx, constraint) {
                      return Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              height: constraint.maxHeight,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      Constants.imageAssets.background_home),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SharedFeatures.instance.isLoggedIn
                                ? createRankingBody(
                                    context, constraint.maxHeight, viewModel)
                                : createUnllogedBody(
                                    context,
                                    Size(constraint.maxWidth,
                                        constraint.maxHeight)),
                          ]);
                    }));
          });
        });
  }

  Widget createRankingBody(BuildContext context, double containerHeight,
      RankingViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: containerHeight,
        child: ListView.builder(
            padding: EdgeInsets.only(bottom: 15),
            itemCount: viewModel.usersRank.length,
            itemBuilder: (ctx, index) {
              return RankingTile(
                  index: index,
                  user: viewModel.usersRank[index],
                  viewModel: viewModel);
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
          Text("Faça login para ver a pontuação de outros jogadores!",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: "Nunito",
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center),
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

  void sortUsersRanking(User newCurrentUser, List<User> usersRank) {
    final index = usersRank.indexWhere((u) => u.id == newCurrentUser.id);
    if (index == -1) {
      return;
    }

    usersRank[index].currentProgress = newCurrentUser.currentProgress;
    usersRank.sort((a, b) {
      return b.currentProgress.compareTo(a.currentProgress);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
