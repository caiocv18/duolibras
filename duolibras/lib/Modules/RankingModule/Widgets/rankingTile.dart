import 'package:duolibras/Commons/Components/exerciseButton.dart';
import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:duolibras/Modules/RankingModule/ViewModel/rankingViewModel.dart';
import 'package:duolibras/Services/Models/Providers/userProvider.dart';
import 'package:duolibras/Services/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RankingTile extends StatelessWidget {
  final int index;
  final User user;
  final RankingViewModelProtocol viewModel;

  RankingTile(
      {required this.index, required this.user, required this.viewModel});

  Widget _imageUserWidget(UserModel userModel) {
    if (userModel.user.id == user.id) {
      if (user.imageUrl == null) {
        return Container(height: 35, child: Icon(Icons.person));
      }
      return Container(
          height: 55,
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.cover,
                  image: new NetworkImage(userModel.user.imageUrl!))));
    }
    if (user.imageUrl == null) {
      return Container(height: 35, child: Icon(Icons.person));
    }
    return Container(
        height: 55,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.cover, image: new NetworkImage(user.imageUrl!))));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserModel>(context, listen: true);
    final userModel = provider;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 12),
      child: ExerciseButton(
        child: ListTile(
            leading: Container(
                child: 
                  CircleAvatar(
                    child: _imageUserWidget(userModel),
                    radius: 25,
                    backgroundColor: Colors.grey[400],
                  ),
            ),
            title: Container(
              child: Text(
                  viewModel.formatUserName(userModel.user.id == user.id
                      ? userModel.user.name
                      : user.name),
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                  maxLines: 1),
            ),
            trailing: Container(
              width: 50,
              child: Text(
                  "${userModel.user.id == user.id ? userModel.user.currentProgress : user.currentProgress} pts",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.left),
            ),
        ),
        size: 25,
        color: HexColor.fromHex("93CAFA"),
        backgroundColor: userModel.user.id == user.id
            ? HexColor.fromHex("4982F6")
            : Colors.white,
      ),
    );
  }
}
