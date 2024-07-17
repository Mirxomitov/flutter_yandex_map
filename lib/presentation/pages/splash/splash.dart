import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_yandex_map/data/local/shared_pref_helper.dart';
import 'package:flutter_yandex_map/presentation/pages/login/login.dart';

import '../../../util/assets.dart';
import '../../blocs/friends/friends_bloc.dart';
import '../../blocs/login/login_bloc.dart';
import '../friends/friends.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), _navigateToNextScreen);
  }

  Future<void> _navigateToNextScreen() async {
    final isLoggedIn = await SharedPrefHelper.isLoggedIn();

    if (!isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => FriendsBloc()..add(LoadFriendsEvent()),
            child: const Friends(),
          ),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => LoginBloc(),
            child: LoginScreen(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Center(
          child: Image.asset(Assets.logo, height: 200, width: 200),
        ),
      ),
    );
  }
}
