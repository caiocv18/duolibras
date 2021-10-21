import 'package:duolibras/Services/Models/appError.dart';

enum FirebaseErrors {
  GetUserError,
  GetExercisesError,
  GetModulesError,
  GetSectionsError,
  GetTrailsError,
  GetRankingError,
  GetNumberOfExercisesError,
  GetSectionProgressError,
  GetDynamicAssetsError,
  PostSectionProgressError,
  PostUserError,
  UploadImageError,
  Unknown
}

extension Exception on FirebaseErrors {
  AppErrorType get type => AppErrorType.FirebaseError;

  String get errorDescription {
    switch (this) {
      case FirebaseErrors.GetUserError:
        return "Ops, erro ao buscar o usuário";
      case FirebaseErrors.GetExercisesError:
        return "Ops, erro ao buscar exercícios";
      case FirebaseErrors.GetModulesError:
        return "Ops, erro ao buscar módulos";
      case FirebaseErrors.GetSectionsError:
        return "Ops, erro ao buscar as seções";
      case FirebaseErrors.GetTrailsError:
        return "Ops, erro ao buscar trilhas";
      case FirebaseErrors.GetRankingError:
        return "Ops, erro ao buscar o ranking";
      case FirebaseErrors.GetNumberOfExercisesError:
        return "Ops, erro ao buscar a quantidade de exercícios";
      case FirebaseErrors.GetSectionProgressError:
        return "Ops, erro ao buscar o progresso das sections";
      case FirebaseErrors.GetDynamicAssetsError:
        return "Ops, erro ao buscar assets dinâmicos";
      case FirebaseErrors.PostSectionProgressError:
        return "Ops, erro ao enviar o progresso das sections";
      case FirebaseErrors.PostUserError:
        return "Ops, erro ao cadastrar o usuário";
      case FirebaseErrors.UploadImageError:
        return "Ops, erro ao fazer upload da imagem";
      case FirebaseErrors.Unknown:
        return "Erro desconhecido";
    }
  }
}
