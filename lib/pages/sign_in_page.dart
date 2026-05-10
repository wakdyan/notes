import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/app_page.dart';
import '../core/extensions/context_size.dart';
import '../core/extensions/context_theme.dart';
import '../core/validators/auth_validator.dart';
import '../providers/auth_provider.dart';
import '../states/request_state.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
      body: SizedBox.expand(
        child: Image.asset(
          'assets/bellahu123-notebook-6981538.jpg',
          fit: .cover,
        ),
      ),
      bottomSheet: buildBottomSheet(),
    );
  }

  Widget buildBottomSheet() {
    return BottomSheet(
      showDragHandle: true,
      enableDrag: false,
      onClosing: () {},
      builder: (_) {
        return SingleChildScrollView(
          padding: const .fromLTRB(24, 0, 24, 24),
          child: Form(
            key: formKey,
            autovalidateMode: .onUserInteraction,
            child: Consumer<AuthProvider>(
              builder: (context, provider, _) {
                return Column(
                  mainAxisSize: .min,
                  children: [
                    TextFormField(
                      controller: emailController,
                      keyboardType: .emailAddress,
                      validator: AuthValidator.emailValidator,
                      decoration: InputDecoration(
                        filled: true,
                        isDense: true,
                        border: OutlineInputBorder(borderSide: .none),
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
                        hintText: 'Password',
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: .symmetric(vertical: 4),
                      child: FilledButton(
                        onPressed: onSignInPressed,
                        style: FilledButton.styleFrom(
                          fixedSize: Size(context.maxWidth, 48),
                        ),
                        child: provider.state == RequestState.loading
                            ? CircularProgressIndicator(
                                color: context.colorScheme.onPrimary,
                              )
                            : const Text('Sign In'),
                      ),
                    ),
                    Padding(
                      padding: .symmetric(vertical: 4),
                      child: OutlinedButton(
                        onPressed: navigateToSignUpPage,
                        style: OutlinedButton.styleFrom(
                          fixedSize: Size(context.maxWidth, 48),
                        ),
                        child: const Text('Sign Up'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> onSignInPressed() async {
    if (formKey.currentState!.validate()) {
      final provider = context.read<AuthProvider>();

      await provider.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (mounted) {
        if (provider.state == RequestState.error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(provider.errorMessage)));
        }
      }
    }
  }

  void navigateToSignUpPage() {
    Navigator.pushNamed(context, AppRoutes.signUp);
  }
}
