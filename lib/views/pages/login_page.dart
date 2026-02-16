import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/utils/app_routes.dart';
import 'package:e_commerc_app/views/widgets/auth_form_field.dart';
import 'package:e_commerc_app/views/widgets/auth_screen_shell.dart';
import 'package:e_commerc_app/views/widgets/main_button.dart';
import 'package:e_commerc_app/views/widgets/social_media_bottom.dart';
import 'package:e_commerc_app/views_models/cubit/auth_cubit/auth_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/password_cubit/password_cubit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F3FA),
        body: BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              current is AuthDone ||
              current is AuthError ||
              current is GoogleAuthDone ||
              current is GoogleAuthError ||
              current is FacebookAuthDone ||
              current is FacebookAuthError,
          listener: (context, state) {
            if (state is AuthDone ||
                state is GoogleAuthDone ||
                state is FacebookAuthDone) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.homeroute);
              return;
            }

            if (state is AuthError) {
              _showError(context, state.message);
            } else if (state is GoogleAuthError) {
              _showError(context, state.message);
            } else if (state is FacebookAuthError) {
              _showError(context, state.message);
            }
          },
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final isEmailLoading = state is AuthLoading;
              final isGoogleLoading = state is GoogleAuthenticating;
              final isFacebookLoading = state is FacebookAuthenticating;

              return AuthScreenShell(
                title: 'Welcome Back',
                subtitle: 'Sign in to continue shopping with your account.',
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthFormField(
                        label: 'Email',
                        hint: 'Enter your email',
                        controller: _emailController,
                        prefixIcon: Icons.email_outlined,
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 14),
                      BlocBuilder<PasswordCubit, PasswordState>(
                        builder: (context, passwordState) {
                          final isVisible =
                              passwordState is PasswordVisibilityChanged
                              ? passwordState.isVisible
                              : false;

                          return AuthFormField(
                            label: 'Password',
                            hint: 'Enter your password',
                            controller: _passwordController,
                            prefixIcon: Icons.lock_outline,
                            obscureText: !isVisible,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            validator: _validatePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                isVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                context
                                    .read<PasswordCubit>()
                                    .toggleVisibility();
                              },
                            ),
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot password?',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(color: AppColors.primary),
                          ),
                        ),
                      ),
                      MainButton(
                        text: isEmailLoading ? 'Signing In...' : 'Login',
                        onTap: isEmailLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  await cubit.loginWithEmailAndPassword(
                                    _emailController.text.trim(),
                                    _passwordController.text,
                                  );
                                }
                              },
                        backgroundColor: isEmailLoading
                            ? const Color(0xFF9E96C9)
                            : AppColors.primary,
                      ),
                      const SizedBox(height: 18),
                      const _AuthDivider(),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: SocialMediaBottom(
                              imgurl:
                                  'https://t4.ftcdn.net/jpg/03/91/79/25/360_F_391792593_BYfEk8FhvfNvXC5ERCw166qRFb8mYWya.jpg',
                              text: 'Google',
                              onTap: () async => cubit.authWithGoogle(),
                              isLoading: isGoogleLoading,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SocialMediaBottom(
                              imgurl:
                                  'https://upload.wikimedia.org/wikipedia/commons/0/05/Facebook_Logo_%282019%29.png',
                              text: 'Facebook',
                              onTap: () async => cubit.authWithFacebook(),
                              isLoading: isFacebookLoading,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.register);
                          },
                          child: Text(
                            'Don\'t have an account? Register',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final email = value.trim();
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}

class _AuthDivider extends StatelessWidget {
  const _AuthDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE2E2EE))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'or continue with',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: const Color(0xFF8D8DA1)),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE2E2EE))),
      ],
    );
  }
}
