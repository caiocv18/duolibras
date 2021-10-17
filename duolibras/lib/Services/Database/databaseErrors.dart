import 'package:duolibras/Services/Models/appError.dart';

enum DatabaseErrors {
  GetUserError,
  GetModulesProgressError,
  SaveUserError,
  SaveModulesProgressError,
  CleanDatabaseError,
  Unknown
}

extension Exception on DatabaseErrors {
  AppErrorType get type => AppErrorType.DatabaseError;

  String get errorDescription {
    switch (this) {
      case DatabaseErrors.GetUserError:
        return "Erro ao buscar usuário no banco local";
      case DatabaseErrors.GetModulesProgressError:
        return "Erro ao buscar progresso dos módulos local";
      case DatabaseErrors.SaveUserError:
        return "Erro ao salvar usuário local";
      case DatabaseErrors.SaveModulesProgressError:
        return "Erro ao salvar progresso local";
      case DatabaseErrors.CleanDatabaseError:
        return "Erro ao limpar a base de dados";
      case DatabaseErrors.Unknown:
        return "Erro desconhecido";
    }
  }
}