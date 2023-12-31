import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grad/modules/auth/register/provider/register_provider.dart';
import 'package:grad/modules/auth/register/provider/register_states.dart';
import 'package:grad/routes.dart';
import 'package:grad/shared/extensions.dart';
import 'package:grad/shared/strings.dart';
import 'package:grad/shared/widgets/input_field.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(registerProvider.notifier);
    final state = ref.watch(registerProvider);
    ref.listen(registerProvider, (previous, next) {
      if (next is RegisterSuccessState) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      } else if (next is RegisterErrorState) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.error),
        ));
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: provider.formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(context.radius(2)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppStrings.registerText,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  Text(AppStrings.registerDescriptionText,
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
                    label: AppStrings.nameText,
                    hint: AppStrings.nameHintText,
                    controller: provider.nameController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: context.heightPercent(2)),
                  InputField(
                    label: AppStrings.phoneText,
                    hint: AppStrings.phoneHintText,
                    controller: provider.phoneController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: context.heightPercent(2)),
                  InputField(
                    label: AppStrings.passwordText,
                    hint: AppStrings.passwordHintText,
                    obscureText: provider.obscurePass,
                    controller: provider.passwordController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: context.heightPercent(2)),
                  InputField(
                    label: AppStrings.confirmPasswordText,
                    hint: AppStrings.confirmPasswordHintText,
                    obscureText: provider.obscureConfirmPass,
                    controller: provider.confirmPasswordController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter your password again';
                      }
                      if (val != provider.passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
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
                        provider.register();
                      },
                      child: state is RegisterLoadingState
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : const Text(AppStrings.registerButtonText),
                    ),
                  ),
                  SizedBox(height: context.heightPercent(2)),
                  const Divider(),
                  Center(
                    child: Text.rich(TextSpan(
                        text: AppStrings.alreadyHaveAccountText,
                        children: [
                          TextSpan(
                              text: AppStrings.loginNowText,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pop();
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
    );
  }
}
