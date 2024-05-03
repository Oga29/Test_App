import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_oga/authentication/auth_bloc.dart';
import 'package:test_oga/support/support_request_bloc.dart';
import 'package:test_oga/authentication/auth_repository.dart';
import 'package:test_oga/support/support_request_repository.dart';
import 'package:test_oga/support/support_request_page.dart';
import 'package:test_oga/authentication/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(AuthRepository()),
        ),
        BlocProvider<SupportRequestBloc>(
          create: (context) => SupportRequestBloc(SupportRequestRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Служба Поддержки',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthCheck(),
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    authBloc.add(CheckAuthEvent());

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AuthAuthenticated) {
          return const SupportRequestPage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
