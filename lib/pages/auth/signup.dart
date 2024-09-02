import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_app/constants/text_string.dart';

import '../../utilities/custom_button.dart';
import '../../utilities/custom_snack.dart';
import '../../utilities/custom_textfield.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController owner = TextEditingController();
  final TextEditingController gym = TextEditingController();
  final TextEditingController description = TextEditingController();

  // Show SnackBar with a given message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        message: message,
      ),
    );
  }

  Future<void> signup() async {
    if (password.text != confirmPassword.text) {
      _showSnackBar(GymText.passwordMismatchError);
      return;
    }

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      )
          .then((value) {
        _showSnackBar(GymText.userRegistered);
        db.collection(GymText.adminCollection).add({
          GymText.owner: owner.text,
          GymText.gym: gym.text,
          GymText.description: description.text,
          GymText.email: email.text,
          GymText.uid: auth.currentUser!.uid
        });
      });
      _clearTextFields();

      if (!mounted) return;
      await Navigator.pushNamed(context, '/homepage');
    } on FirebaseAuthException catch (e) {
      if (e.code == GymText.weakPasswordError) {
        _showSnackBar(GymText.weakPasswordError);
      } else if (e.code == GymText.emailInUse) {
        _showSnackBar(GymText.emailInUseError);
      } else {
        _showSnackBar(GymText.registrationError + e.toString());
      }
    } catch (e) {
      _showSnackBar(GymText.registrationError + e.toString());
    }
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return GymText.fillFields;
    }
    return null;
  }

  void _clearTextFields() {
    email.clear();
    password.clear();
    confirmPassword.clear();
    owner.clear();
    gym.clear();
    description.clear();
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
                    GymText.helloSignup,
                    style: TextStyle(fontSize: 35),
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextInputField(
                  controller: owner,
                  validator: _validateInput,
                  hintText: GymText.ownerName,
                  prefixIcon: Icons.person,
                  keyboardType: TextInputType.name,
                ),
                CustomTextInputField(
                  controller: gym,
                  validator: _validateInput,
                  hintText: GymText.gymName,
                  prefixIcon: Icons.fitness_center_rounded,
                ),
                CustomTextInputField(
                  controller: description,
                  validator: _validateInput,
                  hintText: GymText.descriptionName,
                  prefixIcon: Icons.description_rounded,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(200),
                  ],
                ),
                CustomTextInputField(
                  controller: email,
                  validator: _validateInput,
                  hintText: GymText.emailCaps,
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                ),
                CustomTextInputField(
                  controller: password,
                  validator: _validateInput,
                  hintText: GymText.password,
                  prefixIcon: Icons.lock,
                  obscureText: true,
                ),
                CustomTextInputField(
                  controller: confirmPassword,
                  validator: _validateInput,
                  hintText: GymText.confirmPassword,
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  text: GymText.signup,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      signup();
                    }
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      GymText.alreadyMember,
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signin');
                      },
                      child: const Text(
                        GymText.loginNow,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
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
