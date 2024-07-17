import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_yandex_map/presentation/blocs/friends/friends_bloc.dart';
import 'package:flutter_yandex_map/presentation/blocs/register/register_bloc.dart';
import 'package:flutter_yandex_map/presentation/ui_components/components.dart';

import '../../blocs/login/login_bloc.dart';
import '../friends/friends.dart';
import '../register/register.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.toRegister) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => RegisterBloc(),
                  child: const RegisterScreen(),
                ),
              ),
            );
          } else if (state.status == LoginStatus.success) {
            print('login success');
            // navigate to home screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (context) => FriendsBloc()..add(LoadFriendsEvent()),
                  child: const Friends(),
                ),
              ),
            );
          } else if (state.status == LoginStatus.failure) {
            print('login failed');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Login failed ${state.errorMessage}', style: const TextStyle(color: Colors.white)),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Spacer(),
                    //const ImagePickerWidget(),
                    const Spacer(),
                    const SizedBox(height: 20),
                    EmailField(fieldController: _emailController),
                    const SizedBox(height: 20),
                    PasswordField(
                      controller: _passwordController,
                    ),
                    const Spacer(),
                    Builder(builder: (context) {
                      if (state.status == LoginStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.status == LoginStatus.failure) {
                        return Column(children: [
                          /*Text(
                            state.errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),*/
                          Button(
                              text: "Login",
                              onPressed: () {
                                _onLoginPressed(context);
                              }),
                        ]);
                      }

                      return Button(
                        text: "Login",
                        onPressed: () {
                          _onLoginPressed(context);
                        },
                      );
                    }),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.grey.shade500),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (context) => RegisterBloc(),
                                      child: const RegisterScreen(),
                                    ),
                                  ),
                                );
                              },
                            text: "Sign up here",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 3),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onLoginPressed(BuildContext context) {
    final isConfirmed = Confirmation.confirmationWithSnackbar(
      _emailController,
      _passwordController,
      context,
    );
    if (isConfirmed) {
      context.read<LoginBloc>().add(
            LoginUserEvent(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }
}
