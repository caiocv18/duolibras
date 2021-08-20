enum FirebaseErrors { UserNotFound }

extension Exception on FirebaseErrors {
  String get errorDescription {
    switch (this) {
      case FirebaseErrors.UserNotFound:
        return "User not found";
    }
  }
}
