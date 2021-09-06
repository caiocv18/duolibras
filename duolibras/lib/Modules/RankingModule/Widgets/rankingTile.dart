import 'package:duolibras/Modules/RankingModule/ViewModel/rankingViewModel.dart';
import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:duolibras/Network/Models/User.dart';
import 'package:flutter/material.dart';

class RankingTile extends StatelessWidget {
  final int index;
  final User user;
  final RankingViewModelProtocol viewModel;

  RankingTile(
      {required this.index, required this.user, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: UserSession.instance.user.id == user.id
          ? Colors.yellow
          : Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      elevation: 6,
      child: ListTile(
        leading: Container(
          width: 80,
          child: Row(
            children: [
              Text("${index + 1}"),
              SizedBox(width: 5),
              CircleAvatar(
                child: Container(height: 35, child: Icon(Icons.person)),
                radius: 25,
                backgroundColor: Colors.grey[400],
              ),
            ],
          ),
        ),
        title: Text(viewModel.formatUserName(user.name),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Theme.of(context).primaryColor),
            textAlign: TextAlign.left),
        trailing: Container(
          width: 100,
          child: Text("${user.currentProgress} xp",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Theme.of(context).primaryColor),
              textAlign: TextAlign.left),
        ),
      ),
    );
  }
}
