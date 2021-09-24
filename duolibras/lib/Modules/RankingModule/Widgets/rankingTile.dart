import 'package:duolibras/Modules/RankingModule/ViewModel/rankingViewModel.dart';
import 'package:duolibras/Network/Models/Provaiders/userProvider.dart';
import 'package:duolibras/Network/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RankingTile extends StatelessWidget {
  final int index;
  final User user;
  final RankingViewModelProtocol viewModel;

  RankingTile(
      {required this.index, required this.user, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserModel>(context, listen: true);
    final userModel = provider.user;

    return Card(
      color: userModel.id == user.id ? Colors.yellow : Colors.white,
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
                child: Consumer(builder: (_, UserModel userModel, __) {
                  if (userModel.user.id != user.id) {
                    return Container(height: 35, child: Icon(Icons.person));
                  }
                  if (userModel.user.imageUrl != null) {
                    return Container(
                        height: 55,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: new NetworkImage(
                                    userModel.user.imageUrl!))));
                  }

                  return Container(height: 55, child: Icon(Icons.person));
                }),
                radius: 25,
                backgroundColor: Colors.grey[400],
              ),
            ],
          ),
        ),
        title: Consumer(builder: (ctx, UserModel userModel, _) {
          return Text(
              viewModel.formatUserName(userModel.user.id == user.id
                  ? userModel.user.name
                  : user.name),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Theme.of(context).primaryColor),
              textAlign: TextAlign.left);
        }),
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
