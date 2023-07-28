class ValidateText {
  static String? validate(String? value) {
    if (value == null) {
      return '値が未設定です';
    }
    if (value.isEmpty) {
      return '値が未設定です';
    }
    if (RegExp(r'-?[0-9]{8}').hasMatch(value)) {
      return '7桁以下にしてください';
    }

    return null;
  }
}