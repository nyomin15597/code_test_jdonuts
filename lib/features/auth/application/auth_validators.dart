class AuthValidators {
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    var cleaned = value.replaceAll(RegExp(r'[\s-]'), '');
    if (cleaned.startsWith('0')) cleaned = cleaned.substring(1);
    if (!RegExp(r'^9\d{7,9}$').hasMatch(cleaned)) {
      return 'Invalid Myanmar phone number';
    }
    return null;
  }

  static String? validateName(String? value, {bool required = true}) {
    final name = value?.trim() ?? '';
    if (required && name.isEmpty) return 'First name is required';
    if (name.length > 50) return 'Name must be under 50 characters';
    if (name.isNotEmpty &&
        !RegExp(r'^[a-zA-Z\u1000-\u109F\s]+$').hasMatch(name)) {
      return 'Only letters, spaces and Myanmar script are allowed';
    }
    return null;
  }

  static String? validateDob(DateTime? dob) {
    if (dob == null) return 'Date of birth is required';
    final now = DateTime.now();
    if (dob.isAfter(now)) return 'Date cannot be in the future';
    var age = now.year - dob.year;
    if (DateTime(now.year, dob.month, dob.day).isAfter(now)) age--;
    if (age < 13) return 'You must be at least 13 years old';
    return null;
  }
}
