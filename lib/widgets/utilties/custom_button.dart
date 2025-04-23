import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({Key? key, required this.text, this.color}) : super(key: key);

  final String text;
  final Color? color;

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FirebaseAuth.instance.sendPasswordResetEmail(
            email: "${FirebaseAuth.instance.currentUser?.email}");
      },
      child: Material(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xFF00BF63),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Center(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButton2 extends StatelessWidget {
  const CustomButton2({Key? key, required this.text, this.color})
      : super(key: key);

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Material(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xFF00BF63),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Center(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ),
    );
  }
}
