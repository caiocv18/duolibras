enum AppErrorType {
  FirebaseError,
  DatabaseError,
  AuthenticationError,
  FileServiceError,
  Unknown
}

class AppError { 
  final AppErrorType type;
  final String description;

  const AppError(this.type, this.description);
}