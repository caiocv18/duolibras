enum SQLiteDatabaseErrors {
  UserError,
  ModuleProgressError
}

extension Exception on SQLiteDatabaseErrors {
  String get errorDescription {
    switch (this) {
      case SQLiteDatabaseErrors.UserError:
        return "User error";
      case SQLiteDatabaseErrors.ModuleProgressError:
        return "Module Progress Error";
    }
  }
}