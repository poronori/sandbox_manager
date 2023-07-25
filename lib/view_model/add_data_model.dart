class ValidateText {
  static String? validate(String? value) {
    if (value == null) {
      return '値が未設定です';
    }
    if (value.isEmpty) {
      return '値が未設定です';
    }
    if (value.length > 8) {
      return '7桁以下にしてください';
    }

    return null;
  }
}