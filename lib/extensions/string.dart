extension StringExtension on String {
  bool get isValidEmail {
    var regex = RegExp(r"[A-Za-z0-9]+@[a-z]+\.([a-z]{2,3})");
    return regex.hasMatch(this);
  }
}
