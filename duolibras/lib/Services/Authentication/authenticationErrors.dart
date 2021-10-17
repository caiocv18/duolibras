import 'package:duolibras/Services/Models/appError.dart';

enum AuthenticationErrors {
  LoginFailed,
  LogoutFailed,
  Unknown
}

extension Exception on AuthenticationErrors {
  AppErrorType get type => AppErrorType.AuthenticationError;

  String get errorDescription {
    switch (this) {
      case AuthenticationErrors.LoginFailed:
        return "Ops, falha ao realizar login";
      case AuthenticationErrors.LogoutFailed:
        return "Ops, falha ao realizar logout";
      case AuthenticationErrors.Unknown:
        return "Erro desconhecido";
    }
  }
}
