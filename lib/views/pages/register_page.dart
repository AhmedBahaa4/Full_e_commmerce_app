import 'package:e_commerc_app/utils/app_routes.dart';
import 'package:e_commerc_app/views/widgets/main_button.dart';
import 'package:e_commerc_app/views/widgets/social_media_bottom.dart';
import 'package:e_commerc_app/views_models/cubit/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/views/widgets/label_with_textfield_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerc_app/views_models/cubit/password_cubit/password_cubit_cubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cubit = BlocProvider.of<AuthCubit>(context);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Account',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    'Start your journey with us',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.grey),
                  ),
                  SizedBox(height: size.height * 0.02),
                  LabelWithTextField(
                    label: 'Username',
                    controller: _usernameController,
                    prefixIcon: Icons.person_outline,
                    hintText: 'Enter your username',
                    obsecureText: false,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  LabelWithTextField(
                    label: 'Email',
                    controller: _emailController,
                    prefixIcon: Icons.person_outline,
                    hintText: 'Enter your email',
                    obsecureText: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: size.height * 0.02),
                  BlocBuilder<PasswordCubit, PasswordState>(
                    builder: (context, state) {
                      final bool isVisible = state is PasswordVisibilityChanged
                          ? state.isVisible
                          : false;

                      return LabelWithTextField(
                        label: 'Password',
                        controller: _passwordController,
                        prefixIcon: Icons.lock,
                        hintText: 'Enter your password',
                        obsecureText: !isVisible,
                        keyboardType: TextInputType.visiblePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            context.read<PasswordCubit>().toggleVisibility();
                          },
                        ),
                      );
                    },
                  ),

                  SizedBox(height: size.height * 0.02),
                  BlocConsumer<AuthCubit, AuthState>(
                    bloc: cubit,
                    listenWhen: (previous, current) =>
                        current is AuthDone || current is AuthError,
                    listener: (context, state) {
                      if (state is AuthDone) {
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRoutes.homeroute);
                      } else if (state is AuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            closeIconColor: AppColors.primary,
                          ),
                        );
                      }
                    },
                    buildWhen: (previous, current) =>
                        current is AuthLoading ||
                        current is AuthError ||
                        current is AuthDone,
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return MainButton(isLoading: true);
                      }
                      return MainButton(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await cubit.registerWithEmailAndPassword(
                               
                              _emailController.text,
                               _passwordController.text,
                              _usernameController.text,
                            );
                          }
                        },
                        text: 'Create Account',
                      );
                    },
                  ),

                  SizedBox(height: size.height * 0.01),

                  Align(
                    alignment: AlignmentGeometry.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },

                          child: Text(
                            'Already have an account? Login',
                            style: Theme.of(context).textTheme.labelLarge!
                                .copyWith(color: AppColors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Or using other methods',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge!.copyWith(color: AppColors.grey),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  BlocConsumer<AuthCubit, AuthState>(
                    bloc: cubit,

                    listenWhen: (previous, current) =>
                        current is AuthDone || current is AuthError,
                    listener: (context, state) {
                      if (state is GoogleAuthDone) {
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRoutes.homeroute);
                      }
                      if (state is GoogleAuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            closeIconColor: AppColors.primary,
                          ),
                        );
                      }
                    },
                    buildWhen: (previous, current) =>
                        current is GoogleAuthenticating ||
                        current is GoogleAuthError ||
                        current is GoogleAuthDone,
                    builder: (context, state) {
                      if (state is GoogleAuthenticating) {
                        return const SocialMediaBottom(isLoading: true);
                      } else if (state is GoogleAuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            closeIconColor: AppColors.primary,
                          ),
                        );
                        return SocialMediaBottom(
                          imgurl:
                              'https://t4.ftcdn.net/jpg/03/91/79/25/360_F_391792593_BYfEk8FhvfNvXC5ERCw166qRFb8mYWya.jpg',
                          text: 'Google',
                          onTap: () async => await cubit.authWithGoogle(),
                          isLoading: false,
                        );
                      } else if (state is GoogleAuthDone) {
                        return SocialMediaBottom(
                          imgurl:
                              // 'https://upload.wikimedia.org/wikipedia/commons/4/4a/Logo_2013_Google.png',
                              'https://t4.ftcdn.net/jpg/03/91/79/25/360_F_391792593_BYfEk8FhvfNvXC5ERCw166qRFb8mYWya.jpg',
                          text: 'Google',

                          onTap: () async => await cubit.authWithGoogle(),
                          isLoading: false,
                        );
                      } else {
                        return SocialMediaBottom(
                          imgurl:
                              'https://t4.ftcdn.net/jpg/03/91/79/25/360_F_391792593_BYfEk8FhvfNvXC5ERCw166qRFb8mYWya.jpg',
                          text: 'Google',
                          onTap: () async => await cubit.authWithGoogle(),
                          isLoading: false,
                        );
                      }
                    },
                  ),
                  SizedBox(height: size.height * 0.02),
                  BlocConsumer<AuthCubit, AuthState>(
                    bloc: cubit,
                    listenWhen: (previous, current) => current is FacebookAuthDone || current is FacebookAuthError,
                    listener: (context, state) {
                      if (state is FacebookAuthDone) {
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRoutes.homeroute);
                      }
                      if (state is FacebookAuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            closeIconColor: AppColors.primary,
                          ),
                        );
                      }
                    },
                    buildWhen: (previous, current) =>
                        current is FacebookAuthenticating ||
                        current is FacebookAuthError ||
                        current is FacebookAuthDone,
                    builder: (context, state) {
                      if (state is FacebookAuthenticating) {
                        return const SocialMediaBottom(isLoading: true);
                      }
                      return SocialMediaBottom(
                        imgurl:
                            'https://upload.wikimedia.org/wikipedia/commons/0/05/Facebook_Logo_%282019%29.png',
                        text: ' sign up with Facebook',
                        onTap: () async => await cubit.authWithFacebook(),
                        isLoading: false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
