class NoteValidator {
  static String? textValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tidak boleh kosong';
    } else {
      return null;
    }
  }
}
