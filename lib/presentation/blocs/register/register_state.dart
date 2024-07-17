part of 'register_bloc.dart';

class RegisterState {
  final Status status;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController userNameController;
  final XFile? pickedImage;
  final bool isRegistered;

  RegisterState({
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.userNameController,
    required this.isRegistered,
    this.pickedImage,
    required this.status,
  });

  factory RegisterState.initial() {
    return RegisterState(
      emailController: TextEditingController()..text = 'test2@gmail.com',
      passwordController: TextEditingController()..text = '123456',
      confirmPasswordController: TextEditingController()..text = '123456',
      pickedImage: null,
      userNameController: TextEditingController()..text = 'Test',
      isRegistered: false,
      status: Status.initial,
    );
  }

  RegisterState copyWith({
    TextEditingController? emailController,
    TextEditingController? passwordController,
    TextEditingController? confirmPasswordController,
    TextEditingController? userNameController,
    XFile? pickedImage,
    bool? isRegistered,
    Status? status,
  }) {
    return RegisterState(
      emailController: emailController ?? this.emailController,
      passwordController: passwordController ?? this.passwordController,
      confirmPasswordController: confirmPasswordController ?? this.confirmPasswordController,
      userNameController: userNameController ?? this.userNameController,
      pickedImage: pickedImage ?? this.pickedImage,
      isRegistered: isRegistered ?? this.isRegistered,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RegisterState &&
        other.emailController == emailController &&
        other.passwordController == passwordController &&
        other.confirmPasswordController == confirmPasswordController &&
        other.userNameController == userNameController &&
        other.pickedImage == pickedImage &&
        other.status == status &&
        other.isRegistered == isRegistered;
  }

  @override
  int get hashCode {
    return emailController.hashCode ^
        passwordController.hashCode ^
        confirmPasswordController.hashCode ^
        pickedImage.hashCode ^
        isRegistered.hashCode ^
        status.hashCode ^
        userNameController.hashCode;
  }

  @override
  String toString() {
    return 'RegisterState(emailController: $emailController, passwordController: $passwordController, confirmPasswordController: $confirmPasswordController, userNameController: $userNameController, pickedImage: $pickedImage, isRegistered: $isRegistered, status: $status,)';
  }
}
