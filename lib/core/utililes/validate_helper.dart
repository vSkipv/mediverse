class ValidationHelper {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r"^(011|012|010|015)[0-9]{8}$");
    return phoneRegex.hasMatch(phone);
  }
}