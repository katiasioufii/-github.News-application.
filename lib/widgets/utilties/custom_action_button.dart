import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final Function()? onTap;
  final String hintText;

  const CustomActionButton({
    super.key,
    required this.onTap,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Color(0xFF00BF63),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            hintText,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
