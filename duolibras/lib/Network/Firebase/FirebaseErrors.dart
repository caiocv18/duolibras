enum FirebaseErrors {
  UserNotFound,
  ExerciseNotFound,
  ModuleNotFound,
  SectionNotFound,
  TrailNotFound
}

extension Exception on FirebaseErrors {
  String get errorDescription {
    switch (this) {
      case FirebaseErrors.UserNotFound:
        return "User not found";
      case FirebaseErrors.ExerciseNotFound:
        return "Exercise not found";
      case FirebaseErrors.ModuleNotFound:
        return "Module not found";
      case FirebaseErrors.SectionNotFound:
        return "Section not found";
      case FirebaseErrors.TrailNotFound:
        return "Trail not found";
    }
  }
}
