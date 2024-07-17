import 'package:flutter/material.dart';
import 'package:flutter_yandex_map/presentation/ui_components/snack_bar_service.dart';

class Confirmation {
  static bool confirmationWithSnackbar(TextEditingController emailController, TextEditingController passwordController, context) {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      SnackBarService.showSnackBar(context, "Email and password must not be empty");
      return false;
    }

    // email confirmation code
    final email = emailController.text;
    final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailPattern.hasMatch(email)) {
      SnackBarService.showSnackBar(context, "Email is not valid");
      return false;
    }

    // password length should be at least 6 characters
    if (passwordController.text.length < 6) {
      SnackBarService.showSnackBar(context, "Password must be at least 6 characters");
      return false;
    }

    return true;
  }
}
