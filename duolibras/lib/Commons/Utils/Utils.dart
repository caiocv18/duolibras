T tryCast<T>(dynamic x, {required T fallback}) {
  try {
    return (x as T);
  } on TypeError catch (e) {
    print('CastError when trying to cast $x to $T!');
    return fallback;
  }
}
