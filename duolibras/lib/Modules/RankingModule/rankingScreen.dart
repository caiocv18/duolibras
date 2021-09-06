import 'package:duolibras/Commons/Utils/globals.dart';
import 'package:duolibras/Modules/LearningModule/mainRouter.dart';
import 'package:duolibras/Modules/RankingModule/ViewModel/rankingViewModel.dart';
import 'package:duolibras/Modules/RankingModule/Widgets/rankingTile.dart';
import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:duolibras/Network/Models/User.dart';
import 'package:flutter/material.dart';

class RankingScreen extends StatefulWidget {
  final _viewModel = RankingViewModel();
  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<User> usersRank = [];

  @override
  initState() {
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
      widget._viewModel.fetchUsersRank();
    }
    final _mediaQuery = MediaQuery.of(context);

    final _containerHeight = _mediaQuery.size.height -
        (kBottomNavigationBarHeight +
            _mediaQuery.padding.bottom +
            _mediaQuery.padding.top);

    return widget._viewModel.loading
        ? Center(
            child: Text("Carregando..."),
          )
        : Column(
            children: [
              SizedBox(height: 10),
              Text("Ranking Mundial",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Theme.of(context).primaryColor),
                  textAlign: TextAlign.center),
              SizedBox(height: 15),
              Container(
                height: _containerHeight * 0.8,
                child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 10),
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
  }

  Widget createUnllogedBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              SharedFeatures.instance.isLoggedIn ? "Loagado" : "precisa logar"),
          SizedBox(height: 15),
          ElevatedButton(
            child: Text("Sign In"),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(MainRouter.routeSignIn)
                  .then((value) {
                setState(() {});
                ;
              });
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.blue)))),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SharedFeatures.instance.isLoggedIn
          ? createRankingBody(context)
          : createUnllogedBody(),
    );
  }
}
