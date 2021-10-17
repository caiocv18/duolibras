enum AppErrorType {
  FirebaseError,
  DatabaseError,
  AuthenticationError,
  Unknown
}

class AppError { 
  final AppErrorType type;
  final String description;

  const AppError(this.type, this.description);
}