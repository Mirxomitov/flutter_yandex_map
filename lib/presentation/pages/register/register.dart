import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_yandex_map/presentation/ui_components/components.dart';

import '../../../data/model/app_lat_long.dart';
import '../../../data/remote/services/location_service.dart';
import '../../../util/status.dart';
import '../../blocs/friends/friends_bloc.dart';
import '../../blocs/register/register_bloc.dart';
import '../friends/friends.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const ImagePickerWidget(),
                    const SizedBox(height: 20),
                    TextFieldWidget(hintText: "Email", fieldController: state.emailController, inputType: TextInputType.emailAddress),
                    const SizedBox(height: 20),
                    TextFieldWidget(hintText: "Username", fieldController: state.userNameController),
                    const SizedBox(height: 20),
                    PasswordField(controller: state.passwordController),
                    const SizedBox(height: 20),
                    PasswordField(controller: state.confirmPasswordController, hintText: 'Confirm password'),
                    const SizedBox(height: 20),
                    BlocListener<RegisterBloc, RegisterState>(
                      listener: (context, state) {
                        final isRegistered = state.isRegistered;
                        if (!isRegistered) {
                          SnackBarService.replaceSnackBar(context, 'Register failed please try again');
                        } else {
                          Navigator.pushAndRemoveUntil<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => BlocProvider(
                                create: (context) => FriendsBloc()..add(LoadFriendsEvent()),
                                child: const Friends(),
                              ),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      child: Builder(builder: (context) {
                        if (state.status == Status.loading) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        return Button(
                          text: "Register",
                          onPressed: () => onRegisterPressed(
                            context: context,
                            emailController: state.emailController,
                            passwordController: state.passwordController,
                            confirmPasswordController: state.confirmPasswordController,
                            userNameController: state.userNameController,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      // how to control here in text span on click text "sing up here"
                      // A:
                      text: TextSpan(
                        text: "Do you have an account? ",
                        style: TextStyle(color: Colors.grey.shade500),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(context);
                              },
                            text: "Log in",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> onRegisterPressed({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    required TextEditingController userNameController,
  }) async {
    print('register pressed 1');

    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    final location = await _fetchCurrentLocation();

    print('register pressed 2');

    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      SnackBarService.showSnackBar(context, 'Password and confirm password must be the same');
      return;
    }

    print('register pressed 3');

    final isConfirmed = Confirmation.confirmationWithSnackbar(emailController, passwordController, context);
    if (!isConfirmed) return;

    print('register pressed 4');

    if (context.read<RegisterBloc>().state.pickedImage == null) {
      SnackBarService.showSnackBar(context, 'Please pick an image');
      return;
    }

    context.read<RegisterBloc>().add(
          RegisterUser(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            userName: userNameController.text.trim(),
            image: context.read<RegisterBloc>().state.pickedImage!,
            location: location,
          ),
        );
  }

  Future<AppLatLong> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = TashkentLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }

    return location;
  }
}
