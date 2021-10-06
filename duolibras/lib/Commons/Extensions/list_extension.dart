extension ListExtensions<T> on List<T> {
  bool containsAt(int index) {
    return index >= 0 && this.length > index;
  }
}
