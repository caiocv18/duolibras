import 'package:duolibras/Network/Authentication/Firebase/FirebaseAuthenticator.dart';
import 'package:duolibras/Network/Authentication/UserSession.dart';
import 'package:duolibras/Network/Service.dart';

abstract class SignUpViewModelProtocol {
  Future<bool> signUpInFirebase(String email, String password);
  String? validateEmailInput(String? email);
  String? validatePasswordInput(String? password);
}

class SignUpViewModel extends SignUpViewModelProtocol {
  @override
  Future<bool> signUpInFirebase(String email, String password) async {
    await FirebaseAuthenticator.handleSignUp(email, password);

    return Service.instance.getUser().then((userUpdated) {
      UserSession.instance.user = userUpdated;
      return true;
    });
  }

  String? validateEmailInput(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  @override
  String? validatePasswordInput(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }
}
