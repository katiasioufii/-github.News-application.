import 'package:flutter/material.dart';

class CustomTag extends StatefulWidget {
  const CustomTag({
    Key? key,
    required this.backgroundColor,
    required this.children,
  }) : super(key: key);

  final Color backgroundColor;
  final List<Widget> children;

  @override
  State<CustomTag> createState() => _CustomTagState();
}

class _CustomTagState extends State<CustomTag> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.children,
      ),
    );
  }
}
