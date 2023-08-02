class ValidateText {
  static String? validate(String? value) {
    if (value == null) {
      return '値が未設定です';
    }
    if (value.isEmpty) {
      return '値が未設定です';
    }
    if (RegExp(r'^-$').hasMatch(value)) {
      return '数字を入力してください';
    }
    if (RegExp(r'^-?[0-9]{8}$').hasMatch(value)) {
      return '7桁以下にしてください';
    }
    if (RegExp(r'^-?[0-9]{1,7}$').hasMatch(value)) {
      return null;
    }
    return '数値が不正です';
  }
}