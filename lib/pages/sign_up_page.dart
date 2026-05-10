import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/extensions/context_size.dart';
import '../core/extensions/context_theme.dart';
import '../core/validators/auth_validator.dart';
import '../providers/auth_provider.dart';
import '../states/request_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const .fromLTRB(16, 8, 16, 0),
        child: Form(
          key: formKey,
          child: Consumer<AuthProvider>(
            builder: (_, provider, _) {
              return Column(
                mainAxisAlignment: .start,
                crossAxisAlignment: .start,
                children: [
                  TextFormField(
                    controller: emailController,
                    keyboardType: .emailAddress,
                    validator: AuthValidator.emailValidator,
                    decoration: InputDecoration(
                      filled: true,
                      isDense: true,
                      border: OutlineInputBorder(borderSide: .none),
                      label: const Text('Email'),
                      hintText: 'Email',
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: .visiblePassword,
                    validator: AuthValidator.passwordValidator,
                    obscureText: provider.isPasswordVisible,
                    decoration: InputDecoration(
                      filled: true,
                      isDense: true,
                      suffixIcon: provider.isPasswordVisible
                          ? IconButton(
                              onPressed: provider.togglePasswordVisibility,
                              icon: Icon(Icons.visibility),
                            )
                          : IconButton(
                              onPressed: provider.togglePasswordVisibility,
                              icon: Icon(Icons.visibility_off),
                            ),
                      border: OutlineInputBorder(borderSide: .none),
                      label: Text('Password'),
                      hintText: 'Password',
                    ),
                  ),
                  SizedBox(height: 16),
                  FilledButton(
                    onPressed: onSignUpPressed,
                    style: FilledButton.styleFrom(
                      fixedSize: Size(context.maxWidth, 48),
                    ),
                    child: provider.state != RequestState.loading
                        ? const Text('Sign Up')
                        : CircularProgressIndicator(
                            color: context.colorScheme.onPrimary,
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> onSignUpPressed() async {
    if (formKey.currentState!.validate()) {
      final provider = context.read<AuthProvider>();

      await provider.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (mounted) {
        if (provider.state == RequestState.error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(provider.errorMessage)));
        } else {
          Navigator.pop(context);
        }
      }
    }
  }
}
