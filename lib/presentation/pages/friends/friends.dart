import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_yandex_map/presentation/blocs/friends/friends_bloc.dart';
import 'package:flutter_yandex_map/presentation/blocs/login/login_bloc.dart';
import 'package:flutter_yandex_map/presentation/blocs/map/map_bloc.dart';
import 'package:flutter_yandex_map/presentation/pages/login/login.dart';
import 'package:flutter_yandex_map/presentation/pages/map/map_screen.dart';
import 'package:flutter_yandex_map/presentation/ui_components/sign_out_dialog.dart';
import 'package:flutter_yandex_map/util/status.dart';

class Friends extends StatelessWidget {
  const Friends({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: const Text(
          'Friends',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          BlocBuilder<FriendsBloc, FriendsState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.language, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) => MapBloc()..add(ShowAllUsers(friends: state.friends)),
                        child: const MapScreen(),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            onPressed: () {
              onClickLogout(
                context,
                onUnRegister: () {},
                onLogout: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                                create: (context) => LoginBloc(),
                                child: LoginScreen(),
                              )));
                },
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<FriendsBloc, FriendsState>(
          builder: (context, state) {
            return switch (state.status) {
              Status.initial => const Center(
                  child: Text('Welcome'),
                ),
              Status.loading => Container(alignment: Alignment.center, child: const CircularProgressIndicator()),
              Status.success => RefreshIndicator(
                  onRefresh: () => _onRefresh(context),
                  child: ListView.builder(
                    itemCount: state.friends.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => MapBloc()..add(ShowOneFriend(friend: state.friends[index], friends: state.friends)),
                                child: const MapScreen(),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: Colors.blueAccent, width: 2.0),
                          ),
                          child: Row(
                            children: [
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: state.friends[index].image,
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => const Icon(Icons.person),
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.friends[index].name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    state.friends[index].email,
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              Status.failure => const Center(child: Text('Failed to load friends')),
            };
          },
        ),
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) {
    BlocProvider.of<FriendsBloc>(context).add(LoadFriendsEvent());
    return Future.value();
  }

  void onClickLogout(BuildContext context, {required VoidCallback onUnRegister, required VoidCallback onLogout}) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 5.0,
          backgroundColor: Colors.white,
          child: SignOutDialog(
            close: () {
              Navigator.of(ctx, rootNavigator: true).pop();
            },
            onUnRegister: onUnRegister,
            onLogout: onLogout,
          ),
        );
      },
    );
  }
}
