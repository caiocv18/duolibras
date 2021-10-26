import 'package:duolibras/Commons/Components/exerciseButton.dart';
import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Modules/LearningModule/mainRouter.dart';
import 'package:duolibras/Modules/RankingModule/ViewModel/rankingViewModel.dart';
import 'package:duolibras/Modules/RankingModule/Widgets/rankingTile.dart';
import 'package:duolibras/Services/Models/Providers/userProvider.dart';
import 'package:duolibras/Services/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RankingScreen extends StatefulWidget {
  final _viewModel = RankingViewModel();
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
  void dispose() {
    widget._viewModel.disposeStreams();
    super.dispose();
  }

  Widget createRankingBody(BuildContext context) {
    if (widget._viewModel.firstTime) {
      widget._viewModel.fetchUsersRank(context);
    }
    final _mediaQuery = MediaQuery.of(context);

    final _containerHeight = _mediaQuery.size.height -
        (kBottomNavigationBarHeight +
            _mediaQuery.padding.bottom +
            _mediaQuery.padding.top +
            AppBar().preferredSize.height +
            20);

    return widget._viewModel.loading
        ? Center(
            child: Text("Carregando..."),
          )
        : Consumer(builder: (ctx, UserModel userModel, _) {
            sortUsersRanking(userModel.user);

            return Column(
              children: [
                SizedBox(height: 15),
                Container(
                  height: _containerHeight * 0.84,
                  child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 12),
                      itemCount: usersRank.length,
                      itemBuilder: (ctx, index) {
                        return RankingTile(
                            index: index,
                            user: usersRank[index],
                            viewModel: widget._viewModel);
                      }),
                ),
              ],
            );
          });
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

  Widget createUnllogedBody(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            SharedFeatures.instance.isLoggedIn ? "Loagado" : "Precisa Logar",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontFamily: "Nunito",
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: screenSize.width * 0.25,
            height: screenSize.height * 0.045,
            child: ExerciseButton(
              child: Center(
                child: Text(
                  "Sign In",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w400),
                ),
              ),
              size: 20,
              color: HexColor.fromHex("93CAFA"),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(MainRouter.routeSignIn)
                    .then((value) {
                  setState(() {});
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SharedFeatures.instance.isLoggedIn
            ? createRankingBody(context)
            : createUnllogedBody(context),
        color: HexColor.fromHex("E5E5E5"));
  }
}
