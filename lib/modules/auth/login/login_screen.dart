import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grad/modules/auth/login/provider/login_provider.dart';
import 'package:grad/modules/auth/login/provider/login_states.dart';
import 'package:grad/routes.dart';
import 'package:grad/shared/extensions.dart';
import 'package:grad/shared/strings.dart';
import 'package:grad/shared/widgets/input_field.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(loginProvider.notifier);
    final state = ref.watch(loginProvider);
    ref.listen(loginProvider, (previous, next) {
      if (next is LoginSuccessState) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      } else if (next is LoginErrorState) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.error),
        ));
      }
    });
    return Scaffold(
      body: Form(
        key: provider.formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            height: context.height,
            child: Padding(
              padding: EdgeInsets.all(context.radius(2)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(AppStrings.loginText,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    Text(AppStrings.loginDescriptionText,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.secondary,
                        )),
                    SizedBox(height: context.heightPercent(5)),
                    InputField(
                      label: AppStrings.emailText,
                      hint: AppStrings.emailHintText,
                      controller: provider.emailController,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: context.heightPercent(2)),
                    InputField(
                      label: AppStrings.passwordText,
                      hint: AppStrings.passwordHintText,
                      obscureText: provider.obscureText,
                      controller: provider.passwordController,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        onPressed: provider.changePasswordVisibility,
                        icon: Icon(provider.obscureText
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {},
                          child: Text(
                            AppStrings.forgotPasswordText,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                          )),
                    ),
                    SizedBox(height: context.heightPercent(2)),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(context.radius(0.5)),
                          ),
                        ),
                        onPressed: () {
                          provider.login();
                        },
                        child: state is LoginLoadingState
                            ? const Center(
                                child: CircularProgressIndicator.adaptive(),
                              )
                            : const Text(AppStrings.loginButtonText),
                      ),
                    ),
                    SizedBox(height: context.heightPercent(2)),
                    const Divider(),
                    Center(
                      child: Text.rich(TextSpan(
                          text: AppStrings.dontHaveAccountText,
                          children: [
                            TextSpan(
                                text: AppStrings.registerNowText,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context)
                                        .pushNamed(AppRoutes.register);
                                  },
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.bold))
                          ])),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
