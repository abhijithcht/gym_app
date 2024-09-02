import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/constants/text_string.dart';

import '../../utilities/custom_button.dart';
import '../../utilities/custom_snack.dart';
import '../../utilities/custom_textfield.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  final TextEditingController loginEmail = TextEditingController();
  final TextEditingController loginPassword = TextEditingController();

  Future<void> signin() async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: loginEmail.text,
        password: loginPassword.text,
      );

      if (userCredential.user != null) {
        if (!mounted) return;
        await Navigator.pushNamed(context, '/homepage');
      } else {
        _showSnackBar(GymText.signInError);
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == GymText.userNotFoundError) {
          _showSnackBar(GymText.noUserError);
        } else if (e.code == GymText.wrongPasswordShortError) {
          _showSnackBar(GymText.wrongPasswordError);
        } else {
          _showSnackBar(GymText.exeptionError + e.toString());
        }
      } else {
        _showSnackBar(GymText.otherError + e.toString());
      }
      _showSnackBar(GymText.signInError);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        message: message,
      ),
    );
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return GymText.fillFields;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    GymText.helloSignin,
                    style: TextStyle(fontSize: 35),
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextInputField(
                  controller: loginEmail,
                  hintText: GymText.emailCaps,
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateInput,
                  textCapitalization: TextCapitalization.none,
                ),
                CustomTextInputField(
                  controller: loginPassword,
                  hintText: GymText.password,
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  validator: _validateInput,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  text: GymText.signin,
                  onPressed: () async {
                    if (loginEmail.text.isEmpty || loginPassword.text.isEmpty) {
                      _showSnackBar(GymText.emptyError);
                    } else {
                      await signin();
                    }
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      GymText.notMember,
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        GymText.registerNow,
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
