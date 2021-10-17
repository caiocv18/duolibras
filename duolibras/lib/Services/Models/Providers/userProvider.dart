import 'package:duolibras/Commons/ViewModel/screenState.dart';
import 'package:duolibras/Commons/ViewModel/baseViewModel.dart';
import 'package:duolibras/Services/Models/moduleProgress.dart';
import 'package:duolibras/Services/Models/user.dart';

class UserModel extends BaseViewModel {
  User? _user;

  User get user {
    if (_user != null) {
      var user = User(
          name: _user!.name,
          email: _user!.email,
          id: _user!.id,
          currentProgress: _user!.currentProgress,
          imageUrl: _user!.imageUrl);
      user.modulesProgress = _user!.modulesProgress;
      return user;
    }

    return User(
        name: "", email: ",", id: "", currentProgress: 0, imageUrl: null);
  }

  void setNewUser(User newUser) {
    _user = newUser;
    setState(ScreenState.Normal);
  }

  void setImageUrl(String url) {
    if (_user != null) {
      _user!.imageUrl = url;
      setState(ScreenState.Normal);
    }
  }

  void setModulesProgress(ModuleProgress moduleProgress) {
    if (_user != null) {
      final index =
          _user!.modulesProgress.indexWhere((md) => md.id == moduleProgress.id);
      if (index != -1) {
        _user!.modulesProgress[index] = moduleProgress;
        setState(ScreenState.Normal);
        return;
      }
      _user!.modulesProgress.add(moduleProgress);
      setState(ScreenState.Normal);
    }
  }

  void setUserName(String name) {
    if (_user != null) {
      _user!.name = name;
      setState(ScreenState.Normal);
    }
  }
}
