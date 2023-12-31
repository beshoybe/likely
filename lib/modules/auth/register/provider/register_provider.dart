import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grad/modules/auth/register/provider/register_states.dart';

final registerProvider =
    StateNotifierProvider<RegisterProvider, RegisterStates>(
  (ref) => RegisterProvider(),
);

class RegisterProvider extends StateNotifier<RegisterStates> {
  RegisterProvider() : super(RegisterInitialState());

  bool obscurePass = true;
  bool obscureConfirmPass = true;
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  void changePasswordVisibility() {
    obscurePass = !obscurePass;
    state = RegisterChangePasswordVisibilityState();
  }

  void changeConfirmPasswordVisibility() {
    obscureConfirmPass = !obscureConfirmPass;
    state = RegisterChangeConfirmPasswordVisibilityState();
  }

  Future<void> register() async {
    if (state is RegisterLoadingState) {
      return;
    }
    if (formKey.currentState!.validate()) {
      try {
        final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        cred.user!.updateDisplayName(nameController.text);
        final fireStore = FirebaseFirestore.instance;
        await fireStore.collection('users').doc(cred.user!.uid).set({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'image': '',
          'balance': 0,
        });
        state = RegisterSuccessState();
      } on FirebaseAuthException catch (e) {
        print(e.message);

        state = RegisterErrorState(e.message.toString());
      }
    } else {
      state = RegisterValidateState();
    }
  }
}
