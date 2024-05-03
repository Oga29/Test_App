import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_oga/authentication/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController(text: '7015557400');
  final TextEditingController passwordController = TextEditingController(text: 'abcd1234');

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Номер телефона',
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Пароль',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final phone = phoneController.text;
                final password = passwordController.text;
                BlocProvider.of<AuthBloc>(context).add(LoginEvent(phone, password));
              },
              child: const Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }
}
