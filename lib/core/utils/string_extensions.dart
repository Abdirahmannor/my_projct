extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension NullableStringExtension on String? {
  String capitalize() {
    if (this == null || this!.isEmpty) {
      return '';
    }
    return "${this![0].toUpperCase()}${this!.substring(1).toLowerCase()}";
  }
}
