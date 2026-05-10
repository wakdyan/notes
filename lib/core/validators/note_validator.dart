class NoteValidator {
  static String? textValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please fill in this field';
    } else {
      return null;
    }
  }
}
